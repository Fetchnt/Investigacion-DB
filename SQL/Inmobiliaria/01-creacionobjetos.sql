-- =====================================================================
--  Agencia inmobiliaria · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE inmobiliaria;

-- RANGO_COMISION
CREATE TABLE RANGO_COMISION (
  id_rango                 INT NOT NULL,
  valor_min                DECIMAL(14,2) NOT NULL,
  valor_max                DECIMAL(14,2) NOT NULL,
  porcentaje               DECIMAL(4,2) NOT NULL,
  CONSTRAINT pk_rango_comision PRIMARY KEY (id_rango)
) ENGINE = InnoDB;

-- AGENTE
CREATE TABLE AGENTE (
  id_agente                INT NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  CONSTRAINT pk_agente PRIMARY KEY (id_agente)
) ENGINE = InnoDB;

-- PROPIETARIO
CREATE TABLE PROPIETARIO (
  documento                VARCHAR(15) NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  correo                   VARCHAR(80) NULL,
  CONSTRAINT pk_propietario PRIMARY KEY (documento)
) ENGINE = InnoDB;

-- PROP_TELEFONO
CREATE TABLE PROP_TELEFONO (
  documento                VARCHAR(15) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  CONSTRAINT pk_prop_telefono PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_prop_telefono_propietario FOREIGN KEY (documento)
    REFERENCES PROPIETARIO (documento)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- INMUEBLE
CREATE TABLE INMUEBLE (
  matricula                VARCHAR(15) NOT NULL,
  calle                    VARCHAR(30) NOT NULL,
  numero                   VARCHAR(10) NOT NULL,
  barrio                   VARCHAR(40) NOT NULL,
  ciudad                   VARCHAR(40) NOT NULL,
  tipo                     VARCHAR(12) NOT NULL,
  area_m2                  DECIMAL(7,2) NOT NULL,
  estrato                  TINYINT NOT NULL,
  habitaciones             TINYINT NOT NULL,
  documento_propietario    VARCHAR(15) NOT NULL,
  id_agente                INT NOT NULL,
  en_venta                 BOOLEAN NOT NULL,
  precio_venta             DECIMAL(14,2) NULL,
  acepta_permuta           BOOLEAN NULL,
  en_arriendo              BOOLEAN NOT NULL,
  canon_mensual            DECIMAL(12,2) NULL,
  deposito                 DECIMAL(12,2) NULL,
  CONSTRAINT pk_inmueble PRIMARY KEY (matricula),
  CONSTRAINT fk_inmueble_propietario FOREIGN KEY (documento_propietario)
    REFERENCES PROPIETARIO (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_inmueble_agente FOREIGN KEY (id_agente)
    REFERENCES AGENTE (id_agente)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CLIENTE
CREATE TABLE CLIENTE (
  documento                VARCHAR(15) NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  presupuesto              DECIMAL(14,2) NOT NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (documento)
) ENGINE = InnoDB;

-- VISITA
CREATE TABLE VISITA (
  documento_cliente        VARCHAR(15) NOT NULL,
  matricula                VARCHAR(15) NOT NULL,
  fecha                    DATE NOT NULL,
  hora                     TIME NOT NULL,
  interes                  TINYINT NOT NULL,
  comentario               VARCHAR(80) NULL,
  CONSTRAINT pk_visita PRIMARY KEY (documento_cliente, matricula, fecha),
  CONSTRAINT fk_visita_cliente FOREIGN KEY (documento_cliente)
    REFERENCES CLIENTE (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_visita_inmueble FOREIGN KEY (matricula)
    REFERENCES INMUEBLE (matricula)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
