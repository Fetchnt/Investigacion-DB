-- =====================================================================
--  Agencia inmobiliaria · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

START TRANSACTION;

-- RANGO_COMISION (3)
INSERT INTO RANGO_COMISION (id_rango, valor_min, valor_max, porcentaje) VALUES
  (1, 0.0, 299999999.99, 4.0),
  (2, 300000000.0, 799999999.99, 3.0),
  (3, 800000000.0, 999999999999.99, 2.5);

-- AGENTE (4)
INSERT INTO AGENTE (id_agente, nombre, telefono) VALUES
  (1, 'Natalia Cuervo', '3201110001'),
  (2, 'Ricardo Bernal', '3201110002'),
  (3, 'Monica Salgado', '3201110003'),
  (4, 'Ivan Pedraza', '3201110004');

-- PROPIETARIO (4)
INSERT INTO PROPIETARIO (documento, nombre, correo) VALUES
  ('19456789', 'Hernando Lopez Ruiz', 'hlopez@mail.com'),
  ('52678901', 'Claudia Marin Suarez', NULL),
  ('1020456789', 'Sebastian Duque Mora', 'sduque@mail.com'),
  ('41234567', 'Beatriz Cano Rios', 'bcano@mail.com');

-- PROP_TELEFONO (6)
INSERT INTO PROP_TELEFONO (documento, telefono) VALUES
  ('19456789', '3105550001'),
  ('19456789', '6012220001'),
  ('52678901', '3115550002'),
  ('1020456789', '3125550003'),
  ('41234567', '3135550004'),
  ('41234567', '3145550005');

-- INMUEBLE (8)
INSERT INTO INMUEBLE (matricula, calle, numero, barrio, ciudad, tipo, area_m2, estrato, habitaciones, documento_propietario, id_agente, en_venta, precio_venta, acepta_permuta, en_arriendo, canon_mensual, deposito) VALUES
  ('50C-1458796', 'Cra 11', '93-45', 'Chico', 'Bogota', 'apartamento', 85.0, 6, 2, '19456789', 1, 1, 980000000.0, 0, 1, 4200000.0, 4200000.0),
  ('50N-2236541', 'Cll 147', '19-30', 'Cedritos', 'Bogota', 'apartamento', 62.5, 4, 3, '19456789', 1, 0, NULL, NULL, 1, 2300000.0, 2300000.0),
  ('50S-3321457', 'Cra 68', '12-80', 'Marsella', 'Bogota', 'casa', 140.0, 3, 4, '52678901', 2, 1, 520000000.0, 1, 0, NULL, NULL),
  ('001-998877', 'Cll 10', '43-15', 'El Poblado', 'Medellin', 'apartamento', 110.0, 6, 3, '1020456789', 3, 1, 1150000000.0, 0, 0, NULL, NULL),
  ('001-776655', 'Cra 70', '44-20', 'Laureles', 'Medellin', 'local', 48.0, 4, 0, '1020456789', 3, 0, NULL, NULL, 1, 3500000.0, 7000000.0),
  ('370-554433', 'Av 6N', '28-10', 'Granada', 'Cali', 'oficina', 75.0, 5, 0, '41234567', 2, 0, NULL, NULL, 0, NULL, NULL),
  ('370-112233', 'Cll 5', '66-40', 'Pance', 'Cali', 'casa', 260.0, 6, 5, '41234567', 2, 1, 1450000000.0, 1, 1, 6800000.0, 13600000.0),
  ('50C-2001133', 'Cll 72', '9-15', 'Chapinero', 'Bogota', 'oficina', 54.0, 4, 0, '52678901', 1, 1, 280000000.0, 0, 0, NULL, NULL);

-- CLIENTE (4)
INSERT INTO CLIENTE (documento, nombre, telefono, presupuesto) VALUES
  ('1015887766', 'Jorge Bautista', '3001112233', 600000000.0),
  ('1032998877', 'Paola Ruiz', '3002223344', 1200000000.0),
  ('79123456', 'Esteban Gil', '3003334455', 5000000.0),
  ('1144778899', 'Valeria Ochoa', '3004445566', 3000000.0);

-- VISITA (8)
INSERT INTO VISITA (documento_cliente, matricula, fecha, hora, interes, comentario) VALUES
  ('1015887766', '50S-3321457', '2026-10-03', '10:00:00', 4, 'Le gusto el patio'),
  ('1015887766', '50S-3321457', '2026-10-17', '15:30:00', 5, 'Vino con la familia'),
  ('1032998877', '50C-1458796', '2026-10-08', '11:00:00', 3, NULL),
  ('1032998877', '001-998877', '2026-10-20', '09:30:00', 5, 'Quiere negociar el precio'),
  ('79123456', '50N-2236541', '2026-10-11', '16:00:00', 4, NULL),
  ('79123456', '50C-1458796', '2026-10-25', '17:00:00', 2, 'Muy costoso'),
  ('1144778899', '001-776655', '2026-11-02', '10:30:00', 4, 'Para su negocio'),
  ('1144778899', '50N-2236541', '2026-11-06', '12:00:00', 5, NULL);

COMMIT;
