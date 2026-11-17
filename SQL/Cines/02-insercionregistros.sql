-- =====================================================================
--  Cadena de cines · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

START TRANSACTION;

-- CINE (3)
INSERT INTO CINE (id_cine, nombre, ciudad, calle, numero, barrio) VALUES
  (1, 'CineArte Centro', 'Bogota', 'Cll 24', '5-60', 'La Candelaria'),
  (2, 'CineArte Norte', 'Bogota', 'Av 19', '120-71', 'Santa Barbara'),
  (3, 'CineArte Laureles', 'Medellin', 'Cra 76', '33-10', 'Laureles');

-- CINE_TELEFONO (5)
INSERT INTO CINE_TELEFONO (id_cine, telefono) VALUES
  (1, '6013345566'),
  (1, '6013345567'),
  (2, '6017788990'),
  (3, '6044451122'),
  (3, '3125556677');

-- SALA (7)
INSERT INTO SALA (id_sala, numero, capacidad, id_cine, tipo, gafas_disponibles, servicio_mesero) VALUES
  (1, 1, 180, 1, 'regular', NULL, NULL),
  (2, 2, 120, 1, '3d', 120, NULL),
  (3, 1, 220, 2, 'regular', NULL, NULL),
  (4, 2, 60, 2, 'vip', NULL, 1),
  (5, 3, 140, 2, '3d', 140, NULL),
  (6, 1, 160, 3, 'regular', NULL, NULL),
  (7, 2, 48, 3, 'vip', NULL, 0);

-- PELICULA (5)
INSERT INTO PELICULA (id_pelicula, titulo, titulo_original, duracion_min, clasificacion, fecha_estreno) VALUES
  (1, 'El faro del sur', NULL, 112, '12+', '2026-10-02'),
  (2, 'Orbita cero', 'Zero Orbit', 138, '12+', '2026-10-16'),
  (3, 'Pequenos gigantes', 'Little Giants', 95, 'T', '2026-10-30'),
  (4, 'La casa del silencio', 'The Silent House', 104, '15+', '2026-11-06'),
  (5, 'Cumbia para dos', NULL, 101, '7+', '2026-11-13');

-- FUNCION (8)
INSERT INTO FUNCION (id_funcion, fecha, hora, precio, idioma, id_sala, id_pelicula) VALUES
  (1, '2026-11-13', '16:00:00', 14000.0, 'doblada', 1, 3),
  (2, '2026-11-13', '19:30:00', 16000.0, 'subtitulada', 2, 2),
  (3, '2026-11-13', '21:00:00', 32000.0, 'subtitulada', 4, 4),
  (4, '2026-11-14', '15:00:00', 15000.0, 'doblada', 5, 3),
  (5, '2026-11-14', '20:00:00', 18000.0, 'doblada', 5, 2),
  (6, '2026-11-14', '18:00:00', 13000.0, 'original', 6, 1),
  (7, '2026-11-15', '20:30:00', 28000.0, 'subtitulada', 7, 4),
  (8, '2026-11-15', '17:00:00', 12000.0, 'original', 3, 1);

-- CLIENTE (5)
INSERT INTO CLIENTE (documento, nombres, apellidos, correo, puntos) VALUES
  ('1018223344', 'Andrea', 'Molina Rey', 'amolina@mail.com', 120),
  ('1033445566', 'Felipe', 'Guzman Toro', 'fguzman@mail.com', 40),
  ('39776655', 'Rosa', 'Castillo Pena', 'rcastillo@mail.com', 300),
  ('1001234321', 'Tomas', 'Acosta Lima', 'tacosta@mail.com', 0),
  ('1077665544', 'Mariana', 'Soto Vega', 'msoto@mail.com', 85);

-- TIQUETE (13)
INSERT INTO TIQUETE (id_funcion, fila, numero_silla, documento_cliente, valor_pagado) VALUES
  (1, 'F', 7, '1018223344', 14000.0),
  (1, 'F', 8, '1018223344', 14000.0),
  (1, 'F', 9, '1018223344', 7000.0),
  (2, 'D', 10, '1033445566', 16000.0),
  (3, 'B', 3, '39776655', 32000.0),
  (3, 'B', 4, '39776655', 32000.0),
  (4, 'H', 1, '1077665544', 15000.0),
  (4, 'H', 2, '1077665544', 15000.0),
  (4, 'J', 6, '1018223344', 15000.0),
  (5, 'E', 5, '1033445566', 18000.0),
  (6, 'C', 12, '39776655', 13000.0),
  (7, 'A', 1, '1018223344', 28000.0),
  (8, 'G', 4, '1077665544', 12000.0);

COMMIT;
