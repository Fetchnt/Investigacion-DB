-- =====================================================================
--  Taller mecánico · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

START TRANSACTION;

-- 1. Un mecánico que se supervisa a sí mismo
--    Error esperado: 3819 (viola chk_supervision_distintos)
INSERT INTO SUPERVISION VALUES (101, 101);

-- 2. Darle un segundo supervisor a un mecánico
--    Error esperado: 1062 (llave duplicada: máximo un supervisor)
INSERT INTO SUPERVISION VALUES (103, 104);

-- 3. Orden para una placa que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO ORDEN VALUES (2000, '2026-11-15', NULL, 1000, 'recibida', 'ZZZ999', 201);

-- 4. Orden entregada sin fecha de entrega
--    Error esperado: 3819 (viola chk_orden_entrega)
UPDATE ORDEN SET estado = 'entregada' WHERE numero = 1006;

-- 5. Borrar un mecánico que tiene trabajos
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM MECANICO WHERE id_empleado = 104;

-- 6. Nivel que no existe
--    Error esperado: 3819 (viola chk_mecanico_nivel)
UPDATE MECANICO SET nivel = 'experto' WHERE id_empleado = 103;

-- 7. Existencias negativas
--    Error esperado: 3819 (viola chk_repuesto_stock)
UPDATE REPUESTO SET stock = -1 WHERE codigo = 'R-BAT-04';

-- 8. El mismo repuesto dos veces en una orden
--    Error esperado: 1062 (llave duplicada)
INSERT INTO REPUESTO_ORDEN VALUES (1001, 'R-ACE-01', 1, 38000);

-- 9. Asignar como asesor de la orden a un mecánico
--    Error esperado: 1452 (101 no está en ASESOR)
UPDATE ORDEN SET id_asesor = 101 WHERE numero = 1006;

ROLLBACK;
