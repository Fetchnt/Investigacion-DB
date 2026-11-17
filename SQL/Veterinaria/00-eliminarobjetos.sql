-- =====================================================================
--  Clínica veterinaria · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

DROP VIEW IF EXISTS v_historia_clinica;
DROP VIEW IF EXISTS v_tipo_consulta;

DROP TABLE IF EXISTS CONTROL;
DROP TABLE IF EXISTS URGENCIA;
DROP TABLE IF EXISTS RECETA;
DROP TABLE IF EXISTS MEDICAMENTO;
DROP TABLE IF EXISTS CONSULTA;
DROP TABLE IF EXISTS VETERINARIO;
DROP TABLE IF EXISTS MASCOTA;
DROP TABLE IF EXISTS DUE_TELEFONO;
DROP TABLE IF EXISTS DUENO;
