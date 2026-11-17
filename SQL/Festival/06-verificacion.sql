-- =====================================================================
--  Festival de música · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

-- 1. Tablas y motor (deben ser 10 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'festival' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'ESCENARIO' AS tabla, COUNT(*) AS filas FROM ESCENARIO
UNION ALL SELECT 'ARTISTA' AS tabla, COUNT(*) AS filas FROM ARTISTA
UNION ALL SELECT 'ART_GENERO' AS tabla, COUNT(*) AS filas FROM ART_GENERO
UNION ALL SELECT 'SOLISTA' AS tabla, COUNT(*) AS filas FROM SOLISTA
UNION ALL SELECT 'AGRUPACION' AS tabla, COUNT(*) AS filas FROM AGRUPACION
UNION ALL SELECT 'JORNADA' AS tabla, COUNT(*) AS filas FROM JORNADA
UNION ALL SELECT 'PRESENTACION' AS tabla, COUNT(*) AS filas FROM PRESENTACION
UNION ALL SELECT 'ASISTENTE' AS tabla, COUNT(*) AS filas FROM ASISTENTE
UNION ALL SELECT 'BOLETA' AS tabla, COUNT(*) AS filas FROM BOLETA
UNION ALL SELECT 'BOLETA_JORNADA' AS tabla, COUNT(*) AS filas FROM BOLETA_JORNADA;

-- 3. Jerarquía disjunta: nadie es solista y agrupación (no debe devolver filas)
SELECT s.id_artista FROM SOLISTA s JOIN AGRUPACION g ON g.id_artista = s.id_artista;

-- 4. Jerarquía total: todo artista es solista o agrupación (no debe devolver filas)
SELECT a.id_artista FROM ARTISTA a WHERE a.id_artista NOT IN (SELECT id_artista FROM SOLISTA) AND a.id_artista NOT IN (SELECT id_artista FROM AGRUPACION);

-- 5. Los shows empiezan dentro del horario de su jornada (no debe devolver filas)
SELECT p.id_artista, p.numero_jornada FROM PRESENTACION p JOIN JORNADA j ON j.numero = p.numero_jornada WHERE p.hora_inicio < j.hora_apertura OR p.hora_inicio > j.hora_cierre;

-- 6. El abono vale para todas las jornadas (no debe devolver filas)
SELECT b.codigo FROM BOLETA b WHERE b.tipo = 'abono' AND (SELECT COUNT(*) FROM BOLETA_JORNADA x WHERE x.codigo_boleta = b.codigo) <> (SELECT COUNT(*) FROM JORNADA);

-- 7. General y VIP valen para una sola jornada (no debe devolver filas)
SELECT b.codigo FROM BOLETA b WHERE b.tipo <> 'abono' AND (SELECT COUNT(*) FROM BOLETA_JORNADA x WHERE x.codigo_boleta = b.codigo) <> 1;
