-- =====================================================================
--  Liga de e-sports · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

-- 1. Tablas y motor (deben ser 7 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'esports' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'EQUIPO' AS tabla, COUNT(*) AS filas FROM EQUIPO
UNION ALL SELECT 'JUGADOR' AS tabla, COUNT(*) AS filas FROM JUGADOR
UNION ALL SELECT 'ENTRENADOR' AS tabla, COUNT(*) AS filas FROM ENTRENADOR
UNION ALL SELECT 'TORNEO' AS tabla, COUNT(*) AS filas FROM TORNEO
UNION ALL SELECT 'INSCRIPCION' AS tabla, COUNT(*) AS filas FROM INSCRIPCION
UNION ALL SELECT 'PARTIDA' AS tabla, COUNT(*) AS filas FROM PARTIDA
UNION ALL SELECT 'ESTADISTICA' AS tabla, COUNT(*) AS filas FROM ESTADISTICA;

-- 3. Jerarquía disjunta: ningún código es jugador y entrenador (no debe devolver filas)
SELECT j.id_miembro FROM JUGADOR j JOIN ENTRENADOR e ON e.id_miembro = j.id_miembro;

-- 4. Dependencia que se perdió al pasar a FNBC: un equipo no inscribe dos entrenadores en el mismo torneo (no debe devolver filas)
SELECT i1.id_torneo, e1.id_equipo FROM INSCRIPCION i1 JOIN ENTRENADOR e1 ON e1.id_miembro = i1.id_entrenador JOIN INSCRIPCION i2 ON i2.id_torneo = i1.id_torneo AND i2.id_entrenador > i1.id_entrenador JOIN ENTRENADOR e2 ON e2.id_miembro = i2.id_entrenador WHERE e1.id_equipo = e2.id_equipo;

-- 5. Los dos equipos de una partida están inscritos en ese torneo (no debe devolver filas)
SELECT p.id_partida FROM PARTIDA p WHERE p.id_equipo_local NOT IN (SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = p.id_torneo) OR p.id_equipo_visitante NOT IN (SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = p.id_torneo);

-- 6. Un jugador solo tiene estadísticas en partidas de su equipo (no debe devolver filas)
SELECT s.id_jugador, s.id_partida FROM ESTADISTICA s JOIN JUGADOR j ON j.id_miembro = s.id_jugador JOIN PARTIDA p ON p.id_partida = s.id_partida WHERE j.id_equipo NOT IN (p.id_equipo_local, p.id_equipo_visitante);

-- 7. Ninguna partida es anterior al inicio de su torneo (no debe devolver filas)
SELECT p.id_partida FROM PARTIDA p JOIN TORNEO t ON t.id_torneo = p.id_torneo WHERE p.fecha < t.fecha_inicio;
