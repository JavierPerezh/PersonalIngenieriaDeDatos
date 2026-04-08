-- =====================================================
-- LENGUAJE DE MANIPULACIÓN DE DATOS (DML)
-- =====================================================
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

SELECT UPPER(nombreProducto) AS Producto_Mayuscula,ROUND(precioProducto, 0) AS Precio_Redondeado FROM productos 
WHERE precioProducto BETWEEN 100000 AND 700000;

-- Importar datos de csv se hace mediante el Import Wizard de MySQL
-- Los datos tambien se pueden importar de archivos JSON, XML, TXT. El mas común es CSV
-- Revision imports:

SELECT * FROM clientes;
SELECT * FROM pedido;
SELECT * FROM productos;

-- Tambien se pueden importar datos usando LOAD DATA INFILE y especificando la tabla con INFO TABLE y restricciones de 
-- como importar según el tipo de archivo

--Tarea subConsultas

SELECT nombreProducto, precioProducto, FROM productos WHERE PrecioProducto > (SELECT AVG(precioProducto) FROM productos) ORDER BY precioProductos DESC
