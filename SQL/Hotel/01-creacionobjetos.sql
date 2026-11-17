-- =====================================================================
--  Cadena hotelera · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

CREATE DATABASE IF NOT EXISTS hotel
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE hotel;

-- HOTEL
CREATE TABLE HOTEL (
  nit                      VARCHAR(15) NOT NULL,
  nombre                   VARCHAR(60) NOT NULL,
  ciudad                   VARCHAR(40) NOT NULL,
  direccion                VARCHAR(80) NOT NULL,
  estrellas                TINYINT NOT NULL,
  CONSTRAINT pk_hotel PRIMARY KEY (nit)
) ENGINE = InnoDB;

-- HABITACION
CREATE TABLE HABITACION (
  id_habitacion            INT NOT NULL,
  numero                   VARCHAR(5) NOT NULL,
  piso                     TINYINT NOT NULL,
  capacidad                TINYINT NOT NULL,
  tarifa_base              DECIMAL(10,2) NOT NULL,
  nit_hotel                VARCHAR(15) NOT NULL,
  tipo                     VARCHAR(10) NOT NULL,
  metros2                  DECIMAL(5,1) NULL,
  jacuzzi                  BOOLEAN NULL,
  tipo_cama                VARCHAR(15) NULL,
  CONSTRAINT pk_habitacion PRIMARY KEY (id_habitacion),
  CONSTRAINT fk_habitacion_hotel FOREIGN KEY (nit_hotel)
    REFERENCES HOTEL (nit)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- HUESPED
CREATE TABLE HUESPED (
  documento                VARCHAR(15) NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  correo                   VARCHAR(80) NOT NULL,
  pais                     VARCHAR(40) NOT NULL,
  CONSTRAINT pk_huesped PRIMARY KEY (documento),
  CONSTRAINT uq_huesped_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- RESERVA
CREATE TABLE RESERVA (
  codigo                   VARCHAR(10) NOT NULL,
  fecha_reserva            DATE NOT NULL,
  fecha_entrada            DATE NOT NULL,
  fecha_salida             DATE NOT NULL,
  estado                   VARCHAR(12) NOT NULL,
  documento_huesped        VARCHAR(15) NOT NULL,
  CONSTRAINT pk_reserva PRIMARY KEY (codigo),
  CONSTRAINT fk_reserva_huesped FOREIGN KEY (documento_huesped)
    REFERENCES HUESPED (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ALOJAMIENTO
CREATE TABLE ALOJAMIENTO (
  codigo_reserva           VARCHAR(10) NOT NULL,
  id_habitacion            INT NOT NULL,
  tarifa_noche             DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_alojamiento PRIMARY KEY (codigo_reserva, id_habitacion),
  CONSTRAINT fk_alojamiento_reserva FOREIGN KEY (codigo_reserva)
    REFERENCES RESERVA (codigo)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_alojamiento_habitacion FOREIGN KEY (id_habitacion)
    REFERENCES HABITACION (id_habitacion)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- SERVICIO
CREATE TABLE SERVICIO (
  id_servicio              INT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  precio                   DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_servicio PRIMARY KEY (id_servicio)
) ENGINE = InnoDB;

-- CONSUMO
CREATE TABLE CONSUMO (
  codigo_reserva           VARCHAR(10) NOT NULL,
  id_servicio              INT NOT NULL,
  fecha                    DATE NOT NULL,
  cantidad                 TINYINT NOT NULL,
  CONSTRAINT pk_consumo PRIMARY KEY (codigo_reserva, id_servicio, fecha),
  CONSTRAINT fk_consumo_reserva FOREIGN KEY (codigo_reserva)
    REFERENCES RESERVA (codigo)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_consumo_servicio FOREIGN KEY (id_servicio)
    REFERENCES SERVICIO (id_servicio)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
