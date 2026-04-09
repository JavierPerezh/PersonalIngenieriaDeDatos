-- Author: Javier Pérez

-- -----------------------------------------------------
-- 1. CONFIGURACIÓN INICIAL DE LA BASE DE DATOS
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS tiendaOnline;
USE tiendaOnline;

-- -----------------------------------------------------
-- 2. CREACIÓN DE TABLAS PRINCIPALES
-- -----------------------------------------------------

-- Tabla de clientes con información de contacto
CREATE TABLE clientes(
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nombreCliente VARCHAR(100) NOT NULL,
    emailCliente VARCHAR(150) UNIQUE,
    ciudad VARCHAR(80) NULL,
    creado_en DATETIME DEFAULT NOW()
);

-- Tabla de artículos disponibles para la venta
CREATE TABLE productos(
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    nombreProducto VARCHAR(120) NOT NULL,
    precioProducto DECIMAL(10,2),
    stockProducto INT DEFAULT 0,
    categoriaProducto VARCHAR(60)
);

-- Tabla de transacciones que vincula clientes y productos
CREATE TABLE pedido(
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    cantidadProducto INT NOT NULL,
    fechaPedido DATE,
    idClienteFK INT,
    idProductoFK INT,
    FOREIGN KEY (idClienteFK) REFERENCES clientes(idCliente),
    FOREIGN KEY (idProductoFK) REFERENCES productos(idProducto)
);

-- Tabla de respaldo para clientes eliminados o archivados
CREATE TABLE cliente_backup (
    idClienBack INT PRIMARY KEY AUTO_INCREMENT,
    nombreCliente VARCHAR(100),
    emailCliente VARCHAR(150),
    copiado_en DATETIME DEFAULT NOW()
);

-- -----------------------------------------------------
-- 3. CONSULTAS GENERALES DE VERIFICACIÓN
-- -----------------------------------------------------
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM pedido;

-- -----------------------------------------------------
-- 4. OPERACIONES INSERT 
-- -----------------------------------------------------

-- Insertar un solo cliente
DESCRIBE clientes;
INSERT INTO clientes(idCliente, nombreCliente, emailCliente, ciudad) 
VALUES ('','María López','maria@servicio.com','Sevilla');
INSERT INTO clientes(nombreCliente, emailCliente, ciudad) 
VALUES ('Juan Martínez','juan@servicio.com','Bilbao');
SELECT * FROM clientes;

-- Insertar múltiples artículos
DESCRIBE productos;
INSERT INTO productos (nombreProducto, precioProducto, stockProducto, categoriaProducto)
VALUES 
('Ultrabook X1', 1250000, 20, 'Electrónica'), 
('Ratón Óptico', 45000, 95, 'Periféricos'),
('Pantalla Curva 27"', 680000, 15, 'Electrónica'),
('Base Refrigerante', 75000, 42, 'Accesorios');

SELECT * FROM productos;

-- Copia de seguridad de clientes registrados antes de cierta fecha
INSERT INTO cliente_backup (nombreCliente, emailCliente)
SELECT nombreCliente, emailCliente
FROM clientes
WHERE creado_en < '2026-04-01';

-- Verificar backup
SELECT * FROM cliente_backup;
DESCRIBE cliente_backup;

-- -----------------------------------------------------
-- 5. OPERACIONES UPDATE
-- -----------------------------------------------------

SELECT * FROM clientes;

-- Actualizar un campo específico
UPDATE clientes
SET ciudad = 'Alicante'
WHERE idCliente = 1;

-- Actualizar múltiples campos en un registro
SELECT * FROM productos;

UPDATE productos
SET
    precioProducto = 1199000,
    stockProducto = 8
WHERE idProducto = 1;

-- Actualización basada en condición 
UPDATE productos
SET precioProducto = precioProducto * 1.10
WHERE categoriaProducto = 'Periféricos';

-- -----------------------------------------------------
-- 6. OPERACIONES DELETE 
-- -----------------------------------------------------

SELECT * FROM clientes;
DELETE FROM clientes 
WHERE idCliente = 2;

SELECT * FROM productos;
DELETE FROM productos
WHERE stockProducto = 0 AND categoriaProducto = 'Descatalogado';

-- =====================================================
-- EJERCICIOS PRÁCTICOS DML
-- =====================================================

