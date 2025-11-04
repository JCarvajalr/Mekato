CREATE DATABASE IF NOT EXISTS mekato;

USE mekato;

-- ============================================================================
-- TABLA: usuarios
-- Descripción: Almacena la información de los usuarios del sistema
-- ============================================================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    contraseña_hash VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Índices para optimizar consultas
    INDEX idx_email (email),
    INDEX idx_activo (activo)
)
COMMENT='Tabla de usuarios registrados en el sistema';

-- ============================================================================
-- TABLA: reservas
-- Descripción: Gestión de reservas realizadas por los usuarios
-- ============================================================================
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    num_personas INT NOT NULL CHECK (num_personas > 0 AND num_personas <= 20),
    comentarios TEXT,
    estado_reserva ENUM('pendiente', 'confirmada', 'cancelada', 'completada') 
        DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Definición de llaves foráneas
    FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Índices compuestos para optimizar consultas comunes
    INDEX idx_usuario_fecha (id_usuario, fecha_reserva),
    INDEX idx_estado (estado_reserva),
    INDEX idx_fecha_reserva (fecha_reserva, hora_reserva)
)
COMMENT='Tabla de reservas del sistema';

-- ============================================================================
-- TABLA: historial_reservas
-- Descripción: Auditoría de cambios en reservas (opcional pero recomendada)
-- ============================================================================
CREATE TABLE historial_reservas (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_usuario INT NOT NULL,
    accion ENUM('creacion', 'modificacion', 'cancelacion') NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    fecha_accion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalles_cambio TEXT,
    
    FOREIGN KEY (id_reserva) 
        REFERENCES reservas(id_reserva) 
        ON DELETE CASCADE,
    
    INDEX idx_reserva (id_reserva),
    INDEX idx_fecha_accion (fecha_accion)
)
COMMENT='Registro de auditoría de cambios en reservas';