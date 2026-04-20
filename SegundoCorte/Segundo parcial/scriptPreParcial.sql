-- =====================================================
-- PREGUNTA 1
-- Agregue a la tabla pedidos una columna total_valor DECIMAL(12,2) generada 
-- automáticamente como la multiplicacion de cantidad por el precio del producto 
-- (columna calculada persistida con AS ... STORED, o en su defecto agréguela como 
-- columna normal y luego actualice su valor mediante un UPDATE con JOIN entre 
-- pedidos y productos). Finalmente, agregue un índice sobre la columna estado.
-- =====================================================

ALTER TABLE pedidos ADD COLUMN total_valor DECIMAL(12,2);

UPDATE pedidos p
JOIN productos pr ON p.producto_id = pr.producto_id
SET p.total_valor = p.cantidad * pr.precio;

CREATE INDEX idx_estado ON pedidos(estado);

-- =====================================================
-- PREGUNTA 2
-- Cree la tabla log_cambios_estado (log_id PK AI, pedido_id FK, estado_anterior 
-- VARCHAR(20), estado_nuevo VARCHAR(20), fecha_cambio DATETIME DEFAULT NOW()). 
-- A continuación, cree una vista llamada vista_log_reciente que muestre los 
-- últimos 10 registros de log_cambios_estado ordenados por fecha_cambio descendente.
-- =====================================================

