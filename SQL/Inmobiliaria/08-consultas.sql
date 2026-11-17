-- =====================================================================
--  Agencia inmobiliaria · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Inmuebles en venta con su precio por metro cuadrado.
SELECT matricula, area_m2, precio_venta, precio_venta / area_m2 AS precio_m2
FROM INMUEBLE
WHERE en_venta = 1;

-- 2. Tipos de inmueble que maneja la agencia.
SELECT DISTINCT tipo
FROM INMUEBLE
ORDER BY tipo;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Arriendos de estrato 4 o más por menos de 4 millones.
SELECT matricula, barrio, estrato, canon_mensual
FROM INMUEBLE
WHERE en_arriendo = 1 AND estrato >= 4 AND canon_mensual < 4000000
ORDER BY canon_mensual;

-- 4. Inmuebles de tres o más habitaciones en Bogotá o Medellín, del más grande al más pequeño.
SELECT matricula, ciudad, habitaciones, area_m2
FROM INMUEBLE
WHERE habitaciones >= 3 AND ciudad IN ('Bogota', 'Medellin')
ORDER BY area_m2 DESC;

-- 5. Visitas en las que el cliente no dejó comentario.
SELECT documento_cliente, matricula, fecha
FROM VISITA
WHERE comentario IS NULL
ORDER BY fecha;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Dirección completa (atributo compuesto) y precio en millones.
SELECT matricula, CONCAT(calle, ' # ', numero, ', ', barrio) AS direccion,
       ROUND(precio_venta / 1000000, 0) AS millones
FROM INMUEBLE
WHERE en_venta = 1
ORDER BY millones;

-- 7. Oficina de registro de cada matrícula (lo que va antes del guion).
SELECT matricula, SUBSTRING(matricula, 1, INSTR(matricula, '-') - 1) AS oficina_registro, ciudad
FROM INMUEBLE
ORDER BY oficina_registro, matricula;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Modalidad de cada inmueble a partir de las banderas.
SELECT matricula,
       CASE WHEN en_venta = 1 AND en_arriendo = 1 THEN 'venta y arriendo'
            WHEN en_venta = 1 THEN 'venta'
            WHEN en_arriendo = 1 THEN 'arriendo'
            ELSE 'retirado' END AS modalidad
FROM INMUEBLE
ORDER BY modalidad, matricula;

-- 9. Visitas con fecha en formato corto y el comentario o un aviso.
SELECT DATE_FORMAT(fecha, '%d/%m/%Y') AS dia, matricula,
       IFNULL(comentario, 'sin comentario') AS comentario
FROM VISITA
ORDER BY fecha;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Inmuebles por ciudad y tipo.
SELECT ciudad, tipo, COUNT(*) AS inmuebles
FROM INMUEBLE
GROUP BY ciudad, tipo
ORDER BY ciudad, tipo;

-- 11. Inmuebles con interés promedio de 4 o más en sus visitas.
SELECT matricula, COUNT(*) AS visitas, AVG(interes) AS interes_promedio
FROM VISITA
GROUP BY matricula
HAVING AVG(interes) >= 4
ORDER BY interes_promedio DESC, matricula;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Comisión de cada venta según la tabla de rangos (non-equijoin con BETWEEN).
SELECT i.matricula, i.precio_venta, r.porcentaje,
       i.precio_venta * r.porcentaje / 100 AS comision
FROM INMUEBLE i
JOIN RANGO_COMISION r ON i.precio_venta BETWEEN r.valor_min AND r.valor_max
WHERE i.en_venta = 1
ORDER BY i.precio_venta;

-- 13. Visitas con el cliente y el agente que gestiona el inmueble.
SELECT v.fecha, c.nombre AS cliente, i.barrio, a.nombre AS agente
FROM VISITA v
JOIN CLIENTE c ON c.documento = v.documento_cliente
JOIN INMUEBLE i ON i.matricula = v.matricula
JOIN AGENTE a ON a.id_agente = i.id_agente
ORDER BY v.fecha;

-- 14. Agentes con el número de inmuebles, incluso los que no tienen.
SELECT a.nombre, COUNT(i.matricula) AS inmuebles
FROM AGENTE a
LEFT JOIN INMUEBLE i ON i.id_agente = a.id_agente
GROUP BY a.id_agente, a.nombre
ORDER BY inmuebles DESC, a.nombre;

-- 15. Teléfonos de cada propietario (USING sobre documento).
SELECT nombre, telefono
FROM PROPIETARIO
JOIN PROP_TELEFONO USING (documento)
ORDER BY nombre, telefono;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 16. Clientes a los que les alcanza el presupuesto para comprar algún inmueble (EXISTS correlacionado).
SELECT c.nombre, c.presupuesto
FROM CLIENTE c
WHERE EXISTS (SELECT 1 FROM INMUEBLE i
              WHERE i.en_venta = 1 AND i.precio_venta <= c.presupuesto);

-- 17. Inmuebles ofrecidos que nadie ha visitado.
SELECT matricula, barrio, ciudad
FROM INMUEBLE
WHERE (en_venta = 1 OR en_arriendo = 1)
  AND matricula NOT IN (SELECT matricula FROM VISITA);

-- 18. El inmueble más grande de cada ciudad.
SELECT i.ciudad, i.matricula, i.area_m2
FROM INMUEBLE i
WHERE i.area_m2 = (SELECT MAX(x.area_m2) FROM INMUEBLE x WHERE x.ciudad = i.ciudad)
ORDER BY i.ciudad;

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 19. Clientes que han visitado inmuebles en Bogotá y también en Medellín.
SELECT v.documento_cliente FROM VISITA v JOIN INMUEBLE i ON i.matricula = v.matricula WHERE i.ciudad = 'Bogota'
INTERSECT
SELECT v.documento_cliente FROM VISITA v JOIN INMUEBLE i ON i.matricula = v.matricula WHERE i.ciudad = 'Medellin';

-- 20. Directorio telefónico: propietarios y agentes.
SELECT p.nombre, t.telefono, 'propietario' AS rol FROM PROPIETARIO p JOIN PROP_TELEFONO t ON t.documento = p.documento
UNION
SELECT nombre, telefono, 'agente' FROM AGENTE
ORDER BY rol, nombre;

-- 21. Inmuebles en arriendo que no están también en venta.
SELECT matricula FROM INMUEBLE WHERE en_arriendo = 1
EXCEPT
SELECT matricula FROM INMUEBLE WHERE en_venta = 1;
