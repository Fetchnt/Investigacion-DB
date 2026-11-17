-- =====================================================================
--  Clínica veterinaria · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

CREATE DATABASE IF NOT EXISTS veterinaria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE veterinaria;

-- DUENO
CREATE TABLE DUENO (
  cedula                   VARCHAR(12) NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  direccion                VARCHAR(80) NOT NULL,
  correo                   VARCHAR(80) NULL,
  CONSTRAINT pk_dueno PRIMARY KEY (cedula),
  CONSTRAINT uq_dueno_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- DUE_TELEFONO
CREATE TABLE DUE_TELEFONO (
  cedula                   VARCHAR(12) NOT NULL,
  telefono                 VARCHAR(15) NOT NULL,
  CONSTRAINT pk_due_telefono PRIMARY KEY (cedula, telefono),
  CONSTRAINT fk_due_telefono_dueno FOREIGN KEY (cedula)
    REFERENCES DUENO (cedula)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- MASCOTA
CREATE TABLE MASCOTA (
  cedula_dueno             VARCHAR(12) NOT NULL,
  numero                   TINYINT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  especie                  VARCHAR(20) NOT NULL,
  raza                     VARCHAR(30) NULL,
  fecha_nacimiento         DATE NOT NULL,
  CONSTRAINT pk_mascota PRIMARY KEY (cedula_dueno, numero),
  CONSTRAINT fk_mascota_dueno FOREIGN KEY (cedula_dueno)
    REFERENCES DUENO (cedula)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- VETERINARIO
CREATE TABLE VETERINARIO (
  id_veterinario           INT NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  tarjeta_profesional      VARCHAR(15) NOT NULL,
  especialidad             VARCHAR(40) NOT NULL,
  CONSTRAINT pk_veterinario PRIMARY KEY (id_veterinario),
  CONSTRAINT uq_veterinario_tarjeta_profesional UNIQUE (tarjeta_profesional)
) ENGINE = InnoDB;

-- CONSULTA
CREATE TABLE CONSULTA (
  id_consulta              INT NOT NULL,
  fecha                    DATE NOT NULL,
  motivo                   VARCHAR(80) NOT NULL,
  diagnostico              VARCHAR(120) NULL,
  valor                    DECIMAL(10,2) NOT NULL,
  cedula_dueno             VARCHAR(12) NOT NULL,
  numero_mascota           TINYINT NOT NULL,
  id_veterinario           INT NOT NULL,
  CONSTRAINT pk_consulta PRIMARY KEY (id_consulta),
  CONSTRAINT fk_consulta_mascota FOREIGN KEY (cedula_dueno, numero_mascota)
    REFERENCES MASCOTA (cedula_dueno, numero)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_consulta_veterinario FOREIGN KEY (id_veterinario)
    REFERENCES VETERINARIO (id_veterinario)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- MEDICAMENTO
CREATE TABLE MEDICAMENTO (
  codigo                   VARCHAR(10) NOT NULL,
  nombre                   VARCHAR(60) NOT NULL,
  presentacion             VARCHAR(30) NOT NULL,
  precio                   DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_medicamento PRIMARY KEY (codigo)
) ENGINE = InnoDB;

-- RECETA
CREATE TABLE RECETA (
  id_consulta              INT NOT NULL,
  codigo_medicamento       VARCHAR(10) NOT NULL,
  dosis                    VARCHAR(40) NOT NULL,
  dias                     TINYINT NOT NULL,
  CONSTRAINT pk_receta PRIMARY KEY (id_consulta, codigo_medicamento),
  CONSTRAINT fk_receta_consulta FOREIGN KEY (id_consulta)
    REFERENCES CONSULTA (id_consulta)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_receta_medicamento FOREIGN KEY (codigo_medicamento)
    REFERENCES MEDICAMENTO (codigo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- URGENCIA
CREATE TABLE URGENCIA (
  id_consulta              INT NOT NULL,
  nivel_triage             TINYINT NOT NULL,
  CONSTRAINT pk_urgencia PRIMARY KEY (id_consulta),
  CONSTRAINT fk_urgencia_consulta FOREIGN KEY (id_consulta)
    REFERENCES CONSULTA (id_consulta)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CONTROL
CREATE TABLE CONTROL (
  id_consulta              INT NOT NULL,
  fecha_proximo_control    DATE NOT NULL,
  CONSTRAINT pk_control PRIMARY KEY (id_consulta),
  CONSTRAINT fk_control_consulta FOREIGN KEY (id_consulta)
    REFERENCES CONSULTA (id_consulta)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;
