-- =====================================================================
--  Agencia inmobiliaria · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

DROP VIEW IF EXISTS v_oferta;
DROP VIEW IF EXISTS v_comision;

DROP TABLE IF EXISTS VISITA;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS INMUEBLE;
DROP TABLE IF EXISTS PROP_TELEFONO;
DROP TABLE IF EXISTS PROPIETARIO;
DROP TABLE IF EXISTS AGENTE;
DROP TABLE IF EXISTS RANGO_COMISION;
