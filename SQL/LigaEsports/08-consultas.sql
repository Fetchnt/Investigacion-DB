-- =====================================================================
--  Liga de e-sports · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Torneos con el premio total y lo que se lleva el campeón (60 %).
SELECT nombre, premio, premio * 0.6 AS premio_campeon
FROM TORNEO;

-- 2. Roles que hay en la liga.
SELECT DISTINCT rol
FROM JUGADOR
ORDER BY rol;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Partidas de más de 40 minutos, de la más larga a la más corta.
SELECT id_partida, fecha, ronda, duracion_min
FROM PARTIDA
WHERE duracion_min > 40
ORDER BY duracion_min DESC;

-- 4. Partidas de semifinal o final del torneo 2.
SELECT id_partida, ronda, fecha
FROM PARTIDA
WHERE id_torneo = 2 AND ronda IN ('semifinal', 'final')
ORDER BY fecha;

-- 5. Jugadores cuyo nickname empieza por K o termina en o.
SELECT nickname, nombres, apellidos
FROM JUGADOR
WHERE nickname LIKE 'K%' OR nickname LIKE '%o'
ORDER BY nickname;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Edad de cada jugador (atributo derivado).
SELECT nickname, fecha_nacimiento, TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM JUGADOR
ORDER BY edad, nickname;

-- 7. KDA de cada jugador en cada partida (atributo derivado de la relación).
SELECT id_jugador, id_partida, kills, muertes, asistencias,
       ROUND((kills + asistencias) / GREATEST(muertes, 1), 2) AS kda
FROM ESTADISTICA
ORDER BY kda DESC, id_jugador
LIMIT 8;

-- 8. Antigüedad de cada equipo en años.
SELECT nombre, fecha_fundacion, TIMESTAMPDIFF(YEAR, fecha_fundacion, CURDATE()) AS antiguedad
FROM EQUIPO
ORDER BY antiguedad DESC;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 9. Nombre de presentación del jugador: nombre, nickname entre comillas y apellido.
SELECT CONCAT(nombres, ' "', nickname, '" ', apellidos) AS presentacion, UPPER(rol) AS rol
FROM JUGADOR
ORDER BY id_equipo, nickname;

-- 10. Resultado de cada partida en texto.
SELECT id_partida, DATE_FORMAT(fecha, '%d/%m') AS dia,
       CASE WHEN puntos_local > puntos_visitante THEN 'gana local' ELSE 'gana visitante' END AS resultado
FROM PARTIDA
ORDER BY id_partida;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 11. Totales por jugador, solo los que suman más de 10 kills.
SELECT id_jugador, COUNT(*) AS partidas, SUM(kills) AS kills, SUM(muertes) AS muertes, SUM(asistencias) AS asistencias
FROM ESTADISTICA
GROUP BY id_jugador
HAVING SUM(kills) > 10
ORDER BY kills DESC;

-- 12. Partidas y duración promedio por torneo.
SELECT id_torneo, COUNT(*) AS partidas, ROUND(AVG(duracion_min), 1) AS duracion_promedio
FROM PARTIDA
GROUP BY id_torneo;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 13. Cada partida con el nombre del local y del visitante (EQUIPO se une dos veces, una por rol).
SELECT p.id_partida, l.nombre AS local, v.nombre AS visitante, p.puntos_local, p.puntos_visitante
FROM PARTIDA p
JOIN EQUIPO l ON l.id_equipo = p.id_equipo_local
JOIN EQUIPO v ON v.id_equipo = p.id_equipo_visitante
ORDER BY p.id_partida;

-- 14. Inscripciones con el equipo, que se recupera a través del entrenador (consecuencia de FNBC).
SELECT i.id_torneo, q.nombre AS equipo, e.nombres AS entrenador, i.fecha_inscripcion
FROM INSCRIPCION i
JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador
JOIN EQUIPO q ON q.id_equipo = e.id_equipo
ORDER BY i.id_torneo, q.nombre;

-- 15. Todos los torneos con su número de inscritos, incluso el que aún no tiene.
SELECT t.nombre, COUNT(i.id_entrenador) AS inscritos
FROM TORNEO t
LEFT JOIN INSCRIPCION i ON i.id_torneo = t.id_torneo
GROUP BY t.id_torneo, t.nombre
ORDER BY inscritos DESC;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 16. Jugadores con más kills totales que el promedio de kills por jugador.
SELECT id_jugador, SUM(kills) AS kills
FROM ESTADISTICA
GROUP BY id_jugador
HAVING SUM(kills) > (SELECT AVG(total) FROM (SELECT SUM(kills) AS total
                                              FROM ESTADISTICA
                                              GROUP BY id_jugador) x)
ORDER BY kills DESC;

-- 17. El jugador con más kills en cada partida (correlacionada).
SELECT s.id_partida, s.id_jugador, s.kills
FROM ESTADISTICA s
WHERE s.kills = (SELECT MAX(x.kills) FROM ESTADISTICA x WHERE x.id_partida = s.id_partida)
ORDER BY s.id_partida;

-- 18. Equipos que nunca han ganado una partida.
SELECT nombre
FROM EQUIPO
WHERE id_equipo NOT IN (SELECT CASE WHEN puntos_local > puntos_visitante
                                  THEN id_equipo_local ELSE id_equipo_visitante END
                       FROM PARTIDA);

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 19. Plantilla completa de Cóndores: jugadores y entrenadores (UNION ALL reconstruye MIEMBRO).
SELECT id_miembro, nombres, apellidos, 'jugador' AS tipo FROM JUGADOR WHERE id_equipo = 1
UNION ALL
SELECT id_miembro, nombres, apellidos, 'entrenador' FROM ENTRENADOR WHERE id_equipo = 1
ORDER BY tipo, id_miembro;

-- 20. Equipos que jugaron los dos torneos (como local o visitante). La unión va en una tabla derivada porque INTERSECT se evalúa antes que UNION.
SELECT id_equipo
FROM (SELECT id_equipo_local AS id_equipo FROM PARTIDA WHERE id_torneo = 1
      UNION
      SELECT id_equipo_visitante FROM PARTIDA WHERE id_torneo = 1) AS copa
INTERSECT
SELECT id_equipo_local FROM PARTIDA WHERE id_torneo = 2
ORDER BY id_equipo;

-- 21. Equipos inscritos en la Liga Latina que no estuvieron en la Copa Andina.
SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = 2
EXCEPT
SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = 1;
