-- =====================================================================
--  Festival de música · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

DROP VIEW IF EXISTS v_cartel;
DROP VIEW IF EXISTS v_ingresos_jornada;

DROP TABLE IF EXISTS BOLETA_JORNADA;
DROP TABLE IF EXISTS BOLETA;
DROP TABLE IF EXISTS ASISTENTE;
DROP TABLE IF EXISTS PRESENTACION;
DROP TABLE IF EXISTS JORNADA;
DROP TABLE IF EXISTS AGRUPACION;
DROP TABLE IF EXISTS SOLISTA;
DROP TABLE IF EXISTS ART_GENERO;
DROP TABLE IF EXISTS ARTISTA;
DROP TABLE IF EXISTS ESCENARIO;
