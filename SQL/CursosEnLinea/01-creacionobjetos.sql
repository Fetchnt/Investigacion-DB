-- =====================================================================
--  Plataforma de cursos en línea · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

CREATE DATABASE IF NOT EXISTS cursos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE cursos;

-- CATEGORIA
CREATE TABLE CATEGORIA (
  id_categoria             INT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
  CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
) ENGINE = InnoDB;

-- USUARIO
CREATE TABLE USUARIO (
  id_usuario               INT NOT NULL,
  correo                   VARCHAR(80) NOT NULL,
  nombre                   VARCHAR(80) NOT NULL,
  fecha_registro           DATE NOT NULL,
  pais                     VARCHAR(40) NOT NULL,
  es_estudiante            BOOLEAN NOT NULL,
  es_instructor            BOOLEAN NOT NULL,
  nivel_educativo          VARCHAR(20) NULL,
  profesion                VARCHAR(60) NULL,
  biografia                VARCHAR(200) NULL,
  CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT uq_usuario_correo UNIQUE (correo)
) ENGINE = InnoDB;

-- CURSO
CREATE TABLE CURSO (
  codigo                   VARCHAR(8) NOT NULL,
  titulo                   VARCHAR(80) NOT NULL,
  nivel                    VARCHAR(12) NOT NULL,
  precio                   DECIMAL(10,2) NOT NULL,
  fecha_publicacion        DATE NOT NULL,
  id_categoria             INT NOT NULL,
  id_instructor            INT NOT NULL,
  nombre_foro              VARCHAR(60) NOT NULL,
  foro_moderado            BOOLEAN NOT NULL,
  CONSTRAINT pk_curso PRIMARY KEY (codigo),
  CONSTRAINT uq_curso_nombre_foro UNIQUE (nombre_foro),
  CONSTRAINT fk_curso_categoria FOREIGN KEY (id_categoria)
    REFERENCES CATEGORIA (id_categoria)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_curso_usuario FOREIGN KEY (id_instructor)
    REFERENCES USUARIO (id_usuario)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- CURSO_IDIOMA
CREATE TABLE CURSO_IDIOMA (
  codigo_curso             VARCHAR(8) NOT NULL,
  idioma                   CHAR(2) NOT NULL,
  CONSTRAINT pk_curso_idioma PRIMARY KEY (codigo_curso, idioma),
  CONSTRAINT fk_curso_idioma_curso FOREIGN KEY (codigo_curso)
    REFERENCES CURSO (codigo)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- INSCRIPCION
CREATE TABLE INSCRIPCION (
  id_estudiante            INT NOT NULL,
  codigo_curso             VARCHAR(8) NOT NULL,
  fecha_inscripcion        DATE NOT NULL,
  progreso                 TINYINT NOT NULL,
  calificacion             DECIMAL(2,1) NULL,
  CONSTRAINT pk_inscripcion PRIMARY KEY (id_estudiante, codigo_curso),
  CONSTRAINT fk_inscripcion_usuario FOREIGN KEY (id_estudiante)
    REFERENCES USUARIO (id_usuario)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_inscripcion_curso FOREIGN KEY (codigo_curso)
    REFERENCES CURSO (codigo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
