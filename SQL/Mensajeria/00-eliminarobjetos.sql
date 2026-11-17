-- =====================================================================
--  Empresa de mensajería · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

DROP VIEW IF EXISTS v_rastreo;
DROP VIEW IF EXISTS v_planilla_mensajero;

DROP TABLE IF EXISTS SEGUIMIENTO;
DROP TABLE IF EXISTS ASIGNACION;
DROP TABLE IF EXISTS DOCUMENTO;
DROP TABLE IF EXISTS PAQUETE;
DROP TABLE IF EXISTS ENVIO;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS MENSAJERO;
DROP TABLE IF EXISTS SEDE;
