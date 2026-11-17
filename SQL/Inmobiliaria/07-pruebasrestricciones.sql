-- =====================================================================
--  Agencia inmobiliaria · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

START TRANSACTION;

-- 1. Dos visitas del mismo cliente al mismo inmueble el mismo día
--    Error esperado: 1062 (llave duplicada)
INSERT INTO VISITA VALUES ('1015887766', '50S-3321457', '2026-10-03', '16:00:00', 5, NULL);

-- 2. Inmueble en venta sin precio
--    Error esperado: 3819 (viola chk_inmueble_venta)
UPDATE INMUEBLE SET en_venta = 1 WHERE matricula = '370-554433';

-- 3. Inmueble de un propietario que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO INMUEBLE VALUES ('50C-0000001', 'Cll 1', '1-1', 'Centro', 'Bogota', 'local', 30, 3, 0, '000', 1, 0, NULL, NULL, 0, NULL, NULL);

-- 4. Estrato 7
--    Error esperado: 3819 (viola chk_inmueble_estrato)
UPDATE INMUEBLE SET estrato = 7 WHERE matricula = '50N-2236541';

-- 5. Borrar un agente que tiene inmuebles
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM AGENTE WHERE id_agente = 2;

-- 6. Interés fuera de escala
--    Error esperado: 3819 (viola chk_visita_interes)
UPDATE VISITA SET interes = 0 WHERE documento_cliente = '79123456' AND matricula = '50C-1458796';

-- 7. Depósito de tres cánones
--    Error esperado: 3819 (viola chk_inmueble_deposito)
UPDATE INMUEBLE SET deposito = 6900000 WHERE matricula = '50N-2236541';

-- 8. Teléfono repetido para el mismo propietario
--    Error esperado: 1062 (llave duplicada)
INSERT INTO PROP_TELEFONO VALUES ('19456789', '3105550001');

ROLLBACK;