CREATE TABLE log_cambios_estado (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    estado_anterior VARCHAR(20),
    estado_nuevo VARCHAR(20),
    fecha_cambio DATETIME DEFAULT NOW(),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

CREATE VIEW vista_log_reciente AS
SELECT log_id, pedido_id, estado_anterior, estado_nuevo, fecha_cambio
FROM log_cambios_estado
ORDER BY fecha_cambio DESC
LIMIT 10;

-- =====================================================
-- PREGUNTA 3
-- Realice las siguientes operaciones en una misma sesión: (a) Inserte un nuevo 
-- cliente (nombre=Laura Rios, email=laura@mail.com, ciudad=Manizales). (b) Inserte 
-- un pedido para ese cliente del producto_id=3 con cantidad=2 y estado=pendiente. 
-- (c) Actualice el stock del producto_id=3 decrementandolo en 2. (d) Consulte con 
-- un JOIN el nombre del cliente, nombre del producto y estado del pedido recién creado.
-- =====================================================

INSERT INTO clientes (nombre, email, ciudad) 
VALUES ('Laura Rios', 'laura@mail.com', 'Manizales');

SET @nuevo_cliente_id = LAST_INSERT_ID();

INSERT INTO pedidos (cliente_id, producto_id, cantidad, estado) 
VALUES (@nuevo_cliente_id, 3, 2, 'pendiente');

UPDATE productos 
SET stock = stock - 2 
WHERE producto_id = 3;

SELECT c.nombre AS nombre_cliente, p.nombre AS nombre_producto, pd.estado
FROM pedidos pd
JOIN clientes c ON pd.cliente_id = c.cliente_id
JOIN productos p ON pd.producto_id = p.producto_id
WHERE pd.pedido_id = LAST_INSERT_ID();

-- =====================================================
-- PREGUNTA 4
-- Actualice el precio de todos los productos cuyo stock sea menor al promedio 
-- de stock de su misma categoría (use subconsulta correlacionada), incrementando 
-- el precio un 8%. Luego elimine los pedidos con estado cancelado cuyos clientes 
-- no tengan ningún otro pedido en estado entregado (use subconsulta con NOT EXISTS).
-- =====================================================

UPDATE productos p1
SET precio = precio * 1.08
WHERE stock < (
    SELECT AVG(stock) 
    FROM productos p2 
    WHERE p2.categoria = p1.categoria
);

DELETE FROM pedidos 
WHERE estado = 'cancelado' 
AND NOT EXISTS (
    SELECT 1 
    FROM pedidos p2 
    WHERE p2.cliente_id = pedidos.cliente_id 
    AND p2.estado = 'entregado'
);

-- =====================================================
-- PREGUNTA 5
-- Liste el nombre del cliente, ciudad, nombre del producto, cantidad y fecha_pedido 
-- de todos los pedidos entregados cuyo total (cantidad * precio) supere el promedio 
-- general de totales de pedidos entregados. Ordene los resultados por total descendente.
-- =====================================================

SELECT c.nombre, c.ciudad, p.nombre AS producto, pd.cantidad, pd.fecha_pedido,
       (pd.cantidad * p.precio) AS total
FROM pedidos pd
JOIN clientes c ON pd.cliente_id = c.cliente_id
JOIN productos p ON pd.producto_id = p.producto_id
WHERE pd.estado = 'entregado'
AND (pd.cantidad * p.precio) > (
    SELECT AVG(pd2.cantidad * p2.precio)
    FROM pedidos pd2
    JOIN productos p2 ON pd2.producto_id = p2.producto_id
    WHERE pd2.estado = 'entregado'
)
ORDER BY total DESC;

-- =====================================================
-- PREGUNTA 6
-- Cree la vista vista_ventas_ciudad que muestre: ciudad, total_pedidos_entregados, 
-- suma_ingresos (SUM de cantidad*precio) y promedio_ingreso_por_pedido. Luego 
-- consulte la vista para mostrar solo las ciudades cuyo suma_ingresos supere los 
-- 5,000,000, ordenadas de mayor a menor.
-- =====================================================

CREATE VIEW vista_ventas_ciudad AS
SELECT c.ciudad, 
       COUNT(pd.pedido_id) AS total_pedidos_entregados,
       SUM(pd.cantidad * p.precio) AS suma_ingresos,
       AVG(pd.cantidad * p.precio) AS promedio_ingreso_por_pedido
FROM pedidos pd
JOIN clientes c ON pd.cliente_id = c.cliente_id
JOIN productos p ON pd.producto_id = p.producto_id
WHERE pd.estado = 'entregado'
GROUP BY c.ciudad;

SELECT ciudad, total_pedidos_entregados, suma_ingresos, promedio_ingreso_por_pedido
FROM vista_ventas_ciudad
WHERE suma_ingresos > 5000000
ORDER BY suma_ingresos DESC;

-- =====================================================
-- PREGUNTA 7
-- Cree la vista vista_productos_populares que liste los productos que hayan sido 
-- pedidos por más de un cliente distinto (en pedidos entregados). La vista debe 
-- mostrar: producto_id, nombre, categoria, precio y total_clientes_distintos. 
-- Luego use la vista para obtener unicamente los productos de la categoría Perifericos.
-- =====================================================

CREATE VIEW vista_productos_populares AS
SELECT p.producto_id, p.nombre, p.categoria, p.precio,
       COUNT(DISTINCT pd.cliente_id) AS total_clientes_distintos
FROM productos p
JOIN pedidos pd ON p.producto_id = pd.producto_id
WHERE pd.estado = 'entregado'
GROUP BY p.producto_id, p.nombre, p.categoria, p.precio
HAVING COUNT(DISTINCT pd.cliente_id) > 1;

SELECT producto_id, nombre, categoria, precio, total_clientes_distintos
FROM vista_productos_populares
WHERE categoria = 'Perifericos';

-- =====================================================
-- PREGUNTA 8
-- Cree la función fn_ingreso_cliente(p_cliente_id INT) que retorne el ingreso 
-- total acumulado de un cliente (suma de cantidad*precio solo para pedidos 
-- entregados, usando JOIN entre pedidos y productos). Luego use esa función en 
-- un SELECT sobre la tabla clientes para mostrar nombre, ciudad y su ingreso_total, 
-- ordenados de mayor a menor ingreso.
-- =====================================================

DELIMITER //
CREATE FUNCTION fn_ingreso_cliente(p_cliente_id INT) 
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE ingreso_total DECIMAL(12,2);
    
    SELECT SUM(pd.cantidad * p.precio) INTO ingreso_total
    FROM pedidos pd
    JOIN productos p ON pd.producto_id = p.producto_id
    WHERE pd.cliente_id = p_cliente_id AND pd.estado = 'entregado';
    
    RETURN IFNULL(ingreso_total, 0);
END//
DELIMITER ;

SELECT c.nombre, c.ciudad, fn_ingreso_cliente(c.cliente_id) AS ingreso_total
FROM clientes c
ORDER BY ingreso_total DESC;

-- =====================================================
-- PREGUNTA 9
-- Cree la función fn_stock_suficiente(p_producto_id INT, p_cantidad_solicitada INT) 
-- que retorne 1 si el stock actual del producto es mayor o igual a la cantidad 
-- solicitada, o 0 en caso contrario. Luego escriba una consulta que liste nombre 
-- y stock de todos los productos donde fn_stock_suficiente(producto_id, 5) = 0, 
-- es decir, productos con menos de 5 unidades disponibles.
-- =====================================================

DELIMITER //
CREATE FUNCTION fn_stock_suficiente(p_producto_id INT, p_cantidad_solicitada INT) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE stock_actual INT;
    
    SELECT stock INTO stock_actual
    FROM productos
    WHERE producto_id = p_producto_id;
    
    RETURN IF(stock_actual >= p_cantidad_solicitada, 1, 0);
END//
DELIMITER ;

SELECT nombre, stock
FROM productos
WHERE fn_stock_suficiente(producto_id, 5) = 0;

-- =====================================================
-- PREGUNTA 10
-- Cree el procedimiento sp_actualizar_estado_pedido(p_pedido_id INT, 
-- p_nuevo_estado VARCHAR(20)) que: (a) Verifique que el pedido exista (si no, 
-- retorne mensaje de error). (b) Inserte un registro en log_cambios_estado con 
-- el estado anterior y el nuevo. (c) Actualice el estado del pedido. (d) Si el 
-- nuevo estado es cancelado, restaure el stock del producto correspondiente.
-- =====================================================

DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_pedido(
    IN p_pedido_id INT,
    IN p_nuevo_estado VARCHAR(20)
)
BEGIN
    DECLARE v_estado_anterior VARCHAR(20);
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_existe INT;
    
    SELECT COUNT(*) INTO v_existe
    FROM pedidos
    WHERE pedido_id = p_pedido_id;
    
    IF v_existe = 0 THEN
        SELECT 'Error: El pedido no existe' AS mensaje;
    ELSE
        SELECT estado, producto_id, cantidad 
        INTO v_estado_anterior, v_producto_id, v_cantidad
        FROM pedidos
        WHERE pedido_id = p_pedido_id;
        
        INSERT INTO log_cambios_estado (pedido_id, estado_anterior, estado_nuevo)
        VALUES (p_pedido_id, v_estado_anterior, p_nuevo_estado);
        
        UPDATE pedidos
        SET estado = p_nuevo_estado
        WHERE pedido_id = p_pedido_id;
        
        IF p_nuevo_estado = 'cancelado' THEN
            UPDATE productos
            SET stock = stock + v_cantidad
            WHERE producto_id = v_producto_id;
        END IF;
        
        SELECT 'Estado actualizado exitosamente' AS mensaje;
    END IF;
END//
DELIMITER ;

-- =====================================================
-- PREGUNTA 11
-- Cree el procedimiento sp_resumen_cliente(p_cliente_id INT) que ejecute y retorne 
-- en un solo SELECT: nombre del cliente, ciudad, total de pedidos por estado (use 
-- SUM con CASE WHEN para contar pedidos entregados, pendientes y cancelados en 
-- columnas separadas) y el ingreso total solo de pedidos entregados.
-- =====================================================

DELIMITER //
CREATE PROCEDURE sp_resumen_cliente(IN p_cliente_id INT)
BEGIN
    SELECT c.nombre, c.ciudad,
           SUM(CASE WHEN pd.estado = 'entregado' THEN 1 ELSE 0 END) AS total_entregados,
           SUM(CASE WHEN pd.estado = 'pendiente' THEN 1 ELSE 0 END) AS total_pendientes,
           SUM(CASE WHEN pd.estado = 'cancelado' THEN 1 ELSE 0 END) AS total_cancelados,
           SUM(CASE WHEN pd.estado = 'entregado' THEN pd.cantidad * p.precio ELSE 0 END) AS ingreso_total
    FROM clientes c
    LEFT JOIN pedidos pd ON c.cliente_id = pd.cliente_id
    LEFT JOIN productos p ON pd.producto_id = p.producto_id
    WHERE c.cliente_id = p_cliente_id
    GROUP BY c.cliente_id, c.nombre, c.ciudad;
END//
DELIMITER ;

-- =====================================================
-- PREGUNTA 12
-- Cree la vista vista_pedidos_pendientes que muestre pedido_id, nombre del cliente, 
-- nombre del producto, cantidad, precio unitario y dias_espera (DATEDIFF entre 
-- CURDATE() y fecha_pedido) para todos los pedidos con estado pendiente. Luego 
-- cree el procedimiento sp_alertar_retrasos(p_dias_limite INT) que consulte esa 
-- vista y retorne los pedidos cuyo dias_espera supere p_dias_limite.
-- =====================================================

CREATE VIEW vista_pedidos_pendientes AS
SELECT pd.pedido_id, c.nombre AS nombre_cliente, p.nombre AS nombre_producto,
       pd.cantidad, p.precio AS precio_unitario,
       DATEDIFF(CURDATE(), pd.fecha_pedido) AS dias_espera
FROM pedidos pd
JOIN clientes c ON pd.cliente_id = c.cliente_id
JOIN productos p ON pd.producto_id = p.producto_id
WHERE pd.estado = 'pendiente';

DELIMITER //
CREATE PROCEDURE sp_alertar_retrasos(IN p_dias_limite INT)
BEGIN
    SELECT pedido_id, nombre_cliente, nombre_producto, cantidad, 
           precio_unitario, dias_espera
    FROM vista_pedidos_pendientes
    WHERE dias_espera > p_dias_limite;
END//
DELIMITER ;

-- =====================================================
-- PREGUNTA 13
-- Agregue la columna descuento DECIMAL(5,2) DEFAULT 0 a la tabla productos con 
-- una restricción CHECK que garantice valores entre 0 y 50. Cree la función 
-- fn_precio_final(p_producto_id INT) que retorne el precio del producto aplicando 
-- su descuento (precio * (1 - descuento/100)). Luego escriba una consulta que 
-- muestre nombre, precio, descuento y precio_final para los 3 productos con mayor 
-- precio_final, usando la función.
-- =====================================================

ALTER TABLE productos 
ADD COLUMN descuento DECIMAL(5,2) DEFAULT 0,
ADD CONSTRAINT chk_descuento CHECK (descuento >= 0 AND descuento <= 50);

DELIMITER //
CREATE FUNCTION fn_precio_final(p_producto_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_descuento DECIMAL(5,2);
    
    SELECT precio, descuento INTO v_precio, v_descuento
    FROM productos
    WHERE producto_id = p_producto_id;
    
    RETURN v_precio * (1 - v_descuento/100);
END//
DELIMITER ;

SELECT nombre, precio, descuento, fn_precio_final(producto_id) AS precio_final
FROM productos
ORDER BY precio_final DESC
LIMIT 3;

-- =====================================================
-- PREGUNTA 14
-- Cree el procedimiento sp_registrar_pedido(p_cliente_id INT, p_producto_id INT, 
-- p_cantidad INT) que: (a) Valide que el cliente exista. (b) Valide que el stock 
-- sea suficiente. (c) Inserte el pedido con estado pendiente. (d) Actualice el 
-- stock descontando la cantidad. (e) Retorne con un SELECT JOIN el pedido recién 
-- creado con nombre del cliente y nombre del producto.
-- =====================================================

DELIMITER //
CREATE PROCEDURE sp_registrar_pedido(
    IN p_cliente_id INT,
    IN p_producto_id INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_cliente_existe INT;
    DECLARE v_stock_actual INT;
    
    SELECT COUNT(*) INTO v_cliente_existe
    FROM clientes
    WHERE cliente_id = p_cliente_id;
    
    IF v_cliente_existe = 0 THEN
        SELECT 'Error: El cliente no existe' AS mensaje;
    ELSE
        SELECT stock INTO v_stock_actual
        FROM productos
        WHERE producto_id = p_producto_id;
        
        IF v_stock_actual < p_cantidad THEN
            SELECT 'Error: Stock insuficiente' AS mensaje;
        ELSE
            INSERT INTO pedidos (cliente_id, producto_id, cantidad, estado)
            VALUES (p_cliente_id, p_producto_id, p_cantidad, 'pendiente');
            
            UPDATE productos
            SET stock = stock - p_cantidad
            WHERE producto_id = p_producto_id;
            
            SELECT c.nombre AS nombre_cliente, p.nombre AS nombre_producto, 
                   pd.cantidad, pd.estado, pd.fecha_pedido
            FROM pedidos pd
            JOIN clientes c ON pd.cliente_id = c.cliente_id
            JOIN productos p ON pd.producto_id = p.producto_id
            WHERE pd.pedido_id = LAST_INSERT_ID();
        END IF;
    END IF;
END//
DELIMITER ;

-- =====================================================
-- PREGUNTA 15
-- Cree la funcion fn_clasificar_producto(p_producto_id INT) que retorne: PREMIUM 
-- si el precio > 1,000,000; ESTANDAR si esta entre 200,000 y 1,000,000; BASICO 
-- si es menor a 200,000. Luego cree la vista vista_catalogo_clasificado que muestre 
-- nombre, categoria, precio, clasificacion (usando la funcion) y stock para todos 
-- los productos. Finalmente, consulte la vista mostrando solo los productos PREMIUM 
-- con stock > 5.
-- =====================================================

DELIMITER //
CREATE FUNCTION fn_clasificar_producto(p_producto_id INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_clasificacion VARCHAR(20);
    
    SELECT precio INTO v_precio
    FROM productos
    WHERE producto_id = p_producto_id;
    
    SET v_clasificacion = CASE
        WHEN v_precio > 1000000 THEN 'PREMIUM'
        WHEN v_precio >= 200000 THEN 'ESTANDAR'
        ELSE 'BASICO'
    END;
    
    RETURN v_clasificacion;
END//
DELIMITER ;

CREATE VIEW vista_catalogo_clasificado AS
SELECT nombre, categoria, precio, 
       fn_clasificar_producto(producto_id) AS clasificacion, stock
FROM productos;

SELECT nombre, categoria, precio, clasificacion, stock
FROM vista_catalogo_clasificado
WHERE clasificacion = 'PREMIUM' AND stock > 5;

-- =====================================================
-- PREGUNTA 16
-- Cree la vista vista_clientes_vip que contenga el cliente_id, nombre, ciudad y 
-- total_pedidos_entregados de clientes que hayan realizado mas pedidos entregados 
-- que el promedio de pedidos entregados por cliente (use subconsulta en el HAVING). 
-- Luego escriba una consulta sobre esa vista junto con un JOIN a pedidos y productos 
-- para listar el detalle de los últimos 2 pedidos de cada cliente VIP, mostrando 
-- nombre del cliente, nombre del producto y fecha_pedido.
-- =====================================================

CREATE VIEW vista_clientes_vip AS
SELECT c.cliente_id, c.nombre, c.ciudad, COUNT(pd.pedido_id) AS total_pedidos_entregados
FROM clientes c
JOIN pedidos pd ON c.cliente_id = pd.cliente_id
WHERE pd.estado = 'entregado'
GROUP BY c.cliente_id, c.nombre, c.ciudad
HAVING COUNT(pd.pedido_id) > (
    SELECT AVG(total_entregados)
    FROM (
        SELECT COUNT(pedido_id) AS total_entregados
        FROM pedidos
        WHERE estado = 'entregado'
        GROUP BY cliente_id
    ) AS subquery
);

SELECT v.nombre AS nombre_cliente, p.nombre AS nombre_producto, pd.fecha_pedido
FROM vista_clientes_vip v
JOIN pedidos pd ON v.cliente_id = pd.cliente_id
JOIN productos p ON pd.producto_id = p.producto_id
WHERE pd.estado = 'entregado'
AND (
    SELECT COUNT(*)
    FROM pedidos pd2
    WHERE pd2.cliente_id = v.cliente_id
    AND pd2.estado = 'entregado'
    AND pd2.fecha_pedido >= pd.fecha_pedido
) <= 2
ORDER BY v.cliente_id, pd.fecha_pedido DESC;
