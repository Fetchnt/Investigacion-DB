-- =====================================================================
--  Taller mecánico · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

START TRANSACTION;

-- CLIENTE (4)
INSERT INTO CLIENTE (documento, nombre, telefono, correo) VALUES
  ('1010101010', 'Gustavo Pineda', '3101112233', 'gpineda@mail.com'),
  ('52111222', 'Liliana Torres', '3112223344', NULL),
  ('80222333', 'Ernesto Vargas', '3123334455', 'evargas@mail.com'),
  ('1030303030', 'Carolina Mejia', '3134445566', 'cmejia@mail.com');

-- VEHICULO (5)
INSERT INTO VEHICULO (placa, marca, linea, modelo, color, documento_cliente) VALUES
  ('ABC123', 'Renault', 'Logan', 2018, 'Gris', '1010101010'),
  ('DEF456', 'Chevrolet', 'Spark GT', 2017, 'Rojo', '52111222'),
  ('GHI789', 'Mazda', '3', 2021, 'Azul', '80222333'),
  ('JKL012', 'Toyota', 'Hilux', 2019, 'Blanco', '80222333'),
  ('MNO345', 'Kia', 'Rio', 2022, 'Negro', '1030303030');

-- MECANICO (5)
INSERT INTO MECANICO (id_empleado, nombres, apellidos, fecha_ingreso, salario, especialidad, nivel) VALUES
  (101, 'Jairo', 'Mendoza Cruz', '2012-03-01', 3800000.0, 'Motor', 'jefe'),
  (102, 'Wilson', 'Ariza Pena', '2018-07-15', 2600000.0, 'Frenos y suspension', 'senior'),
  (103, 'Brayan', 'Caicedo Rojas', '2023-02-01', 1900000.0, 'Electricidad', 'junior'),
  (104, 'Luis', 'Fajardo Gil', '2020-10-10', 2400000.0, 'Motor', 'senior'),
  (105, 'Kevin', 'Ortiz Pardo', '2025-08-01', 1750000.0, 'Latoneria', 'junior');

-- ASESOR (2)
INSERT INTO ASESOR (id_empleado, nombres, apellidos, fecha_ingreso, salario, extension, meta_mensual) VALUES
  (201, 'Diana', 'Herrera Leal', '2016-05-20', 2900000.0, '201', 45000000.0),
  (202, 'Camilo', 'Rios Sanchez', '2022-01-10', 2300000.0, '202', 35000000.0);

-- SUPERVISION (4)
INSERT INTO SUPERVISION (id_mecanico, id_supervisor) VALUES
  (102, 101),
  (103, 102),
  (104, 101),
  (105, 104);

-- ORDEN (6)
INSERT INTO ORDEN (numero, fecha_ingreso, fecha_entrega, kilometraje, estado, placa, id_asesor) VALUES
  (1001, '2026-09-03', '2026-09-04', 85400, 'entregada', 'ABC123', 201),
  (1002, '2026-09-18', '2026-09-22', 112300, 'entregada', 'DEF456', 201),
  (1003, '2026-10-06', '2026-10-07', 30500, 'entregada', 'GHI789', 202),
  (1004, '2026-10-27', '2026-10-30', 64200, 'entregada', 'JKL012', 202),
  (1005, '2026-11-09', NULL, 41800, 'en proceso', 'MNO345', 201),
  (1006, '2026-11-14', NULL, 86900, 'recibida', 'ABC123', 202);

-- TRABAJO (8)
INSERT INTO TRABAJO (numero_orden, id_mecanico, horas, labor) VALUES
  (1001, 104, 1.5, 'Cambio de aceite y filtro'),
  (1002, 102, 3.0, 'Cambio de pastillas'),
  (1002, 105, 2.0, 'Ajuste de puerta'),
  (1003, 103, 2.5, 'Revision sistema electrico'),
  (1004, 102, 4.0, 'Cambio de amortiguadores'),
  (1004, 101, 1.0, 'Diagnostico de motor'),
  (1005, 103, 1.5, 'Cambio de bateria'),
  (1005, 104, 2.0, 'Sincronizacion');

-- REPUESTO (7)
INSERT INTO REPUESTO (codigo, nombre, precio_lista, stock) VALUES
  ('R-ACE-01', 'Aceite 10W40 (litro)', 38000.0, 40),
  ('R-FIL-02', 'Filtro de aceite', 25000.0, 15),
  ('R-PAS-03', 'Pastillas de freno', 145000.0, 6),
  ('R-BAT-04', 'Bateria 12V', 420000.0, 3),
  ('R-BUJ-05', 'Bujia', 18000.0, 24),
  ('R-AMO-06', 'Amortiguador trasero', 260000.0, 4),
  ('R-LIQ-07', 'Liquido de frenos', 22000.0, 10);

-- REPUESTO_ORDEN (6)
INSERT INTO REPUESTO_ORDEN (numero_orden, codigo_repuesto, cantidad, valor_unitario) VALUES
  (1001, 'R-ACE-01', 4, 36000.0),
  (1001, 'R-FIL-02', 1, 25000.0),
  (1002, 'R-PAS-03', 1, 145000.0),
  (1004, 'R-AMO-06', 2, 260000.0),
  (1005, 'R-BAT-04', 1, 420000.0),
  (1005, 'R-BUJ-05', 4, 18000.0);

COMMIT;
