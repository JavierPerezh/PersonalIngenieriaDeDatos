-- =====================================================
-- LENGUAJE DE MANIPULACIÓN DE DATOS (DML)
-- =====================================================
-- Author: Javier Pérez

-- -----------------------------------------------------
-- 1. CONFIGURACIÓN INICIAL DE LA BASE DE DATOS
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS eCommerceVirtual;
USE eCommerceVirtual;

-- -----------------------------------------------------
-- 2. CREACIÓN DE TABLAS PRINCIPALES
-- -----------------------------------------------------

-- Tabla de clientes con información de contacto
CREATE TABLE consumidores(
    idConsumidor INT PRIMARY KEY AUTO_INCREMENT,
    nombreCompleto VARCHAR(100) NOT NULL,
    correoElectronico VARCHAR(150) UNIQUE,
    ubicacion VARCHAR(80) NULL,
    fechaRegistro DATETIME DEFAULT NOW()
);

-- Tabla de artículos disponibles para la venta
CREATE TABLE articulos(
    idArticulo INT PRIMARY KEY AUTO_INCREMENT,
    tituloArticulo VARCHAR(120) NOT NULL,
    valorUnitario DECIMAL(10,2),
    existencias INT DEFAULT 0,
    tipoArticulo VARCHAR(60)
);

-- Tabla de transacciones que vincula clientes y productos
CREATE TABLE transaccion(
    idTransaccion INT PRIMARY KEY AUTO_INCREMENT,
    cantidadSolicitada INT NOT NULL,
    fechaOperacion DATE,
    consumidorReferencia INT,
    articuloReferencia INT,
    FOREIGN KEY (consumidorReferencia) REFERENCES consumidores(idConsumidor),
    FOREIGN KEY (articuloReferencia) REFERENCES articulos(idArticulo)
);

-- Tabla de respaldo para clientes eliminados o archivados
CREATE TABLE respaldo_consumidores (
    idRespaldo INT PRIMARY KEY AUTO_INCREMENT,
    nombreRespaldo VARCHAR(100),
    emailRespaldo VARCHAR(150),
    fechaCopia DATETIME DEFAULT NOW()
);

-- -----------------------------------------------------
-- 3. CONSULTAS GENERALES DE VERIFICACIÓN
-- -----------------------------------------------------
SELECT * FROM consumidores;
SELECT * FROM articulos;
SELECT * FROM transaccion;

-- -----------------------------------------------------
-- 4. OPERACIONES INSERT 
-- -----------------------------------------------------

-- Insertar un solo cliente
DESCRIBE consumidores;
INSERT INTO consumidores(idConsumidor, nombreCompleto, correoElectronico, ubicacion) 
VALUES ('','María López','maria@servicio.com','Sevilla');
INSERT INTO consumidores(nombreCompleto, correoElectronico, ubicacion) 
VALUES ('Juan Martínez','juan@servicio.com','Bilbao');
SELECT * FROM consumidores;

-- Insertar múltiples artículos
DESCRIBE articulos;
INSERT INTO articulos (tituloArticulo, valorUnitario, existencias, tipoArticulo)
VALUES 
('Ultrabook X1', 1250000, 20, 'Electrónica'), 
('Ratón Óptico', 45000, 95, 'Periféricos'),
('Pantalla Curva 27"', 680000, 15, 'Electrónica'),
('Base Refrigerante', 75000, 42, 'Accesorios');

SELECT * FROM articulos;

-- Copia de seguridad de clientes registrados antes de cierta fecha
INSERT INTO respaldo_consumidores (nombreRespaldo, emailRespaldo)
SELECT nombreCompleto, correoElectronico
FROM consumidores
WHERE fechaRegistro < '2026-04-01';

-- Renombrar tabla para mantener consistencia
RENAME TABLE respaldo_consumidores TO backup_consumidores;
SELECT * FROM backup_consumidores;
DESCRIBE backup_consumidores;

-- -----------------------------------------------------
-- 5. OPERACIONES UPDATE
-- -----------------------------------------------------

