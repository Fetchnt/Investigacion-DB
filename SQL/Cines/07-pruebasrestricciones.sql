-- =====================================================================
--  Cadena de cines · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

START TRANSACTION;

-- 1. Vender una silla que ya está vendida
--    Error esperado: 1062 (llave duplicada)
INSERT INTO TIQUETE VALUES (1, 'F', 7, '1001234321', 14000);

-- 2. Función en una sala que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO FUNCION VALUES (99, '2026-11-20', '18:00:00', 15000, 'doblada', 42, 1);

-- 3. Dos funciones a la misma hora en la misma sala
--    Error esperado: 1062 (viola uq_funcion_id_sala_fecha_hora)
INSERT INTO FUNCION VALUES (98, '2026-11-13', '16:00:00', 15000, 'doblada', 1, 2);

-- 4. Sala regular con gafas 3D
--    Error esperado: 3819 (viola chk_sala_subtipo)
UPDATE SALA SET gafas_disponibles = 50 WHERE id_sala = 1;

-- 5. Clasificación inexistente
--    Error esperado: 3819 (viola chk_pelicula_clasificacion)
UPDATE PELICULA SET clasificacion = 'X' WHERE id_pelicula = 1;

-- 6. Borrar una película que tiene funciones
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM PELICULA WHERE id_pelicula = 2;

-- 7. Fila escrita con un número
--    Error esperado: 3819 (viola chk_tiquete_fila)
INSERT INTO TIQUETE VALUES (2, '7', 1, '1001234321', 16000);

-- 8. Número de sala repetido en el mismo cine
--    Error esperado: 1062 (viola uq_sala_id_cine_numero)
INSERT INTO SALA VALUES (8, 1, 100, 1, 'regular', NULL, NULL);

ROLLBACK;
