-- =====================================================================
--  Liga de e-sports · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

START TRANSACTION;

-- 1. Un equipo contra sí mismo
--    Error esperado: 3819 (viola chk_partida_rivales)
INSERT INTO PARTIDA VALUES (99, '2026-10-30', 'grupos', 30, 1, 0, 2, 3, 3);

-- 2. Cargar dos veces la estadística de un jugador en la misma partida
--    Error esperado: 1062 (llave duplicada)
INSERT INTO ESTADISTICA VALUES (101, 1, 1, 1, 1);

-- 3. Rol que no existe en el juego
--    Error esperado: 3819 (viola chk_jugador_rol)
UPDATE JUGADOR SET rol = 'arquero' WHERE id_miembro = 101;

-- 4. Inscripción de un entrenador que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO INSCRIPCION VALUES (3, 999, '2026-11-20');

-- 5. Borrar un equipo con jugadores
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM EQUIPO WHERE id_equipo = 3;

-- 6. Nickname repetido
--    Error esperado: 1062 (llave duplicada)
INSERT INTO JUGADOR VALUES (110, 'Kevin', 'Diaz', '2004-04-04', 'Kmilo', 'top', 2);

-- 7. Kills negativos
--    Error esperado: 3819 (viola chk_estadistica_valores)
UPDATE ESTADISTICA SET kills = -1 WHERE id_jugador = 101 AND id_partida = 1;

-- 8. Partida empatada
--    Error esperado: 3819 (viola chk_partida_puntos)
UPDATE PARTIDA SET puntos_local = 0 WHERE id_partida = 1;

ROLLBACK;
