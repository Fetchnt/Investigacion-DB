-- =====================================================================
--  Festival de música · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

CREATE DATABASE IF NOT EXISTS festival
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE festival;

-- ESCENARIO
CREATE TABLE ESCENARIO (
  codigo                   CHAR(3) NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  aforo                    INT NOT NULL,
  CONSTRAINT pk_escenario PRIMARY KEY (codigo)
) ENGINE = InnoDB;

-- ARTISTA
CREATE TABLE ARTISTA (
  id_artista               INT NOT NULL,
  nombre_artistico         VARCHAR(60) NOT NULL,
  pais                     VARCHAR(40) NOT NULL,
  CONSTRAINT pk_artista PRIMARY KEY (id_artista)
) ENGINE = InnoDB;

-- ART_GENERO
CREATE TABLE ART_GENERO (
  id_artista               INT NOT NULL,
  genero                   VARCHAR(30) NOT NULL,
  CONSTRAINT pk_art_genero PRIMARY KEY (id_artista, genero),
  CONSTRAINT fk_art_genero_artista FOREIGN KEY (id_artista)
    REFERENCES ARTISTA (id_artista)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- SOLISTA
CREATE TABLE SOLISTA (
  id_artista               INT NOT NULL,
  nombre_real              VARCHAR(80) NOT NULL,
  instrumento              VARCHAR(30) NOT NULL,
  CONSTRAINT pk_solista PRIMARY KEY (id_artista),
  CONSTRAINT fk_solista_artista FOREIGN KEY (id_artista)
    REFERENCES ARTISTA (id_artista)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- AGRUPACION
CREATE TABLE AGRUPACION (
  id_artista               INT NOT NULL,
  num_integrantes          TINYINT NOT NULL,
  anio_formacion           SMALLINT NOT NULL,
  CONSTRAINT pk_agrupacion PRIMARY KEY (id_artista),
  CONSTRAINT fk_agrupacion_artista FOREIGN KEY (id_artista)
    REFERENCES ARTISTA (id_artista)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- JORNADA
CREATE TABLE JORNADA (
  numero                   TINYINT NOT NULL,
  fecha                    DATE NOT NULL,
  hora_apertura            TIME NOT NULL,
  hora_cierre              TIME NOT NULL,
  CONSTRAINT pk_jornada PRIMARY KEY (numero),
  CONSTRAINT uq_jornada_fecha UNIQUE (fecha)
) ENGINE = InnoDB;

-- PRESENTACION
CREATE TABLE PRESENTACION (
  id_artista               INT NOT NULL,
  numero_jornada           TINYINT NOT NULL,
  codigo_escenario         CHAR(3) NOT NULL,
  hora_inicio              TIME NOT NULL,
  duracion_min             SMALLINT NOT NULL,
  CONSTRAINT pk_presentacion PRIMARY KEY (id_artista, numero_jornada),
  CONSTRAINT fk_presentacion_artista FOREIGN KEY (id_artista)
    REFERENCES ARTISTA (id_artista)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_presentacion_jornada FOREIGN KEY (numero_jornada)
    REFERENCES JORNADA (numero)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_presentacion_escenario FOREIGN KEY (codigo_escenario)
    REFERENCES ESCENARIO (codigo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ASISTENTE
CREATE TABLE ASISTENTE (
  documento                VARCHAR(15) NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  correo                   VARCHAR(80) NOT NULL,
  fecha_nacimiento         DATE NOT NULL,
  CONSTRAINT pk_asistente PRIMARY KEY (documento),
  CONSTRAINT uq_asistente_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- BOLETA
CREATE TABLE BOLETA (
  codigo                   VARCHAR(10) NOT NULL,
  tipo                     VARCHAR(10) NOT NULL,
  precio                   DECIMAL(10,2) NOT NULL,
  fecha_compra             DATE NOT NULL,
  documento_asistente      VARCHAR(15) NOT NULL,
  CONSTRAINT pk_boleta PRIMARY KEY (codigo),
  CONSTRAINT fk_boleta_asistente FOREIGN KEY (documento_asistente)
    REFERENCES ASISTENTE (documento)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- BOLETA_JORNADA
CREATE TABLE BOLETA_JORNADA (
  codigo_boleta            VARCHAR(10) NOT NULL,
  numero_jornada           TINYINT NOT NULL,
  CONSTRAINT pk_boleta_jornada PRIMARY KEY (codigo_boleta, numero_jornada),
  CONSTRAINT fk_boleta_jornada_boleta FOREIGN KEY (codigo_boleta)
    REFERENCES BOLETA (codigo)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_boleta_jornada_jornada FOREIGN KEY (numero_jornada)
    REFERENCES JORNADA (numero)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