SELECT * FROM consumidores;

-- Actualizar un campo específico
UPDATE consumidores
SET ubicacion = 'Alicante'
WHERE idConsumidor = 1;

-- Actualizar múltiples campos en un registro
SELECT * FROM articulos;

UPDATE articulos
SET
    valorUnitario = 1199000,
    existencias = 8
WHERE idArticulo = 1;

-- Actualización basada en condición 
UPDATE articulos
SET valorUnitario = valorUnitario * 1.10
WHERE tipoArticulo = 'Periféricos';

-- -----------------------------------------------------
-- 6. OPERACIONES DELETE 
-- -----------------------------------------------------

SELECT * FROM consumidores;
DELETE FROM consumidores 
WHERE idConsumidor = 2;

SELECT * FROM articulos;
DELETE FROM articulos
WHERE existencias = 0 AND tipoArticulo = 'Descatalogado';

-- =====================================================
-- EJERCICIOS PRÁCTICOS DML
-- =====================================================

-- 1. Agregar tres nuevos compradores
INSERT INTO consumidores (nombreCompleto, correoElectronico, ubicacion)
VALUES
  ('Valentina Díaz', 'valentina@correo.com',   'Quito'),
  ('Andrés Herrera', 'andres@correo.com',      'Guayaquil'),
  ('Camila Méndez',  'camila@correo.com',      'Cuenca'); 

-- 2. Incorporar dos artículos al catálogo
INSERT INTO articulos (tituloArticulo, valorUnitario, existencias, tipoArticulo)
VALUES
  ('Audífonos Inalámbricos', 210000, 30, 'Periféricos'),
  ('Smartwatch Sport',       720000, 18, 'Electrónica');

-- 3. Registrar una transacción vinculando cliente y artículo
SELECT idConsumidor, nombreCompleto FROM consumidores ORDER BY idConsumidor DESC LIMIT 3;
SELECT idArticulo, tituloArticulo FROM articulos ORDER BY idArticulo DESC LIMIT 2;

INSERT INTO transaccion (cantidadSolicitada, fechaOperacion, consumidorReferencia, articuloReferencia)
VALUES (3, '2026-04-10', 4, 7);

-- 4. Modificar ubicación de un cliente existente
UPDATE consumidores 
SET ubicacion = 'Manta'
WHERE idConsumidor = 4; 

-- 5. Incrementar stock de un producto
UPDATE articulos
SET existencias = existencias + 5
WHERE idArticulo = 7;

-- Desactivar modo seguro 
SET SQL_SAFE_UPDATES = 0;

-- 6. Aplicar descuento del 10% a un artículo específico
UPDATE articulos
SET valorUnitario = valorUnitario * 0.90
WHERE idArticulo = 8;

-- 7. Eliminar la transacción creada en el punto 3
DELETE FROM transaccion
WHERE idTransaccion = 1;

-- 8. Remover cliente cuya ubicación fue modificada
DELETE FROM transaccion WHERE consumidorReferencia = 4;
DELETE FROM consumidores WHERE idConsumidor = 4;

-- 9. Eliminar artículos con stock insuficiente
SELECT * FROM articulos WHERE existencias < 3;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM articulos WHERE existencias < 3;
SET SQL_SAFE_UPDATES = 1;

DESCRIBE articulos;

ALTER TABLE articulos CHANGE COLUMN existencias stoProdT INT;
ALTER TABLE articulos CHANGE COLUMN tituloArticulo nombreArticulo VARCHAR (120);

SELECT nombreArticulo, stoProdT FROM articulos;

SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM articulos WHERE stoProdT <= 15 AND idArticulo = 1;

SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM articulos ORDER BY stoProdT DESC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM articulos ORDER BY stoProdT ASC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM articulos ORDER BY nombreArticulo DESC;
SELECT nombreArticulo AS Nombre_Producto, stoProdT AS stock FROM articulos ORDER BY nombreArticulo ASC;

SELECT * FROM articulos WHERE nombreArticulo like '%o';
