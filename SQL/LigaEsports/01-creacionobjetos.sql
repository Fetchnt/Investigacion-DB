-- =====================================================================
--  Liga de e-sports · 01-creacionobjetos.sql
--  Crea la base de datos y las tablas con sus llaves primarias, foráneas y únicas.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

CREATE DATABASE IF NOT EXISTS esports
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE esports;

-- EQUIPO
CREATE TABLE EQUIPO (
  id_equipo                INT NOT NULL,
  nombre                   VARCHAR(40) NOT NULL,
  pais                     VARCHAR(30) NOT NULL,
  fecha_fundacion          DATE NOT NULL,
  CONSTRAINT pk_equipo PRIMARY KEY (id_equipo),
  CONSTRAINT uq_equipo_nombre UNIQUE (nombre)
) ENGINE = InnoDB;

-- JUGADOR
CREATE TABLE JUGADOR (
  id_miembro               INT NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  fecha_nacimiento         DATE NOT NULL,
  nickname                 VARCHAR(20) NOT NULL,
  rol                      VARCHAR(10) NOT NULL,
  id_equipo                INT NOT NULL,
  CONSTRAINT pk_jugador PRIMARY KEY (id_miembro),
  CONSTRAINT uq_jugador_nickname UNIQUE (nickname),
  CONSTRAINT fk_jugador_equipo FOREIGN KEY (id_equipo)
    REFERENCES EQUIPO (id_equipo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ENTRENADOR
CREATE TABLE ENTRENADOR (
  id_miembro               INT NOT NULL,
  nombres                  VARCHAR(40) NOT NULL,
  apellidos                VARCHAR(40) NOT NULL,
  fecha_nacimiento         DATE NOT NULL,
  anios_experiencia        TINYINT NOT NULL,
  id_equipo                INT NOT NULL,
  CONSTRAINT pk_entrenador PRIMARY KEY (id_miembro),
  CONSTRAINT fk_entrenador_equipo FOREIGN KEY (id_equipo)
    REFERENCES EQUIPO (id_equipo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- TORNEO
CREATE TABLE TORNEO (
  id_torneo                INT NOT NULL,
  nombre                   VARCHAR(60) NOT NULL,
  videojuego               VARCHAR(40) NOT NULL,
  fecha_inicio             DATE NOT NULL,
  premio                   DECIMAL(14,2) NOT NULL,
  CONSTRAINT pk_torneo PRIMARY KEY (id_torneo)
) ENGINE = InnoDB;

-- INSCRIPCION
CREATE TABLE INSCRIPCION (
  id_torneo                INT NOT NULL,
  id_entrenador            INT NOT NULL,
  fecha_inscripcion        DATE NOT NULL,
  CONSTRAINT pk_inscripcion PRIMARY KEY (id_torneo, id_entrenador),
  CONSTRAINT fk_inscripcion_torneo FOREIGN KEY (id_torneo)
    REFERENCES TORNEO (id_torneo)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_inscripcion_entrenador FOREIGN KEY (id_entrenador)
    REFERENCES ENTRENADOR (id_miembro)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- PARTIDA
CREATE TABLE PARTIDA (
  id_partida               INT NOT NULL,
  fecha                    DATE NOT NULL,
  ronda                    VARCHAR(10) NOT NULL,
  duracion_min             SMALLINT NOT NULL,
  puntos_local             TINYINT NOT NULL,
  puntos_visitante         TINYINT NOT NULL,
  id_torneo                INT NOT NULL,
  id_equipo_local          INT NOT NULL,
  id_equipo_visitante      INT NOT NULL,
  CONSTRAINT pk_partida PRIMARY KEY (id_partida),
  CONSTRAINT fk_partida_torneo FOREIGN KEY (id_torneo)
    REFERENCES TORNEO (id_torneo)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_partida_id_equipo_local FOREIGN KEY (id_equipo_local)
    REFERENCES EQUIPO (id_equipo)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_partida_id_equipo_visitante FOREIGN KEY (id_equipo_visitante)
    REFERENCES EQUIPO (id_equipo)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ESTADISTICA
CREATE TABLE ESTADISTICA (
  id_jugador               INT NOT NULL,
  id_partida               INT NOT NULL,
  kills                    TINYINT NOT NULL,
  muertes                  TINYINT NOT NULL,
  asistencias              TINYINT NOT NULL,
  CONSTRAINT pk_estadistica PRIMARY KEY (id_jugador, id_partida),
  CONSTRAINT fk_estadistica_jugador FOREIGN KEY (id_jugador)
    REFERENCES JUGADOR (id_miembro)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_estadistica_partida FOREIGN KEY (id_partida)
    REFERENCES PARTIDA (id_partida)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;
