-- =====================================================
-- SISTEMA DE GESTIÓN DE COMPAÑÍA DE SEGUROS
-- Autor: Javier Pérez
-- Fecha: 2026
-- Descripción: Base de datos para gestionar compañías
-- de seguros, vehículos asegurados y accidentes
-- =====================================================

-- =====================================================
-- CREACIÓN DE LA BASE DE DATOS
-- =====================================================
DROP DATABASE IF EXISTS companiaseguros;

-- Crear la base de datos
CREATE DATABASE companiaseguros;

-- Seleccionar la base de datos para trabajar en ella
USE companiaseguros;

-- =====================================================
-- TABLA: COMPAÑIA
-- =====================================================
-- Almacena la información de las compañías aseguradoras
CREATE TABLE compania(
    idCompania VARCHAR(50) PRIMARY KEY,
    nit VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    fechaFundacion DATE NULL,
    representanteLegal VARCHAR(50) NOT NULL
);

-- =====================================================
-- TABLA: AUTOMOVIL
-- =====================================================
-- Almacena la información de los vehículos asegurados
CREATE TABLE automovil(
    idAutomovil VARCHAR(50) PRIMARY KEY,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    placa VARCHAR(20) UNIQUE NOT NULL,
    tipo VARCHAR(50) NOT NULL,  
    anioFabricacion INT NULL,    
    serialChasis VARCHAR(50) UNIQUE NOT NULL,
    pasajeros INT NOT NULL,
    cilindraje INT NOT NULL
);

-- =====================================================
-- TABLA: SEGUROS
-- =====================================================
-- Almacena las pólizas de seguro asociadas a vehículos y compañías
CREATE TABLE seguros(
    idSeguro VARCHAR(50) PRIMARY KEY,
    fechaInicio DATE NULL,
    fechaExpiracion DATE NOT NULL, 
    estado VARCHAR(20) NOT NULL,
    costo DOUBLE NOT NULL,
    valorAsegurado DOUBLE NOT NULL,
    idCompaniaFK VARCHAR(50) NOT NULL,  
    idAutomovilFK VARCHAR(50) NOT NULL,
    -- Creación de las relaciones FOREIGN KEY
    FOREIGN KEY (idCompaniaFK) REFERENCES compania(idCompania),
    FOREIGN KEY (idAutomovilFK) REFERENCES automovil(idAutomovil)
);

-- =====================================================
-- TABLA: ACCIDENTE
-- =====================================================
-- Almacena los registros de accidentes automovilísticos
CREATE TABLE accidente(
    idAccidente VARCHAR(50) PRIMARY KEY,
    automotores VARCHAR(20) NOT NULL,
    fatalidades INT NOT NULL,
    heridos INT NOT NULL,
    lugar VARCHAR(50) NOT NULL,
    fechaAccidente DATE NOT NULL
);

-- =====================================================
-- TABLA: AFECTADOS 
-- =====================================================
-- Relaciona los vehículos con los accidentes en los que han estado involucrados
-- Esta tabla resuelve la relación muchos a muchos entre automóviles y accidentes
CREATE TABLE afectados(
    idAutomovilFK VARCHAR(50) NOT NULL,
    idAccidenteFK VARCHAR(50) NOT NULL,
    PRIMARY KEY (idAutomovilFK, idAccidenteFK),  
    FOREIGN KEY (idAutomovilFK) REFERENCES automovil(idAutomovil),
    FOREIGN KEY (idAccidenteFK) REFERENCES accidente(idAccidente)
);

-- =====================================================
-- EJEMPLO 1: AGREGAR UNA NUEVA COLUMNA
-- =====================================================
-- Agregar campo de teléfono de contacto a la tabla compañía
ALTER TABLE compania
ADD COLUMN telefonoContacto VARCHAR(20) NULL AFTER representanteLegal;

DESCRIBE compania;

-- =====================================================
-- EJEMPLO 2: RENOMBRAR UNA COLUMNA
-- =====================================================
-- Cambiar el nombre de la columna 'automotores' por 'vehiculosInvolucrados'
ALTER TABLE accidente
CHANGE COLUMN automotores vehiculosInvolucrados VARCHAR(20) NOT NULL;

DESCRIBE accidente;
