-- =====================================================================
--  Festival de música · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

-- El cartel del festival: jornada, escenario, hora y artista.
CREATE OR REPLACE VIEW v_cartel AS
SELECT j.numero AS jornada, j.fecha, e.nombre AS escenario, p.hora_inicio,
       a.nombre_artistico AS artista, p.duracion_min
FROM PRESENTACION p
JOIN JORNADA j ON j.numero = p.numero_jornada
JOIN ESCENARIO e ON e.codigo = p.codigo_escenario
JOIN ARTISTA a ON a.id_artista = p.id_artista;

-- Personas que pueden entrar cada jornada.
CREATE OR REPLACE VIEW v_ingresos_jornada AS
SELECT bj.numero_jornada, COUNT(*) AS boletas_validas
FROM BOLETA_JORNADA bj
GROUP BY bj.numero_jornada;
