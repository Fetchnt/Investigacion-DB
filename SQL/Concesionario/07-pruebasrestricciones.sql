-- =====================================================================
--  Concesionario de vehículos · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

START TRANSACTION;

-- 1. Vender dos veces el mismo vehículo
--    Error esperado: 1062 (viola uq_venta_vin)
INSERT INTO VENTA VALUES ('FV-2026-099', '2026-11-10', 100000000, 'contado', '79888777', 2, '9BWZZZ377VT004251');

-- 2. Venta a un cliente que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO VENTA VALUES ('FV-2026-098', '2026-11-10', 120000000, 'contado', '000', 2, 'JTDKARFP3N3012345');

-- 3. Placa repetida
--    Error esperado: 1062 (viola uq_vehiculo_usado_placa)
UPDATE VEHICULO_USADO SET placa = 'JKL123' WHERE vin = '8AJBA3CD7K1234567';

-- 4. Borrar una sede que tiene vehículos
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM SEDE WHERE id_sede = 2;

-- 5. Vehículo de 1985
--    Error esperado: 3819 (viola chk_vehiculo_anio)
INSERT INTO VEHICULO VALUES ('1HGCM82633A004352', 'Ford', 'Sierra', 1985, 'Gris', 9000000, 1);

-- 6. Forma de pago inválida
--    Error esperado: 3819 (viola chk_venta_forma_pago)
INSERT INTO VENTA VALUES ('FV-2026-097', '2026-11-10', 120000000, 'trueque', '79888777', 2, 'JTDKARFP3N3012345');

-- 7. El mismo accesorio dos veces en un vehículo
--    Error esperado: 1062 (llave duplicada)
INSERT INTO VEH_ACCESORIO VALUES ('9BWZZZ377VT004251', 2);

-- 8. Kilometraje negativo
--    Error esperado: 3819 (viola chk_usado_km)
UPDATE VEHICULO_USADO SET kilometraje = -10 WHERE vin = '93YRBB003LJ512345';

-- 9. VIN de 16 caracteres
--    Error esperado: 3819 (viola chk_vehiculo_vin)
INSERT INTO VEHICULO VALUES ('1HGCM82633A00435', 'Honda', 'Civic', 2020, 'Gris', 70000000, 1);

ROLLBACK;