-- 1. Agregar tres nuevos compradores
INSERT INTO clientes (nombreCliente, emailCliente, ciudad)
VALUES
  ('Valentina Díaz', 'valentina@correo.com',   'Quito'),
  ('Andrés Herrera', 'andres@correo.com',      'Guayaquil'),
  ('Camila Méndez',  'camila@correo.com',      'Cuenca'); 

-- 2. Incorporar dos artículos al catálogo
INSERT INTO productos (nombreProducto, precioProducto, stockProducto, categoriaProducto)
VALUES
  ('Audífonos Inalámbricos', 210000, 30, 'Periféricos'),
  ('Smartwatch Sport',       720000, 18, 'Electrónica');

-- 3. Registrar una transacción vinculando cliente y artículo
SELECT idCliente, nombreCliente FROM clientes ORDER BY idCliente DESC LIMIT 3;
SELECT idProducto, nombreProducto FROM productos ORDER BY idProducto DESC LIMIT 2;

INSERT INTO pedido (cantidadProducto, fechaPedido, idClienteFK, idProductoFK)
VALUES (3, '2026-04-10', 4, 7);

-- 4. Modificar ubicación de un cliente existente
UPDATE clientes 
SET ciudad = 'Manta'
WHERE idCliente = 4; 

-- 5. Incrementar stock de un producto
UPDATE productos
SET stockProducto = stockProducto + 5
WHERE idProducto = 7;

-- Desactivar modo seguro 
SET SQL_SAFE_UPDATES = 0;

-- 6. Aplicar descuento del 10% a un artículo específico
UPDATE productos
SET precioProducto = precioProducto * 0.90
WHERE idProducto = 8;

-- 7. Eliminar la transacción creada en el punto 3
DELETE FROM pedido
WHERE idPedido = 1;

-- 8. Remover cliente cuya ubicación fue modificada
DELETE FROM pedido WHERE idClienteFK = 4;
DELETE FROM clientes WHERE idCliente = 4;

-- 9. Eliminar artículos con stock insuficiente
SELECT * FROM productos WHERE stockProducto < 3;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM productos WHERE stockProducto < 3;
SET SQL_SAFE_UPDATES = 1;

-- Consultas de clase

DESCRIBE productos;

ALTER TABLE productos CHANGE COLUMN stockProducto stoProdT INT;
ALTER TABLE productos CHANGE COLUMN nombreProducto nombreArticulo VARCHAR(120);

SELECT nombreArticulo, stoProdT FROM productos;

SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM productos WHERE stoProdT <= 15 AND idProducto = 1;

SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM productos ORDER BY stoProdT DESC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM productos ORDER BY stoProdT ASC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM productos ORDER BY nombreArticulo DESC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM productos ORDER BY nombreArticulo ASC;

SELECT nombreProducto AS Producto, stockProducto AS Stock FROM productos WHERE stockProducto BETWEEN 15 AND 50;

SELECT * FROM productos WHERE nombreArticulo LIKE '%o';

-- Consultas usando metodos sobre tipos de datos

SELECT nombreProducto AS Producto, ROUND(precioProducto, 0) AS Precio_Redondeado FROM productos;

SELECT nombreProducto AS Producto, stockProducto AS Stock_Actual, ABS(stockProducto - 15) AS Diferencia_Stock_15 FROM productos;

SELECT UPPER(nombreProducto) AS Producto_Mayuscula, precioProducto AS Precio FROM productos;

SELECT nombreProducto AS Nombre_Original, SUBSTRING(nombreProducto, 1, 10) AS Nombre_Abreviado FROM productos;

SELECT UPPER(nombreProducto) AS Producto_Mayuscula, ROUND(precioProducto, 0) AS Precio_Redondeado FROM productos 
WHERE precioProducto BETWEEN 100000 AND 700000;

-- Importar datos de csv se hace mediante el Import Wizard de MySQL
-- Los datos tambien se pueden importar de archivos JSON, XML, TXT. El mas común es CSV
-- Revision imports:

SELECT * FROM clientes;
SELECT * FROM pedido;
SELECT * FROM productos;

-- Tambien se pueden importar datos usando LOAD DATA INFILE y especificando la tabla con INFO TABLE y restricciones de 

SELECT * FROM productos GROUP BY categoriaProducto;

SELECT categoriaProducto, COUNT(*) AS Cantidad, AVG(precioProducto) AS Promedio 
FROM productos GROUP BY categoriaProducto HAVING AVG(precioProducto) > 5000 ORDER BY Promedio DESC;

SELECT * FROM clientes ;

