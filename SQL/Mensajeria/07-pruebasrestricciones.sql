-- =====================================================================
--  Empresa de mensajería · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

START TRANSACTION;

-- 1. Repetir el consecutivo de un evento
--    Error esperado: 1062 (llave duplicada)
INSERT INTO SEGUIMIENTO VALUES ('GU-000107', 1, '2026-11-15 12:00:00', 'en transito', NULL);

-- 2. Seguimiento de una guía que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO SEGUIMIENTO VALUES ('GU-999999', 1, '2026-11-15 12:00:00', 'recibido', NULL);

-- 3. Asignar un segundo mensajero a la misma guía
--    Error esperado: 1062 (llave duplicada: máximo un mensajero)
INSERT INTO ASIGNACION VALUES ('GU-000101', 3, '2026-11-03');

-- 4. Estado que no existe
--    Error esperado: 3819 (viola chk_seguimiento_estado)
UPDATE SEGUIMIENTO SET estado = 'perdido' WHERE guia = 'GU-000107' AND consecutivo = 1;

-- 5. Borrar una sede que tiene envíos
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM SEDE WHERE id_sede = 3;

-- 6. Envío que no pesa nada
--    Error esperado: 3819 (viola chk_envio_peso)
UPDATE ENVIO SET peso_kg = 0 WHERE guia = 'GU-000102';

-- 7. Licencia repetida
--    Error esperado: 1062 (llave duplicada)
INSERT INTO MENSAJERO VALUES (6, 'Otro', 'LC-1001', 'moto', 2);

-- 8. Vehículo que no está en la flota
--    Error esperado: 3819 (viola chk_mensajero_vehiculo)
UPDATE MENSAJERO SET vehiculo = 'avion' WHERE id_mensajero = 5;

ROLLBACK;
