-- =====================================================================
--  Empresa de mensajería · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

-- Último estado de cada guía (lo que ve el cliente en la página).
CREATE OR REPLACE VIEW v_rastreo AS
SELECT e.guia, e.destinatario, e.ciudad_destino, s.estado, s.fecha_hora
FROM ENVIO e
JOIN SEGUIMIENTO s ON s.guia = e.guia
WHERE s.consecutivo = (SELECT MAX(x.consecutivo) FROM SEGUIMIENTO x WHERE x.guia = e.guia);

-- Envíos asignados a cada mensajero.
CREATE OR REPLACE VIEW v_planilla_mensajero AS
SELECT m.nombre AS mensajero, a.fecha_asignacion, e.guia, e.destinatario, e.ciudad_destino
FROM ASIGNACION a
JOIN MENSAJERO m ON m.id_mensajero = a.id_mensajero
JOIN ENVIO e ON e.guia = a.guia;
