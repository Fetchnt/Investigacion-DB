-- =====================================================================
--  Empresa de mensajería · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

CREATE DATABASE IF NOT EXISTS mensajeria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE mensajeria;

-- SEDE
CREATE TABLE SEDE (
  id_sede                  INT NOT NULL,
  ciudad                   VARCHAR(40) NOT NULL,
  direccion                VARCHAR(80) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  CONSTRAINT pk_sede PRIMARY KEY (id_sede)
) ENGINE = InnoDB;

-- MENSAJERO
CREATE TABLE MENSAJERO (
  id_mensajero             INT NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  licencia                 VARCHAR(10) NOT NULL,
  vehiculo                 VARCHAR(10) NOT NULL,
  id_sede                  INT NOT NULL,
  CONSTRAINT pk_mensajero PRIMARY KEY (id_mensajero),
  CONSTRAINT uq_mensajero_licencia UNIQUE (licencia),
  CONSTRAINT fk_mensajero_sede FOREIGN KEY (id_sede)
    REFERENCES SEDE (id_sede)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CLIENTE
CREATE TABLE CLIENTE (
  nit                      VARCHAR(15) NOT NULL,
  razon_social             VARCHAR(80) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  correo                   VARCHAR(80) NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (nit)
) ENGINE = InnoDB;

-- ENVIO
CREATE TABLE ENVIO (
  guia                     VARCHAR(12) NOT NULL,
  fecha_recepcion          DATE NOT NULL,
  peso_kg                  DECIMAL(6,2) NOT NULL,
  valor_declarado          DECIMAL(12,2) NOT NULL,
  costo                    DECIMAL(10,2) NOT NULL,
  destinatario             VARCHAR(80) NOT NULL,
  direccion_destino        VARCHAR(80) NOT NULL,
  ciudad_destino           VARCHAR(40) NOT NULL,
  nit_cliente              VARCHAR(15) NOT NULL,
  id_sede_origen           INT NOT NULL,
  CONSTRAINT pk_envio PRIMARY KEY (guia),
  CONSTRAINT fk_envio_cliente FOREIGN KEY (nit_cliente)
    REFERENCES CLIENTE (nit)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_envio_sede FOREIGN KEY (id_sede_origen)
    REFERENCES SEDE (id_sede)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- PAQUETE
CREATE TABLE PAQUETE (
  guia                     VARCHAR(12) NOT NULL,
  alto_cm                  SMALLINT NOT NULL,
  ancho_cm                 SMALLINT NOT NULL,
  largo_cm                 SMALLINT NOT NULL,
  fragil                   BOOLEAN NOT NULL,
  CONSTRAINT pk_paquete PRIMARY KEY (guia),
  CONSTRAINT fk_paquete_envio FOREIGN KEY (guia)
    REFERENCES ENVIO (guia)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- DOCUMENTO
CREATE TABLE DOCUMENTO (
  guia                     VARCHAR(12) NOT NULL,
  num_folios               SMALLINT NOT NULL,
  certificado              BOOLEAN NOT NULL,
  CONSTRAINT pk_documento PRIMARY KEY (guia),
  CONSTRAINT fk_documento_envio FOREIGN KEY (guia)
    REFERENCES ENVIO (guia)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ASIGNACION
CREATE TABLE ASIGNACION (
  guia                     VARCHAR(12) NOT NULL,
  id_mensajero             INT NOT NULL,
  fecha_asignacion         DATE NOT NULL,
  CONSTRAINT pk_asignacion PRIMARY KEY (guia),
  CONSTRAINT fk_asignacion_envio FOREIGN KEY (guia)
    REFERENCES ENVIO (guia)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_asignacion_mensajero FOREIGN KEY (id_mensajero)
    REFERENCES MENSAJERO (id_mensajero)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- SEGUIMIENTO
CREATE TABLE SEGUIMIENTO (
  guia                     VARCHAR(12) NOT NULL,
  consecutivo              TINYINT NOT NULL,
  fecha_hora               DATETIME NOT NULL,
  estado                   VARCHAR(12) NOT NULL,
  observacion              VARCHAR(80) NULL,
  CONSTRAINT pk_seguimiento PRIMARY KEY (guia, consecutivo),
  CONSTRAINT fk_seguimiento_envio FOREIGN KEY (guia)
    REFERENCES ENVIO (guia)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;
