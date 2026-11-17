-- =====================================================================
--  Taller mecánico · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

CREATE DATABASE IF NOT EXISTS taller
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE taller;

-- CLIENTE
CREATE TABLE CLIENTE (
  documento                VARCHAR(15) NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  correo                   VARCHAR(80) NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (documento)
) ENGINE = InnoDB;

-- VEHICULO
CREATE TABLE VEHICULO (
  placa                    CHAR(6) NOT NULL,
  marca                    VARCHAR(30) NOT NULL,
  linea                    VARCHAR(30) NOT NULL,
  modelo                   SMALLINT NOT NULL,
  color                    VARCHAR(20) NOT NULL,
  documento_cliente        VARCHAR(15) NOT NULL,
  CONSTRAINT pk_vehiculo PRIMARY KEY (placa),
  CONSTRAINT fk_vehiculo_cliente FOREIGN KEY (documento_cliente)
    REFERENCES CLIENTE (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- MECANICO
CREATE TABLE MECANICO (
  id_empleado              INT NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  fecha_ingreso            DATE NOT NULL,
  salario                  DECIMAL(10,2) NOT NULL,
  especialidad             VARCHAR(30) NOT NULL,
  nivel                    VARCHAR(8) NOT NULL,
  CONSTRAINT pk_mecanico PRIMARY KEY (id_empleado)
) ENGINE = InnoDB;

-- ASESOR
CREATE TABLE ASESOR (
  id_empleado              INT NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  fecha_ingreso            DATE NOT NULL,
  salario                  DECIMAL(10,2) NOT NULL,
  extension                VARCHAR(5) NOT NULL,
  meta_mensual             DECIMAL(12,2) NOT NULL,
  CONSTRAINT pk_asesor PRIMARY KEY (id_empleado)
) ENGINE = InnoDB;

-- SUPERVISION
CREATE TABLE SUPERVISION (
  id_mecanico              INT NOT NULL,
  id_supervisor            INT NOT NULL,
  CONSTRAINT pk_supervision PRIMARY KEY (id_mecanico),
  CONSTRAINT fk_supervision_id_mecanico FOREIGN KEY (id_mecanico)
    REFERENCES MECANICO (id_empleado)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_supervision_id_supervisor FOREIGN KEY (id_supervisor)
    REFERENCES MECANICO (id_empleado)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ORDEN
CREATE TABLE ORDEN (
  numero                   INT NOT NULL,
  fecha_ingreso            DATE NOT NULL,
  fecha_entrega            DATE NULL,
  kilometraje              INT NOT NULL,
  estado                   VARCHAR(12) NOT NULL,
  placa                    CHAR(6) NOT NULL,
  id_asesor                INT NOT NULL,
  CONSTRAINT pk_orden PRIMARY KEY (numero),
  CONSTRAINT fk_orden_vehiculo FOREIGN KEY (placa)
    REFERENCES VEHICULO (placa)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_orden_asesor FOREIGN KEY (id_asesor)
    REFERENCES ASESOR (id_empleado)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- TRABAJO
CREATE TABLE TRABAJO (
  numero_orden             INT NOT NULL,
  id_mecanico              INT NOT NULL,
  horas                    DECIMAL(4,1) NOT NULL,
  labor                    VARCHAR(60) NOT NULL,
  CONSTRAINT pk_trabajo PRIMARY KEY (numero_orden, id_mecanico),
  CONSTRAINT fk_trabajo_orden FOREIGN KEY (numero_orden)
    REFERENCES ORDEN (numero)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_trabajo_mecanico FOREIGN KEY (id_mecanico)
    REFERENCES MECANICO (id_empleado)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- REPUESTO
CREATE TABLE REPUESTO (
  codigo                   VARCHAR(10) NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  precio_lista             DECIMAL(10,2) NOT NULL,
  stock                    INT NOT NULL,
  CONSTRAINT pk_repuesto PRIMARY KEY (codigo)
) ENGINE = InnoDB;

-- REPUESTO_ORDEN
CREATE TABLE REPUESTO_ORDEN (
  numero_orden             INT NOT NULL,
  codigo_repuesto          VARCHAR(10) NOT NULL,
  cantidad                 SMALLINT NOT NULL,
  valor_unitario           DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_repuesto_orden PRIMARY KEY (numero_orden, codigo_repuesto),
  CONSTRAINT fk_repuesto_orden_orden FOREIGN KEY (numero_orden)
    REFERENCES ORDEN (numero)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_repuesto_orden_repuesto FOREIGN KEY (codigo_repuesto)
    REFERENCES REPUESTO (codigo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
