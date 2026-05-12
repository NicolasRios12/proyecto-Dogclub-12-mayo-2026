-- ============================================
-- Base de Datos: DogClub
-- Archivo: bddogclub.sql
-- Descripción: Script de creación de base de datos
-- para una guardería canina
-- ============================================

CREATE DATABASE IF NOT EXISTS bddogclub;
USE bddogclub;

-- ============================================
-- TABLA: CLIENTES
-- ============================================

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(120) UNIQUE,
    direccion VARCHAR(200),
    fecha_registro DATE NOT NULL
);

-- ============================================
-- TABLA: MASCOTAS
-- ============================================

CREATE TABLE mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    raza VARCHAR(80),
    tamanio ENUM('pequeño', 'mediano', 'grande') NOT NULL,
    edad TINYINT,
    notas_medicas TEXT,
    foto_url VARCHAR(255),

    CONSTRAINT fk_mascota_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- TABLA: SERVICIOS
-- ============================================

CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria ENUM('guarderia', 'cuidado', 'paseo') NOT NULL,
    precio_base DECIMAL(8,2) NOT NULL,
    duracion_min SMALLINT,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================
-- TABLA: EMPLEADOS
-- ============================================

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    rol ENUM('cuidador', 'paseador', 'groomer', 'admin') NOT NULL,
    telefono VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================
-- TABLA: RESERVACIONES
-- ============================================

CREATE TABLE reservaciones (
    id_reservacion INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_servicio INT NOT NULL,
    id_empleado INT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME,
    estado ENUM(
        'pendiente',
        'confirmada',
        'en_curso',
        'completada',
        'cancelada'
    ) NOT NULL,
    precio_final DECIMAL(8,2),
    notas TEXT,

    CONSTRAINT fk_reservacion_mascota
        FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_reservacion_servicio
        FOREIGN KEY (id_servicio)
        REFERENCES servicios(id_servicio)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_reservacion_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleados(id_empleado)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================
-- TABLA: PAGOS
-- ============================================

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reservacion INT NOT NULL,
    monto DECIMAL(8,2) NOT NULL,
    metodo ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    fecha_pago DATETIME NOT NULL,
    estado ENUM('pendiente', 'pagado', 'reembolsado') NOT NULL,

    CONSTRAINT fk_pago_reservacion
        FOREIGN KEY (id_reservacion)
        REFERENCES reservaciones(id_reservacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- TABLA: INCIDENCIAS
-- ============================================

CREATE TABLE incidencias (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_reservacion INT NOT NULL,
    descripcion TEXT NOT NULL,
    severidad ENUM('baja', 'media', 'alta') NOT NULL,
    fecha_hora DATETIME NOT NULL,

    CONSTRAINT fk_incidencia_reservacion
        FOREIGN KEY (id_reservacion)
        REFERENCES reservaciones(id_reservacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- ÍNDICES ADICIONALES
-- ============================================

CREATE INDEX idx_cliente_nombre
ON clientes(nombre, apellido);

CREATE INDEX idx_mascota_nombre
ON mascotas(nombre);

CREATE INDEX idx_reservacion_fecha
ON reservaciones(fecha_inicio);

CREATE INDEX idx_pago_fecha
ON pagos(fecha_pago);

CREATE INDEX idx_incidencia_fecha
ON incidencias(fecha_hora);

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
