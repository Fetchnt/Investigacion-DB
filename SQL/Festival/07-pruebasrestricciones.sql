-- =====================================================================
--  Festival de música · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

START TRANSACTION;

-- 1. Un artista en dos escenarios la misma jornada (lo impide la PK de la ternaria)
--    Error esperado: 1062 (llave duplicada)
INSERT INTO PRESENTACION VALUES (1, 1, 'BOS', '15:00:00', 45);

-- 2. Dos shows a la misma hora en el mismo escenario
--    Error esperado: 1062 (viola la clave candidata alternativa)
INSERT INTO PRESENTACION VALUES (6, 1, 'PRI', '21:00:00', 60);

-- 3. Presentación en una jornada que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO PRESENTACION VALUES (5, 9, 'PRI', '18:00:00', 60);

-- 4. Boleta de cortesía
--    Error esperado: 3819 (viola chk_boleta_tipo)
INSERT INTO BOLETA VALUES ('B-2000', 'cortesia', 1000, '2026-11-01', '52987654');

-- 5. Borrar un artista que ya está programado
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM ARTISTA WHERE id_artista = 1;

-- 6. Correo de asistente repetido
--    Error esperado: 1062 (llave duplicada)
INSERT INTO ASISTENTE VALUES ('123', 'Otra Persona', 'npineda@mail.com', '2000-01-01');

-- 7. Show de cinco horas
--    Error esperado: 3819 (viola chk_presentacion_duracion)
UPDATE PRESENTACION SET duracion_min = 300 WHERE id_artista = 2 AND numero_jornada = 1;

-- 8. Agrupación de un solo integrante
--    Error esperado: 3819 (viola chk_agrupacion_integrantes)
UPDATE AGRUPACION SET num_integrantes = 1 WHERE id_artista = 5;

ROLLBACK;
