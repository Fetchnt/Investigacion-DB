-- =====================================================================
--  Cadena de cines · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

CREATE DATABASE IF NOT EXISTS cines
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE cines;

-- CINE
CREATE TABLE CINE (
  id_cine                  INT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  ciudad                   VARCHAR(40) NOT NULL,
  calle                    VARCHAR(30) NOT NULL,
  numero                   VARCHAR(10) NOT NULL,
  barrio                   VARCHAR(40) NOT NULL,
  CONSTRAINT pk_cine PRIMARY KEY (id_cine)
) ENGINE = InnoDB;

-- CINE_TELEFONO
CREATE TABLE CINE_TELEFONO (
  id_cine                  INT NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  CONSTRAINT pk_cine_telefono PRIMARY KEY (id_cine, telefono),
  CONSTRAINT fk_cine_telefono_cine FOREIGN KEY (id_cine)
    REFERENCES CINE (id_cine)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- SALA
CREATE TABLE SALA (
  id_sala                  INT NOT NULL,
  numero                   TINYINT NOT NULL,
  capacidad                SMALLINT NOT NULL,
  id_cine                  INT NOT NULL,
  tipo                     VARCHAR(8) NOT NULL,
  gafas_disponibles        SMALLINT NULL,
  servicio_mesero          BOOLEAN NULL,
  CONSTRAINT pk_sala PRIMARY KEY (id_sala),
  CONSTRAINT fk_sala_cine FOREIGN KEY (id_cine)
    REFERENCES CINE (id_cine)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- PELICULA
CREATE TABLE PELICULA (
  id_pelicula              INT NOT NULL,
  titulo                   VARCHAR(60) NOT NULL,
  titulo_original          VARCHAR(60) NULL,
  duracion_min             SMALLINT NOT NULL,
  clasificacion            VARCHAR(3) NOT NULL,
  fecha_estreno            DATE NOT NULL,
  CONSTRAINT pk_pelicula PRIMARY KEY (id_pelicula)
) ENGINE = InnoDB;

-- FUNCION
CREATE TABLE FUNCION (
  id_funcion               INT NOT NULL,
  fecha                    DATE NOT NULL,
  hora                     TIME NOT NULL,
  precio                   DECIMAL(8,2) NOT NULL,
  idioma                   VARCHAR(12) NOT NULL,
  id_sala                  INT NOT NULL,
  id_pelicula              INT NOT NULL,
  CONSTRAINT pk_funcion PRIMARY KEY (id_funcion),
  CONSTRAINT fk_funcion_sala FOREIGN KEY (id_sala)
    REFERENCES SALA (id_sala)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_funcion_pelicula FOREIGN KEY (id_pelicula)
    REFERENCES PELICULA (id_pelicula)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CLIENTE
CREATE TABLE CLIENTE (
  documento                VARCHAR(15) NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  correo                   VARCHAR(80) NOT NULL,
  puntos                   INT NOT NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (documento),
  CONSTRAINT uq_cliente_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- TIQUETE
CREATE TABLE TIQUETE (
  id_funcion               INT NOT NULL,
  fila                     CHAR(1) NOT NULL,
  numero_silla             TINYINT NOT NULL,
  documento_cliente        VARCHAR(15) NOT NULL,
  valor_pagado             DECIMAL(8,2) NOT NULL,
  CONSTRAINT pk_tiquete PRIMARY KEY (id_funcion, fila, numero_silla),
  CONSTRAINT fk_tiquete_funcion FOREIGN KEY (id_funcion)
    REFERENCES FUNCION (id_funcion)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_tiquete_cliente FOREIGN KEY (documento_cliente)
    REFERENCES CLIENTE (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
