-- =====================================================================
--  Concesionario de vehículos · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

CREATE DATABASE IF NOT EXISTS concesionario
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE concesionario;

-- SEDE
CREATE TABLE SEDE (
  id_sede                  INT NOT NULL,
  nombre                   VARCHAR(60) NOT NULL,
  ciudad                   VARCHAR(40) NOT NULL,
  direccion                VARCHAR(80) NOT NULL,
  CONSTRAINT pk_sede PRIMARY KEY (id_sede)
) ENGINE = InnoDB;

-- VENDEDOR
CREATE TABLE VENDEDOR (
  id_vendedor              INT NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  porcentaje_comision      DECIMAL(4,2) NOT NULL,
  fecha_ingreso            DATE NOT NULL,
  id_sede                  INT NOT NULL,
  CONSTRAINT pk_vendedor PRIMARY KEY (id_vendedor),
  CONSTRAINT fk_vendedor_sede FOREIGN KEY (id_sede)
    REFERENCES SEDE (id_sede)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CLIENTE
CREATE TABLE CLIENTE (
  documento                VARCHAR(15) NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  correo                   VARCHAR(80) NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (documento),
  CONSTRAINT uq_cliente_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- VEHICULO
CREATE TABLE VEHICULO (
  vin                      CHAR(17) NOT NULL,
  marca                    VARCHAR(30) NOT NULL,
  modelo                   VARCHAR(30) NOT NULL,
  anio                     SMALLINT NOT NULL,
  color                    VARCHAR(20) NOT NULL,
  precio_lista             DECIMAL(12,2) NOT NULL,
  id_sede                  INT NOT NULL,
  CONSTRAINT pk_vehiculo PRIMARY KEY (vin),
  CONSTRAINT fk_vehiculo_sede FOREIGN KEY (id_sede)
    REFERENCES SEDE (id_sede)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- VEHICULO_NUEVO
CREATE TABLE VEHICULO_NUEVO (
  vin                      CHAR(17) NOT NULL,
  garantia_meses           TINYINT NOT NULL,
  CONSTRAINT pk_vehiculo_nuevo PRIMARY KEY (vin),
  CONSTRAINT fk_vehiculo_nuevo_vehiculo FOREIGN KEY (vin)
    REFERENCES VEHICULO (vin)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- VEHICULO_USADO
CREATE TABLE VEHICULO_USADO (
  vin                      CHAR(17) NOT NULL,
  kilometraje              INT NOT NULL,
  placa                    CHAR(6) NOT NULL,
  num_propietarios         TINYINT NOT NULL,
  CONSTRAINT pk_vehiculo_usado PRIMARY KEY (vin),
  CONSTRAINT uq_vehiculo_usado_placa UNIQUE (placa),
  CONSTRAINT fk_vehiculo_usado_vehiculo FOREIGN KEY (vin)
    REFERENCES VEHICULO (vin)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ACCESORIO
CREATE TABLE ACCESORIO (
  id_accesorio             INT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  CONSTRAINT pk_accesorio PRIMARY KEY (id_accesorio)
) ENGINE = InnoDB;

-- VEH_ACCESORIO
CREATE TABLE VEH_ACCESORIO (
  vin                      CHAR(17) NOT NULL,
  id_accesorio             INT NOT NULL,
  CONSTRAINT pk_veh_accesorio PRIMARY KEY (vin, id_accesorio),
  CONSTRAINT fk_veh_accesorio_vehiculo FOREIGN KEY (vin)
    REFERENCES VEHICULO (vin)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_veh_accesorio_accesorio FOREIGN KEY (id_accesorio)
    REFERENCES ACCESORIO (id_accesorio)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- VENTA
CREATE TABLE VENTA (
  numero_factura           VARCHAR(12) NOT NULL,
  fecha                    DATE NOT NULL,
  valor_final              DECIMAL(12,2) NOT NULL,
  forma_pago               VARCHAR(10) NOT NULL,
  documento_cliente        VARCHAR(15) NOT NULL,
  id_vendedor              INT NOT NULL,
  vin                      CHAR(17) NOT NULL,
  CONSTRAINT pk_venta PRIMARY KEY (numero_factura),
  CONSTRAINT uq_venta_vin UNIQUE (vin),
  CONSTRAINT fk_venta_cliente FOREIGN KEY (documento_cliente)
    REFERENCES CLIENTE (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_venta_vendedor FOREIGN KEY (id_vendedor)
    REFERENCES VENDEDOR (id_vendedor)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_venta_vehiculo FOREIGN KEY (vin)
    REFERENCES VEHICULO (vin)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
