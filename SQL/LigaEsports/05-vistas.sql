-- =====================================================================
--  Liga de e-sports · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

-- Cada partida con los nombres de los equipos y el ganador (atributo derivado).
CREATE OR REPLACE VIEW v_resultados AS
SELECT p.id_partida, t.nombre AS torneo, p.ronda, l.nombre AS local, v.nombre AS visitante,
       CASE WHEN p.puntos_local > p.puntos_visitante THEN l.nombre ELSE v.nombre END AS ganador
FROM PARTIDA p
JOIN TORNEO t ON t.id_torneo = p.id_torneo
JOIN EQUIPO l ON l.id_equipo = p.id_equipo_local
JOIN EQUIPO v ON v.id_equipo = p.id_equipo_visitante;

-- Equipos inscritos por torneo: el equipo se recupera a través del entrenador.
CREATE OR REPLACE VIEW v_inscritos AS
SELECT t.nombre AS torneo, q.nombre AS equipo, CONCAT(e.nombres, ' ', e.apellidos) AS entrenador, i.fecha_inscripcion
FROM INSCRIPCION i
JOIN TORNEO t ON t.id_torneo = i.id_torneo
JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador
JOIN EQUIPO q ON q.id_equipo = e.id_equipo;