-- Subconsultas
-- Consultas anidadas subQuery

CREATE TABLE departamento(
	idDepartamento INT PRIMARY KEY AUTO_INCREMENT,
    nombreDepartamento VARCHAR (50)
);

CREATE TABLE empleados(
	idEmpleado INT PRIMARY KEY AUTO_INCREMENT,
    nombreEmpleado VARCHAR (50) NULL,
    salario DOUBLE NOT NULL,
    idDepartamentoFK INT,
    FOREIGN KEY (idDepartamentoFK) REFERENCES departamento(idDepartamento)
);

CREATE TABLE producto(
	idProducto INT PRIMARY KEY AUTO_INCREMENT,
    nombreProducto VARCHAR (50) NULL,
    precio DOUBLE NOT NULL,
    categoria VARCHAR (50) NOT NULL
);

INSERT INTO departamento(nombreDepartamento)
VALUES ('Departamento A'), ('Departamento B'), ('Departamento C');

INSERT INTO empleados(nombreEmpleado, salario, idDepartamentoFK)
VALUES ('Javier Pérez', 8, 1), ('Juan Zamudio', 2, 2), ('Tatiana Cabrera', 10, 3);

INSERT INTO producto(nombreProducto, precio, categoria)
VALUES ('Producto A', 3, 'A'), ('Producto B', 4, 'B'), ('Producto C', 2, 'C');

-- Subconsultas

SELECT nombreEmpleado, salario FROM empleados WHERE salario > (SELECT AVG(salario) FROM empleados);

SELECT nombreEmpleado, salario FROM empleados 
WHERE idDepartamentoFK IN (SELECT idDepartamento FROM departamento WHERE nombreDepartamento IN ('Departamento A', 'Departamento B'));

SELECT idDepartamentoFK, promedioSalarios FROM (SELECT idDepartamentoFK, AVG(salario) AS promedioSalarios FROM empleados GROUP BY idDepartamentoFK) AS promedios 
WHERE promedioSalarios > 1;

DESCRIBE empleados;

-- Categoria y precio maximo de los productos, y el producto cuyo precio sea mayor que el del promedio. 

SELECT * FROM producto;

SELECT AVG(precio) FROM producto;

SELECT nombreProducto, precio FROM producto WHERE precio > (SELECT AVG(precio) FROM producto) ORDER BY precio DESC;

SELECT nombreEmpleado, salario, (SELECT AVG(salario) FROM empleados) AS promedioSalarios, salario - (SELECT AVG(salario) FROM empleados) AS diferencia 
FROM empleados;

CREATE TABLE pedidos(
	idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    fechaPedido DATETIME DEFAULT NOW(),
    estado ENUM('pendiente', 'enviado', 'entregado', 'cancelado') NOT NULL,
	total DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

CREATE TABLE detallePedido (
	idDetalle	INT AUTO_INCREMENT PRIMARY KEY,
    idPedido	INT NOT NULL,
    idProducto 	INT NOT NULL,
    cantidad	INT NOT NULL,
    precioUnit	DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (idPedido) 	REFERENCES pedidos(idPedido),
    FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);


INSERT INTO pedidos (idCliente, fechaPedido, estado, total) VALUES
(1, '2026-04-01 10:30:00', 'entregado', 1250000),
(2, '2026-04-05 14:15:00', 'enviado', 720000),
(1, '2026-04-08 09:45:00', 'pendiente', 255000),
(1, '2026-04-10 16:20:00', 'entregado', 680000),
(2, '2026-04-12 11:00:00', 'cancelado', 210000);


INSERT INTO detallePedido (idPedido, idProducto, cantidad, precioUnit) VALUES
(1, 1, 1, 1250000),
(2, 2, 1, 720000),
(3, 3, 1, 210000),
(3, 2, 1, 45000),
(4, 3, 1, 680000),
(5, 1, 1, 210000);

SELECT 
    p.idPedido,
    c.nombreCliente,
    c.emailCliente,
    p.fechaPedido,
    p.estado,
    p.total AS totalPedido,
    pr.nombreProducto,
    dp.cantidad,
    dp.precioUnit,
    (dp.cantidad * dp.precioUnit) AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.idCliente = c.idCliente
INNER JOIN detallePedido dp ON p.idPedido = dp.idPedido
INNER JOIN producto pr ON dp.idProducto = pr.idProducto
ORDER BY p.idPedido, dp.idDetalle;

USE tiendaonline;

