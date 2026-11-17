-- =====================================================================
--  Cadena hotelera · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

START TRANSACTION;

-- HOTEL (3)
INSERT INTO HOTEL (nit, nombre, ciudad, direccion, estrellas) VALUES
  ('900123456-1', 'Hotel Monserrate Plaza', 'Bogota', 'Cll 19 # 4-20', 4),
  ('900234567-2', 'Hotel Bahia Azul', 'Cartagena', 'Av San Martin # 6-40', 5),
  ('900345678-3', 'Hostal Cafe Verde', 'Salento', 'Cra 6 # 3-15', 3);

-- HABITACION (8)
INSERT INTO HABITACION (id_habitacion, numero, piso, capacidad, tarifa_base, nit_hotel, tipo, metros2, jacuzzi, tipo_cama) VALUES
  (1, '101', 1, 2, 280000.0, '900123456-1', 'estandar', NULL, NULL, 'doble'),
  (2, '102', 1, 1, 220000.0, '900123456-1', 'estandar', NULL, NULL, 'sencilla'),
  (3, '501', 5, 4, 650000.0, '900123456-1', 'suite', 48.0, 1, NULL),
  (4, '201', 2, 2, 420000.0, '900234567-2', 'estandar', NULL, NULL, 'queen'),
  (5, '202', 2, 3, 450000.0, '900234567-2', 'estandar', NULL, NULL, 'doble'),
  (6, '901', 9, 4, 1200000.0, '900234567-2', 'suite', 75.5, 1, NULL),
  (7, '1', 1, 2, 180000.0, '900345678-3', 'estandar', NULL, NULL, 'doble'),
  (8, '2', 1, 4, 260000.0, '900345678-3', 'suite', 35.0, 0, NULL);

-- HUESPED (6)
INSERT INTO HUESPED (documento, nombres, apellidos, correo, pais) VALUES
  ('1019876543', 'Valentina', 'Rojas Mejia', 'vrojas@mail.com', 'Colombia'),
  ('80123456', 'Carlos', 'Mendez Ariza', 'cmendez@mail.com', 'Colombia'),
  ('X1234567', 'Emma', 'Schulz', 'emma.schulz@mail.de', 'Alemania'),
  ('AR556677', 'Lucia', 'Fernandez', 'lucia.f@mail.ar', 'Argentina'),
  ('1098765432', 'Santiago', 'Herrera Vela', 'sherrera@mail.com', 'Colombia'),
  ('MX889900', 'Diego', 'Lopez Ramos', 'dlopez@mail.mx', 'Mexico');

-- RESERVA (8)
INSERT INTO RESERVA (codigo, fecha_reserva, fecha_entrada, fecha_salida, estado, documento_huesped) VALUES
  ('R-001', '2026-08-20', '2026-09-04', '2026-09-07', 'finalizada', '1019876543'),
  ('R-002', '2026-08-28', '2026-09-10', '2026-09-12', 'finalizada', 'X1234567'),
  ('R-003', '2026-09-15', '2026-10-02', '2026-10-06', 'finalizada', 'AR556677'),
  ('R-004', '2026-09-30', '2026-10-15', '2026-10-16', 'finalizada', '80123456'),
  ('R-005', '2026-10-05', '2026-10-20', '2026-10-25', 'finalizada', 'X1234567'),
  ('R-006', '2026-10-25', '2026-11-14', '2026-11-18', 'activa', '1098765432'),
  ('R-007', '2026-11-02', '2026-12-20', '2026-12-27', 'confirmada', '1019876543'),
  ('R-008', '2026-11-10', '2026-12-28', '2027-01-02', 'cancelada', 'MX889900');

-- ALOJAMIENTO (10)
INSERT INTO ALOJAMIENTO (codigo_reserva, id_habitacion, tarifa_noche) VALUES
  ('R-001', 1, 280000.0),
  ('R-002', 6, 1150000.0),
  ('R-003', 4, 420000.0),
  ('R-003', 5, 450000.0),
  ('R-004', 2, 220000.0),
  ('R-005', 7, 180000.0),
  ('R-006', 3, 650000.0),
  ('R-007', 6, 1200000.0),
  ('R-007', 4, 420000.0),
  ('R-008', 7, 175000.0);

-- SERVICIO (6)
INSERT INTO SERVICIO (id_servicio, nombre, precio) VALUES
  (1, 'Desayuno buffet', 45000.0),
  (2, 'Lavanderia', 30000.0),
  (3, 'Spa', 120000.0),
  (4, 'Traslado aeropuerto', 80000.0),
  (5, 'Minibar', 25000.0),
  (6, 'Parqueadero', 20000.0);

-- CONSUMO (12)
INSERT INTO CONSUMO (codigo_reserva, id_servicio, fecha, cantidad) VALUES
  ('R-001', 1, '2026-09-05', 2),
  ('R-001', 1, '2026-09-06', 2),
  ('R-001', 2, '2026-09-06', 1),
  ('R-002', 3, '2026-09-11', 2),
  ('R-002', 4, '2026-09-12', 1),
  ('R-003', 1, '2026-10-03', 4),
  ('R-003', 5, '2026-10-04', 3),
  ('R-005', 1, '2026-10-21', 1),
  ('R-005', 1, '2026-10-22', 1),
  ('R-005', 4, '2026-10-25', 1),
  ('R-006', 3, '2026-11-15', 1),
  ('R-006', 5, '2026-11-15', 2);

COMMIT;
