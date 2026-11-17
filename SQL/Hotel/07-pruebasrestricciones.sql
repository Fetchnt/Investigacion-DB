-- =====================================================================
--  Cadena hotelera · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

START TRANSACTION;

-- 1. Número de habitación repetido en el mismo hotel
--    Error esperado: 1062 (viola uq_habitacion_nit_hotel_numero)
INSERT INTO HABITACION VALUES (9, '101', 1, 2, 300000, '900123456-1', 'estandar', NULL, NULL, 'doble');

-- 2. Reserva de un huésped que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO RESERVA VALUES ('R-099', '2026-11-01', '2026-12-01', '2026-12-03', 'confirmada', '00000000');

-- 3. Salida antes de la entrada
--    Error esperado: 3819 (viola chk_reserva_fechas)
INSERT INTO RESERVA VALUES ('R-098', '2026-11-01', '2026-12-05', '2026-12-03', 'confirmada', '80123456');

-- 4. Suite sin metros cuadrados
--    Error esperado: 3819 (viola chk_habitacion_subtipo)
INSERT INTO HABITACION VALUES (9, '502', 5, 4, 700000, '900123456-1', 'suite', NULL, 1, NULL);

-- 5. Estándar con datos de suite
--    Error esperado: 3819 (viola chk_habitacion_subtipo)
UPDATE HABITACION SET jacuzzi = 1 WHERE id_habitacion = 1;

-- 6. El mismo servicio cargado dos veces el mismo día
--    Error esperado: 1062 (llave duplicada)
INSERT INTO CONSUMO VALUES ('R-001', 1, '2026-09-05', 1);

-- 7. Borrar un hotel que tiene habitaciones
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM HOTEL WHERE nit = '900345678-3';

-- 8. Hotel de seis estrellas
--    Error esperado: 3819 (viola chk_hotel_estrellas)
INSERT INTO HOTEL VALUES ('900999999-9', 'Hotel Imposible', 'Medellin', 'Cll 1', 6);

-- 9. Correo de huésped repetido
--    Error esperado: 1062 (llave duplicada)
INSERT INTO HUESPED VALUES ('555', 'Ana', 'Mora', 'vrojas@mail.com', 'Colombia');

ROLLBACK;
