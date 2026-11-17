-- =====================================================================
--  Taller mecánico · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

DROP VIEW IF EXISTS v_nomina;
DROP VIEW IF EXISTS v_total_orden;

DROP TABLE IF EXISTS REPUESTO_ORDEN;
DROP TABLE IF EXISTS REPUESTO;
DROP TABLE IF EXISTS TRABAJO;
DROP TABLE IF EXISTS ORDEN;
DROP TABLE IF EXISTS SUPERVISION;
DROP TABLE IF EXISTS ASESOR;
DROP TABLE IF EXISTS MECANICO;
DROP TABLE IF EXISTS VEHICULO;
DROP TABLE IF EXISTS CLIENTE;
