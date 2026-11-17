-- =====================================================================
--  Festival de música · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

START TRANSACTION;

-- ESCENARIO (3)
INSERT INTO ESCENARIO (codigo, nombre, aforo) VALUES
  ('PRI', 'Escenario Principal', 20000),
  ('BOS', 'Carpa Bosque', 5000),
  ('ELE', 'Domo Electronico', 3000);

-- ARTISTA (7)
INSERT INTO ARTISTA (id_artista, nombre_artistico, pais) VALUES
  (1, 'Marea Alta', 'Colombia'),
  (2, 'Lianna Voss', 'Chile'),
  (3, 'Los Cumbiamberos del Sur', 'Argentina'),
  (4, 'DJ Kaleido', 'Mexico'),
  (5, 'Nube Roja', 'Colombia'),
  (6, 'Tomas Riel', 'Espana'),
  (7, 'Selva Electrica', 'Colombia');

-- ART_GENERO (12)
INSERT INTO ART_GENERO (id_artista, genero) VALUES
  (1, 'rock'),
  (1, 'alternativo'),
  (2, 'pop'),
  (3, 'cumbia'),
  (3, 'tropical'),
  (4, 'electronica'),
  (4, 'house'),
  (5, 'rock'),
  (6, 'folk'),
  (6, 'pop'),
  (7, 'electronica'),
  (7, 'tropical');

-- SOLISTA (3)
INSERT INTO SOLISTA (id_artista, nombre_real, instrumento) VALUES
  (2, 'Liliana Vasquez Soto', 'voz'),
  (4, 'Kevin Alarcon', 'sintetizador'),
  (6, 'Tomas Rielo Garcia', 'guitarra');

-- AGRUPACION (4)
INSERT INTO AGRUPACION (id_artista, num_integrantes, anio_formacion) VALUES
  (1, 4, 2011),
  (3, 6, 2005),
  (5, 3, 2018),
  (7, 5, 2020);

-- JORNADA (3)
INSERT INTO JORNADA (numero, fecha, hora_apertura, hora_cierre) VALUES
  (1, '2026-11-27', '14:00:00', '23:59:00'),
  (2, '2026-11-28', '13:00:00', '23:59:00'),
  (3, '2026-11-29', '13:00:00', '22:30:00');

-- PRESENTACION (10)
INSERT INTO PRESENTACION (id_artista, numero_jornada, codigo_escenario, hora_inicio, duracion_min) VALUES
  (1, 1, 'PRI', '21:00:00', 90),
  (2, 1, 'BOS', '18:00:00', 60),
  (4, 1, 'ELE', '22:00:00', 120),
  (3, 2, 'PRI', '20:00:00', 90),
  (5, 2, 'BOS', '19:30:00', 60),
  (7, 2, 'ELE', '21:00:00', 90),
  (6, 3, 'BOS', '17:00:00', 60),
  (1, 3, 'BOS', '19:00:00', 75),
  (4, 3, 'ELE', '20:00:00', 120),
  (2, 3, 'PRI', '21:00:00', 75);

-- ASISTENTE (5)
INSERT INTO ASISTENTE (documento, nombre, correo, fecha_nacimiento) VALUES
  ('1015443322', 'Natalia Pineda', 'npineda@mail.com', '2001-04-12'),
  ('1007766554', 'Julian Becerra', 'jbecerra@mail.com', '1998-10-30'),
  ('1122334455', 'Sofia Montoya', 'smontoya@mail.com', '2006-02-08'),
  ('52987654', 'Patricia Leal', 'pleal@mail.com', '1979-07-21'),
  ('1099887766', 'Kevin Duarte', 'kduarte@mail.com', '2003-12-01');

-- BOLETA (7)
INSERT INTO BOLETA (codigo, tipo, precio, fecha_compra, documento_asistente) VALUES
  ('B-1001', 'abono', 650000.0, '2026-08-10', '1015443322'),
  ('B-1002', 'general', 250000.0, '2026-09-01', '1007766554'),
  ('B-1003', 'vip', 480000.0, '2026-09-15', '1007766554'),
  ('B-1004', 'general', 250000.0, '2026-10-05', '1122334455'),
  ('B-1005', 'abono', 650000.0, '2026-10-20', '52987654'),
  ('B-1006', 'vip', 480000.0, '2026-11-02', '1099887766'),
  ('B-1007', 'general', 250000.0, '2026-11-10', '1099887766');

-- BOLETA_JORNADA (11)
INSERT INTO BOLETA_JORNADA (codigo_boleta, numero_jornada) VALUES
  ('B-1001', 1),
  ('B-1001', 2),
  ('B-1001', 3),
  ('B-1002', 1),
  ('B-1003', 2),
  ('B-1004', 3),
  ('B-1005', 1),
  ('B-1005', 2),
  ('B-1005', 3),
  ('B-1006', 3),
  ('B-1007', 2);

COMMIT;
