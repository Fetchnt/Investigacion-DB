-- =====================================================================
--  Festival de música · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Escenarios con su aforo y el aforo de seguridad (80 %).
SELECT codigo, nombre, aforo, aforo * 0.8 AS aforo_seguro
FROM ESCENARIO;

-- 2. Países de donde vienen los artistas.
SELECT DISTINCT pais
FROM ARTISTA
ORDER BY pais;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Programación de la jornada 2 en orden de hora.
SELECT id_artista, codigo_escenario, hora_inicio, duracion_min
FROM PRESENTACION
WHERE numero_jornada = 2
ORDER BY hora_inicio;

-- 4. Artistas cuyo nombre artístico tiene más de una palabra.
SELECT nombre_artistico, pais
FROM ARTISTA
WHERE nombre_artistico LIKE '% %'
ORDER BY nombre_artistico;

-- 5. Boletas compradas entre octubre y noviembre que no son abonos.
SELECT codigo, tipo, fecha_compra
FROM BOLETA
WHERE fecha_compra BETWEEN '2026-10-01' AND '2026-11-30'
  AND tipo <> 'abono'
ORDER BY fecha_compra;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Edad de cada asistente al día de hoy (atributo derivado).
SELECT nombre, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM ASISTENTE
ORDER BY edad;

-- 7. Hora en que termina cada show y su duración en horas.
SELECT id_artista, numero_jornada, hora_inicio,
       ADDTIME(hora_inicio, SEC_TO_TIME(duracion_min * 60)) AS hora_fin,
       ROUND(duracion_min / 60, 1) AS horas
FROM PRESENTACION
WHERE numero_jornada = 3
ORDER BY hora_inicio;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Jornadas con la fecha en formato día/mes y el horario como texto corto.
SELECT numero, DATE_FORMAT(fecha, '%d/%m') AS dia,
       CONCAT(TIME_FORMAT(hora_apertura, '%H:%i'), ' a ', TIME_FORMAT(hora_cierre, '%H:%i')) AS horario
FROM JORNADA;

-- 9. Boletas con el nombre comercial de su tipo.
SELECT codigo,
       CASE tipo WHEN 'abono' THEN 'Pasaporte 3 dias'
                 WHEN 'vip' THEN 'Zona preferencial'
                 ELSE 'Entrada general' END AS producto,
       precio
FROM BOLETA
ORDER BY codigo;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Boletas vendidas y recaudo por tipo.
SELECT tipo, COUNT(*) AS boletas, SUM(precio) AS recaudo
FROM BOLETA
GROUP BY tipo
ORDER BY recaudo DESC;

-- 11. Minutos de música por jornada, solo las que pasan de 4 horas.
SELECT numero_jornada, COUNT(*) AS shows, SUM(duracion_min) AS minutos
FROM PRESENTACION
GROUP BY numero_jornada
HAVING SUM(duracion_min) > 240
ORDER BY numero_jornada;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Cartel completo: jornada, escenario y artista (join sobre la tabla de la ternaria).
SELECT j.fecha, e.nombre AS escenario, p.hora_inicio, a.nombre_artistico
FROM PRESENTACION p
JOIN JORNADA j ON j.numero = p.numero_jornada
JOIN ESCENARIO e ON e.codigo = p.codigo_escenario
JOIN ARTISTA a ON a.id_artista = p.id_artista
ORDER BY j.fecha, p.hora_inicio;

-- 13. Solistas con su instrumento (NATURAL JOIN: la única columna común es id_artista).
SELECT nombre_artistico, nombre_real, instrumento
FROM ARTISTA
NATURAL JOIN SOLISTA
ORDER BY nombre_artistico;

-- 14. Cada artista con sus géneros en una sola celda.
SELECT a.nombre_artistico,
       GROUP_CONCAT(g.genero ORDER BY g.genero SEPARATOR ', ') AS generos
FROM ARTISTA a
LEFT JOIN ART_GENERO g ON g.id_artista = a.id_artista
GROUP BY a.id_artista, a.nombre_artistico
ORDER BY a.nombre_artistico;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 15. Artistas que se presentan en más de una jornada.
SELECT nombre_artistico
FROM ARTISTA
WHERE id_artista IN (SELECT id_artista
                     FROM PRESENTACION
                     GROUP BY id_artista
                     HAVING COUNT(*) > 1)
ORDER BY nombre_artistico;

-- 16. Shows más largos que el promedio del festival.
SELECT id_artista, numero_jornada, duracion_min
FROM PRESENTACION
WHERE duracion_min > (SELECT AVG(duracion_min) FROM PRESENTACION)
ORDER BY duracion_min DESC;

-- 17. Asistentes que tienen al menos un abono.
SELECT a.nombre
FROM ASISTENTE a
WHERE EXISTS (SELECT 1 FROM BOLETA b
              WHERE b.documento_asistente = a.documento AND b.tipo = 'abono');

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 18. Artistas que tocan el primer día y también el último.
SELECT id_artista FROM PRESENTACION WHERE numero_jornada = 1
INTERSECT
SELECT id_artista FROM PRESENTACION WHERE numero_jornada = 3;

-- 19. Artistas que nunca han estado en el escenario principal.
SELECT id_artista FROM ARTISTA
EXCEPT
SELECT id_artista FROM PRESENTACION WHERE codigo_escenario = 'PRI';

-- 20. Ingresos esperados en la jornada 1 y en la 3, sin quitar repetidos (UNION ALL).
SELECT b.documento_asistente, bj.numero_jornada
FROM BOLETA b JOIN BOLETA_JORNADA bj ON bj.codigo_boleta = b.codigo
WHERE bj.numero_jornada = 1
UNION ALL
SELECT b.documento_asistente, bj.numero_jornada
FROM BOLETA b JOIN BOLETA_JORNADA bj ON bj.codigo_boleta = b.codigo
WHERE bj.numero_jornada = 3
ORDER BY numero_jornada, documento_asistente;
