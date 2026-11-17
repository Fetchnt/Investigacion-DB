-- =====================================================================
--  Plataforma de cursos en línea · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

DROP VIEW IF EXISTS v_roles;
DROP VIEW IF EXISTS v_avance;

DROP TABLE IF EXISTS INSCRIPCION;
DROP TABLE IF EXISTS CURSO_IDIOMA;
DROP TABLE IF EXISTS CURSO;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS CATEGORIA;
