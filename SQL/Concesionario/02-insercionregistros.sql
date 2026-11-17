-- =====================================================================
--  Concesionario de vehículos · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

START TRANSACTION;

-- SEDE (3)
INSERT INTO SEDE (id_sede, nombre, ciudad, direccion) VALUES
  (1, 'Autos del Norte Calle 127', 'Bogota', 'Autopista Norte # 127-30'),
  (2, 'Autos del Norte Chapinero', 'Bogota', 'Cra 13 # 60-12'),
  (3, 'Autos del Norte Poblado', 'Medellin', 'Av El Poblado # 5-40');

-- VENDEDOR (4)
INSERT INTO VENDEDOR (id_vendedor, nombre, porcentaje_comision, fecha_ingreso, id_sede) VALUES
  (1, 'Paula Andrea Rincon', 2.5, '2019-02-11', 1),
  (2, 'Hernan Quintero', 2.0, '2022-06-01', 1),
  (3, 'Sara Villegas', 3.0, '2017-09-18', 2),
  (4, 'Mauricio Ospina', 2.5, '2024-01-15', 3);

-- CLIENTE (5)
INSERT INTO CLIENTE (documento, nombres, apellidos, telefono, correo) VALUES
  ('1032456789', 'Daniela', 'Arango Silva', '3105551234', 'darango@mail.com'),
  ('79888777', 'Ricardo', 'Nunez Prieto', '3006667788', NULL),
  ('1144556677', 'Juliana', 'Restrepo Gil', '3157778899', 'jrestrepo@mail.com'),
  ('43555666', 'Gloria', 'Bedoya Mesa', '3012223344', 'gbedoya@mail.com'),
  ('1020304050', 'Mateo', 'Cardenas Ruiz', '3194445566', 'mcardenas@mail.com');

-- VEHICULO (8)
INSERT INTO VEHICULO (vin, marca, modelo, anio, color, precio_lista, id_sede) VALUES
  ('9BWZZZ377VT004251', 'Volkswagen', 'T-Cross', 2026, 'Blanco', 112000000.0, 1),
  ('3MZBPACL5RM100234', 'Mazda', 'CX-30', 2026, 'Rojo', 135000000.0, 1),
  ('JTDKARFP3N3012345', 'Toyota', 'Corolla Cross', 2025, 'Gris', 128000000.0, 2),
  ('93YRBB003LJ512345', 'Renault', 'Duster', 2020, 'Negro', 58000000.0, 1),
  ('8AJBA3CD7K1234567', 'Chevrolet', 'Onix', 2019, 'Plata', 46000000.0, 3),
  ('9FBHS4AD5PM778899', 'Kia', 'Picanto', 2023, 'Azul', 52000000.0, 2),
  ('KMHJ3814GKU445566', 'Hyundai', 'Tucson', 2026, 'Negro', 158000000.0, 3),
  ('MALA841CBNM334455', 'Hyundai', 'Accent', 2022, 'Blanco', 61000000.0, 2);

-- VEHICULO_NUEVO (4)
INSERT INTO VEHICULO_NUEVO (vin, garantia_meses) VALUES
  ('9BWZZZ377VT004251', 36),
  ('3MZBPACL5RM100234', 36),
  ('JTDKARFP3N3012345', 60),
  ('KMHJ3814GKU445566', 60);

-- VEHICULO_USADO (4)
INSERT INTO VEHICULO_USADO (vin, kilometraje, placa, num_propietarios) VALUES
  ('93YRBB003LJ512345', 68500, 'JKL123', 2),
  ('8AJBA3CD7K1234567', 92000, 'MNO456', 3),
  ('9FBHS4AD5PM778899', 21000, 'PQR789', 1),
  ('MALA841CBNM334455', 45000, 'STU234', 1);

-- ACCESORIO (6)
INSERT INTO ACCESORIO (id_accesorio, nombre) VALUES
  (1, 'Sunroof'),
  (2, 'Sensores de parqueo'),
  (3, 'Camara de reversa'),
  (4, 'Rines de lujo'),
  (5, 'Pantalla tactil'),
  (6, 'Gancho de remolque');

-- VEH_ACCESORIO (17)
INSERT INTO VEH_ACCESORIO (vin, id_accesorio) VALUES
  ('9BWZZZ377VT004251', 2),
  ('9BWZZZ377VT004251', 3),
  ('9BWZZZ377VT004251', 5),
  ('3MZBPACL5RM100234', 1),
  ('3MZBPACL5RM100234', 2),
  ('3MZBPACL5RM100234', 3),
  ('3MZBPACL5RM100234', 5),
  ('JTDKARFP3N3012345', 3),
  ('JTDKARFP3N3012345', 5),
  ('93YRBB003LJ512345', 2),
  ('9FBHS4AD5PM778899', 5),
  ('KMHJ3814GKU445566', 1),
  ('KMHJ3814GKU445566', 2),
  ('KMHJ3814GKU445566', 3),
  ('KMHJ3814GKU445566', 4),
  ('KMHJ3814GKU445566', 5),
  ('MALA841CBNM334455', 3);

-- VENTA (6)
INSERT INTO VENTA (numero_factura, fecha, valor_final, forma_pago, documento_cliente, id_vendedor, vin) VALUES
  ('FV-2026-001', '2026-07-14', 109500000.0, 'credito', '1032456789', 1, '9BWZZZ377VT004251'),
  ('FV-2026-002', '2026-08-02', 56000000.0, 'contado', '79888777', 2, '93YRBB003LJ512345'),
  ('FV-2026-003', '2026-08-25', 44500000.0, 'contado', '1144556677', 4, '8AJBA3CD7K1234567'),
  ('FV-2026-004', '2026-09-30', 133000000.0, 'leasing', '43555666', 1, '3MZBPACL5RM100234'),
  ('FV-2026-005', '2026-10-18', 155000000.0, 'credito', '1020304050', 4, 'KMHJ3814GKU445566'),
  ('FV-2026-006', '2026-11-05', 50500000.0, 'credito', '1032456789', 3, '9FBHS4AD5PM778899');

COMMIT;
