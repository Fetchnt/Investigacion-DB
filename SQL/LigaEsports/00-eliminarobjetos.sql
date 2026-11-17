-- =====================================================================
--  Liga de e-sports · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

DROP VIEW IF EXISTS v_resultados;
DROP VIEW IF EXISTS v_inscritos;

DROP TABLE IF EXISTS ESTADISTICA;
DROP TABLE IF EXISTS PARTIDA;
DROP TABLE IF EXISTS INSCRIPCION;
DROP TABLE IF EXISTS TORNEO;
DROP TABLE IF EXISTS ENTRENADOR;
DROP TABLE IF EXISTS JUGADOR;
DROP TABLE IF EXISTS EQUIPO;
