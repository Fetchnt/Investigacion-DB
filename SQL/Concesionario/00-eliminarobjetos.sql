-- =====================================================================
--  Concesionario de vehículos · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

DROP VIEW IF EXISTS v_inventario;
DROP VIEW IF EXISTS v_comisiones;

DROP TABLE IF EXISTS VENTA;
DROP TABLE IF EXISTS VEH_ACCESORIO;
DROP TABLE IF EXISTS ACCESORIO;
DROP TABLE IF EXISTS VEHICULO_USADO;
DROP TABLE IF EXISTS VEHICULO_NUEVO;
DROP TABLE IF EXISTS VEHICULO;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS VENDEDOR;
DROP TABLE IF EXISTS SEDE;
