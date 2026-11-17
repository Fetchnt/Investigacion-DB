-- =====================================================================
--  Cadena hotelera · 00-eliminarobjetos.sql
--  Borra vistas y tablas para reinstalar desde cero.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

DROP VIEW IF EXISTS v_estadias;
DROP VIEW IF EXISTS v_cuenta_reserva;

DROP TABLE IF EXISTS CONSUMO;
DROP TABLE IF EXISTS SERVICIO;
DROP TABLE IF EXISTS ALOJAMIENTO;
DROP TABLE IF EXISTS RESERVA;
DROP TABLE IF EXISTS HUESPED;
DROP TABLE IF EXISTS HABITACION;
DROP TABLE IF EXISTS HOTEL;
