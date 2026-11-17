-- =====================================================================
--  Cadena de cines · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

DROP VIEW IF EXISTS v_cartelera;
DROP VIEW IF EXISTS v_ocupacion;

DROP TABLE IF EXISTS TIQUETE;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS FUNCION;
DROP TABLE IF EXISTS PELICULA;
DROP TABLE IF EXISTS SALA;
DROP TABLE IF EXISTS CINE_TELEFONO;
DROP TABLE IF EXISTS CINE;
