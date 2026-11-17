-- =====================================================================
--  Empresa de mensajería · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Envíos con su costo y lo que se cobra por kilo.
SELECT guia, peso_kg, costo, costo / peso_kg AS costo_por_kg
FROM ENVIO;

-- 2. Ciudades de destino.
SELECT DISTINCT ciudad_destino
FROM ENVIO
ORDER BY ciudad_destino;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Envíos de más de 2 kg que van a Cali o Medellín, del más pesado al más liviano.
SELECT guia, destinatario, ciudad_destino, peso_kg
FROM ENVIO
WHERE peso_kg > 2 AND ciudad_destino IN ('Cali', 'Medellin')
ORDER BY peso_kg DESC;

-- 4. Clientes que no tienen correo.
SELECT nit, razon_social
FROM CLIENTE
WHERE correo IS NULL;

-- 5. Eventos con alguna observación.
SELECT guia, consecutivo, estado, observacion
FROM SEGUIMIENTO
WHERE observacion IS NOT NULL
ORDER BY guia, consecutivo;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Volumen de cada paquete en metros cúbicos.
SELECT guia, alto_cm, ancho_cm, largo_cm,
       ROUND(alto_cm * ancho_cm * largo_cm / 1000000, 3) AS m3
FROM PAQUETE
ORDER BY m3 DESC;

-- 7. Días que tardó cada entrega desde la recepción.
SELECT s.guia, e.fecha_recepcion, DATE(s.fecha_hora) AS entrega,
       DATEDIFF(DATE(s.fecha_hora), e.fecha_recepcion) AS dias
FROM SEGUIMIENTO s
JOIN ENVIO e ON e.guia = s.guia
WHERE s.estado = 'entregado'
ORDER BY dias DESC, s.guia;

-- 8. Destinatario en mayúsculas y los dos últimos dígitos de la guía.
SELECT guia, UPPER(destinatario) AS destinatario, RIGHT(guia, 2) AS sufijo
FROM ENVIO
ORDER BY guia;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 9. Rastreo de la guía GU-000103 con fecha y hora en formato corto.
SELECT consecutivo, DATE_FORMAT(fecha_hora, '%d/%m %H:%i') AS cuando, estado,
       IFNULL(observacion, '-') AS observacion
FROM SEGUIMIENTO
WHERE guia = 'GU-000103'
ORDER BY consecutivo;

-- 10. Capacidad de carga según el vehículo del mensajero.
SELECT nombre, vehiculo,
       CASE vehiculo WHEN 'bicicleta' THEN 'Hasta 10 kg'
                     WHEN 'moto' THEN 'Hasta 30 kg'
                     ELSE 'Carga pesada' END AS capacidad
FROM MENSAJERO
ORDER BY id_mensajero;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 11. Envíos y facturación por sede de origen.
SELECT id_sede_origen, COUNT(*) AS envios, SUM(costo) AS facturado
FROM ENVIO
GROUP BY id_sede_origen
ORDER BY facturado DESC;

-- 12. Peso promedio por ciudad de destino, solo donde hay dos o más envíos.
SELECT ciudad_destino, COUNT(*) AS envios, ROUND(AVG(peso_kg), 2) AS peso_promedio
FROM ENVIO
GROUP BY ciudad_destino
HAVING COUNT(*) >= 2
ORDER BY ciudad_destino;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 13. Cada envío con el cliente, la sede de origen y el mensajero (LEFT JOIN: el último no tiene mensajero).
SELECT e.guia, c.razon_social, s.ciudad AS origen, m.nombre AS mensajero
FROM ENVIO e
JOIN CLIENTE c ON c.nit = e.nit_cliente
JOIN SEDE s ON s.id_sede = e.id_sede_origen
LEFT JOIN ASIGNACION a ON a.guia = e.guia
LEFT JOIN MENSAJERO m ON m.id_mensajero = a.id_mensajero
ORDER BY e.guia;

-- 14. Mensajeros con la ciudad de su sede (USING sobre id_sede).
SELECT nombre, vehiculo, ciudad
FROM MENSAJERO
JOIN SEDE USING (id_sede)
ORDER BY ciudad, nombre;

-- 15. Paquetes frágiles con su destino (NATURAL JOIN sobre guia).
SELECT guia, destinatario, ciudad_destino
FROM ENVIO
NATURAL JOIN PAQUETE
WHERE fragil = 1;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 16. Estado actual de cada guía: el evento con el consecutivo más alto (correlacionada).
SELECT s.guia, s.estado, s.fecha_hora
FROM SEGUIMIENTO s
WHERE s.consecutivo = (SELECT MAX(x.consecutivo) FROM SEGUIMIENTO x WHERE x.guia = s.guia)
ORDER BY s.guia;

-- 17. Envíos que todavía no tienen mensajero.
SELECT guia, fecha_recepcion, destinatario
FROM ENVIO e
WHERE NOT EXISTS (SELECT 1 FROM ASIGNACION a WHERE a.guia = e.guia);

-- 18. Mensajeros sin ningún envío asignado.
SELECT nombre
FROM MENSAJERO
WHERE id_mensajero NOT IN (SELECT id_mensajero FROM ASIGNACION);

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 19. Guías que requieren atención: tuvieron novedad o no tienen mensajero.
SELECT guia FROM SEGUIMIENTO WHERE estado = 'novedad'
UNION
SELECT guia FROM ENVIO WHERE guia NOT IN (SELECT guia FROM ASIGNACION)
ORDER BY guia;

-- 20. Clientes que mandan paquetes y también documentos.
SELECT e.nit_cliente FROM ENVIO e JOIN PAQUETE p ON p.guia = e.guia
INTERSECT
SELECT e.nit_cliente FROM ENVIO e JOIN DOCUMENTO d ON d.guia = e.guia;

-- 21. Guías que todavía no se han entregado.
SELECT guia FROM ENVIO
EXCEPT
SELECT guia FROM SEGUIMIENTO WHERE estado = 'entregado';
