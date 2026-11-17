-- =====================================================================
--  Clínica veterinaria · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

START TRANSACTION;

-- DUENO (5)
INSERT INTO DUENO (cedula, nombres, apellidos, direccion, correo) VALUES
  ('1012345678', 'Laura', 'Gomez Rios', 'Cra 7 # 45-10', 'laura.gomez@mail.com'),
  ('1023456789', 'Andres', 'Pardo Leon', 'Cll 100 # 15-20', 'andres.pardo@mail.com'),
  ('52345678', 'Marta', 'Cifuentes Diaz', 'Av 68 # 22-31', NULL),
  ('79456123', 'Jorge', 'Salamanca Ruiz', 'Cll 53 # 9-14', 'jsalamanca@mail.com'),
  ('1034567890', 'Camila', 'Ortega Pena', 'Cra 15 # 80-05', 'camila.op@mail.com');

-- DUE_TELEFONO (7)
INSERT INTO DUE_TELEFONO (cedula, telefono) VALUES
  ('1012345678', '3104567890'),
  ('1012345678', '6012345678'),
  ('1023456789', '3157894561'),
  ('52345678', '3201112233'),
  ('52345678', '3009998877'),
  ('79456123', '3114445566'),
  ('1034567890', '3186667788');

-- MASCOTA (8)
INSERT INTO MASCOTA (cedula_dueno, numero, nombre, especie, raza, fecha_nacimiento) VALUES
  ('1012345678', 1, 'Luna', 'perro', 'Labrador', '2019-03-14'),
  ('1012345678', 2, 'Michi', 'gato', NULL, '2021-07-02'),
  ('1023456789', 1, 'Rocky', 'perro', 'Bulldog frances', '2020-11-20'),
  ('52345678', 1, 'Kiwi', 'ave', 'Periquito', '2023-01-10'),
  ('52345678', 2, 'Toby', 'perro', 'Criollo', '2016-05-30'),
  ('79456123', 1, 'Nala', 'gato', 'Siames', '2018-09-09'),
  ('1034567890', 1, 'Coco', 'conejo', 'Cabeza de leon', '2022-04-18'),
  ('1034567890', 2, 'Max', 'perro', 'Golden retriever', '2024-02-25');

-- VETERINARIO (4)
INSERT INTO VETERINARIO (id_veterinario, nombre, tarjeta_profesional, especialidad) VALUES
  (1, 'Diana Morales', 'TP-10234', 'Medicina general'),
  (2, 'Felipe Castano', 'TP-11876', 'Cirugia'),
  (3, 'Natalia Ruiz', 'TP-12950', 'Dermatologia'),
  (4, 'Oscar Benitez', 'TP-13421', 'Medicina general');

-- CONSULTA (10)
INSERT INTO CONSULTA (id_consulta, fecha, motivo, diagnostico, valor, cedula_dueno, numero_mascota, id_veterinario) VALUES
  (1, '2026-09-02', 'Vacunacion anual', 'Sano', 60000.0, '1012345678', 1, 1),
  (2, '2026-09-05', 'Vomito y decaimiento', 'Gastroenteritis', 95000.0, '1023456789', 1, 1),
  (3, '2026-09-12', 'Herida en pata', 'Laceracion leve', 120000.0, '52345678', 2, 2),
  (4, '2026-09-20', 'Caida de pelo', 'Dermatitis alergica', 110000.0, '79456123', 1, 3),
  (5, '2026-10-01', 'Control de herida', 'Cicatrizacion normal', 50000.0, '52345678', 2, 2),
  (6, '2026-10-08', 'Fractura de ala', NULL, 150000.0, '52345678', 1, 2),
  (7, '2026-10-15', 'Picazon constante', 'Dermatitis alergica', 110000.0, '1012345678', 2, 3),
  (8, '2026-10-22', 'Vacunacion anual', 'Sano', 60000.0, '1034567890', 2, 1),
  (9, '2026-11-03', 'Control dermatitis', 'Mejoria', 70000.0, '79456123', 1, 3),
  (10, '2026-11-10', 'Intoxicacion', 'Ingesta de chocolate', 180000.0, '1034567890', 2, 1);

-- MEDICAMENTO (6)
INSERT INTO MEDICAMENTO (codigo, nombre, presentacion, precio) VALUES
  ('MED-01', 'Amoxicilina 250 mg', 'Tabletas', 18000.0),
  ('MED-02', 'Meloxicam 1.5 mg/ml', 'Suspension oral', 32000.0),
  ('MED-03', 'Omeprazol 20 mg', 'Capsulas', 15000.0),
  ('MED-04', 'Prednisolona 5 mg', 'Tabletas', 21000.0),
  ('MED-05', 'Clorhexidina 2%', 'Solucion topica', 12500.0),
  ('MED-06', 'Vacuna polivalente', 'Inyectable', 45000.0);

-- RECETA (10)
INSERT INTO RECETA (id_consulta, codigo_medicamento, dosis, dias) VALUES
  (2, 'MED-03', '1 capsula cada 24 h', 5),
  (2, 'MED-02', '0.5 ml cada 24 h', 3),
  (3, 'MED-01', '1 tableta cada 12 h', 7),
  (3, 'MED-05', 'Aplicar 2 veces al dia', 10),
  (4, 'MED-04', '1 tableta cada 24 h', 10),
  (6, 'MED-02', '0.2 ml cada 24 h', 5),
  (7, 'MED-04', '1/2 tableta cada 24 h', 7),
  (7, 'MED-05', 'Bano cada 3 dias', 15),
  (9, 'MED-04', '1/2 tableta cada 48 h', 14),
  (10, 'MED-03', '1 capsula cada 12 h', 3);

-- URGENCIA (4)
INSERT INTO URGENCIA (id_consulta, nivel_triage) VALUES
  (2, 3),
  (3, 2),
  (6, 2),
  (10, 1);

-- CONTROL (2)
INSERT INTO CONTROL (id_consulta, fecha_proximo_control) VALUES
  (5, '2026-10-29'),
  (9, '2026-12-03');

COMMIT;
