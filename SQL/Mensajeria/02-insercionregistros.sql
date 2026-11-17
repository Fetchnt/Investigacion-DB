-- =====================================================================
--  Empresa de mensajería · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

START TRANSACTION;

-- SEDE (3)
INSERT INTO SEDE (id_sede, ciudad, direccion, telefono) VALUES
  (1, 'Bogota', 'Cll 13 # 65-40', '6014440001'),
  (2, 'Medellin', 'Cra 50 # 30-15', '6044440002'),
  (3, 'Cali', 'Av 3N # 25-60', '6024440003');

-- MENSAJERO (5)
INSERT INTO MENSAJERO (id_mensajero, nombre, licencia, vehiculo, id_sede) VALUES
  (1, 'Oscar Prada', 'LC-1001', 'moto', 1),
  (2, 'Yeimy Cardona', 'LC-1002', 'furgon', 1),
  (3, 'Andres Tobon', 'LC-2001', 'moto', 2),
  (4, 'Ximena Lozano', 'LC-3001', 'bicicleta', 3),
  (5, 'Felipe Ibarra', 'LC-1003', 'bicicleta', 1);

-- CLIENTE (4)
INSERT INTO CLIENTE (nit, razon_social, telefono, correo) VALUES
  ('900111222-3', 'Libreria El Saber SAS', '6013332211', 'ventas@elsaber.co'),
  ('900333444-5', 'Tienda Natural Ltda', '6045556677', NULL),
  ('800555666-7', 'Notaria 12 de Bogota', '6017778899', 'notaria12@mail.co'),
  ('901777888-9', 'Moda Express SAS', '6028889900', 'envios@modaexpress.co');

-- ENVIO (7)
INSERT INTO ENVIO (guia, fecha_recepcion, peso_kg, valor_declarado, costo, destinatario, direccion_destino, ciudad_destino, nit_cliente, id_sede_origen) VALUES
  ('GU-000101', '2026-11-02', 2.5, 150000.0, 18000.0, 'Carlos Mesa', 'Cra 45 # 10-20', 'Medellin', '900111222-3', 1),
  ('GU-000102', '2026-11-02', 0.2, 0.0, 9000.0, 'Juzgado 3 Civil', 'Cll 12 # 7-30', 'Bogota', '800555666-7', 1),
  ('GU-000103', '2026-11-03', 12.0, 800000.0, 45000.0, 'Almacen Centro', 'Cll 8 # 4-15', 'Cali', '900333444-5', 2),
  ('GU-000104', '2026-11-05', 1.1, 90000.0, 12000.0, 'Laura Rincon', 'Av 6N # 23-50', 'Cali', '901777888-9', 3),
  ('GU-000105', '2026-11-09', 0.3, 0.0, 9500.0, 'Banco Agrario', 'Cra 8 # 15-40', 'Bogota', '900111222-3', 1),
  ('GU-000106', '2026-11-12', 5.75, 320000.0, 26000.0, 'Mario Velez', 'Cll 33 # 70-10', 'Medellin', '900111222-3', 1),
  ('GU-000107', '2026-11-15', 3.2, 210000.0, 20000.0, 'Paula Gil', 'Cra 100 # 11-90', 'Cali', '901777888-9', 3);

-- PAQUETE (5)
INSERT INTO PAQUETE (guia, alto_cm, ancho_cm, largo_cm, fragil) VALUES
  ('GU-000101', 30, 20, 15, 0),
  ('GU-000103', 60, 40, 40, 1),
  ('GU-000104', 25, 25, 10, 0),
  ('GU-000106', 50, 30, 30, 1),
  ('GU-000107', 40, 30, 20, 0);

-- DOCUMENTO (2)
INSERT INTO DOCUMENTO (guia, num_folios, certificado) VALUES
  ('GU-000102', 12, 1),
  ('GU-000105', 3, 0);

-- ASIGNACION (6)
INSERT INTO ASIGNACION (guia, id_mensajero, fecha_asignacion) VALUES
  ('GU-000101', 1, '2026-11-02'),
  ('GU-000102', 1, '2026-11-02'),
  ('GU-000103', 3, '2026-11-03'),
  ('GU-000104', 4, '2026-11-05'),
  ('GU-000105', 2, '2026-11-09'),
  ('GU-000106', 2, '2026-11-12');

-- SEGUIMIENTO (16)
INSERT INTO SEGUIMIENTO (guia, consecutivo, fecha_hora, estado, observacion) VALUES
  ('GU-000101', 1, '2026-11-02 09:15:00', 'recibido', NULL),
  ('GU-000101', 2, '2026-11-02 18:40:00', 'en transito', 'Sale en linea a Medellin'),
  ('GU-000101', 3, '2026-11-04 11:05:00', 'entregado', 'Recibe portero'),
  ('GU-000102', 1, '2026-11-02 10:00:00', 'recibido', NULL),
  ('GU-000102', 2, '2026-11-02 15:30:00', 'entregado', 'Sello de recibido'),
  ('GU-000103', 1, '2026-11-03 08:30:00', 'recibido', NULL),
  ('GU-000103', 2, '2026-11-03 20:00:00', 'en transito', NULL),
  ('GU-000103', 3, '2026-11-05 09:45:00', 'novedad', 'Direccion incompleta'),
  ('GU-000103', 4, '2026-11-06 14:20:00', 'entregado', NULL),
  ('GU-000104', 1, '2026-11-05 12:10:00', 'recibido', NULL),
  ('GU-000104', 2, '2026-11-05 16:00:00', 'entregado', NULL),
  ('GU-000105', 1, '2026-11-09 08:00:00', 'recibido', NULL),
  ('GU-000105', 2, '2026-11-09 13:15:00', 'en reparto', NULL),
  ('GU-000106', 1, '2026-11-12 10:30:00', 'recibido', NULL),
  ('GU-000106', 2, '2026-11-12 19:00:00', 'en transito', NULL),
  ('GU-000107', 1, '2026-11-15 11:00:00', 'recibido', NULL);

COMMIT;
