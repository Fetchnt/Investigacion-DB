-- =====================================================================
--  Taller mecánico · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Repuestos con el valor de lo que hay en bodega.
SELECT codigo, nombre, precio_lista, stock, precio_lista * stock AS valor_bodega
FROM REPUESTO;

-- 2. Especialidades de los mecánicos, sin repetir.
SELECT DISTINCT especialidad
FROM MECANICO
ORDER BY especialidad;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Órdenes que todavía no se han entregado.
SELECT numero, placa, fecha_ingreso, estado
FROM ORDEN
WHERE fecha_entrega IS NULL
ORDER BY fecha_ingreso;

-- 4. Vehículos de modelo 2018 a 2021, del más nuevo al más viejo.
SELECT placa, marca, linea, modelo
FROM VEHICULO
WHERE modelo BETWEEN 2018 AND 2021
ORDER BY modelo DESC;

-- 5. Repuestos relacionados con frenos o con el aceite.
SELECT codigo, nombre
FROM REPUESTO
WHERE nombre LIKE '%freno%' OR nombre LIKE '%aceite%'
ORDER BY codigo;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Antigüedad de los mecánicos y su salario diario.
SELECT nombres, apellidos, TIMESTAMPDIFF(YEAR, fecha_ingreso, CURDATE()) AS antiguedad,
       ROUND(salario / 30, 0) AS salario_dia
FROM MECANICO
ORDER BY antiguedad DESC;

-- 7. Días que estuvo cada vehículo en el taller (órdenes entregadas).
SELECT numero, placa, DATEDIFF(fecha_entrega, fecha_ingreso) AS dias
FROM ORDEN
WHERE estado = 'entregada'
ORDER BY dias DESC, numero;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Órdenes con la fecha de entrega en formato corto o «pendiente».
SELECT numero, IFNULL(DATE_FORMAT(fecha_entrega, '%d/%m/%Y'), 'pendiente') AS entrega
FROM ORDEN
ORDER BY numero;

-- 9. Mecánicos con su nivel explicado.
SELECT nombres, nivel,
       CASE nivel WHEN 'jefe' THEN 'Jefe de taller'
                  WHEN 'senior' THEN 'Trabaja solo'
                  ELSE 'Trabaja con supervision' END AS descripcion
FROM MECANICO
ORDER BY id_empleado;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Horas trabajadas por mecánico, solo los que pasan de 3 horas.
SELECT id_mecanico, COUNT(*) AS ordenes, SUM(horas) AS horas
FROM TRABAJO
GROUP BY id_mecanico
HAVING SUM(horas) > 3
ORDER BY horas DESC;

-- 11. Valor de repuestos de cada orden.
SELECT numero_orden, SUM(cantidad * valor_unitario) AS repuestos
FROM REPUESTO_ORDEN
GROUP BY numero_orden
ORDER BY repuestos DESC;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Cada mecánico con el nombre de su supervisor (self join: MECANICO aparece dos veces con alias distintos).
SELECT m.nombres AS mecanico, s.nombres AS supervisor
FROM SUPERVISION x
JOIN MECANICO m ON m.id_empleado = x.id_mecanico
JOIN MECANICO s ON s.id_empleado = x.id_supervisor
ORDER BY s.nombres, m.nombres;

-- 13. Todos los mecánicos, tengan o no supervisor (LEFT JOIN).
SELECT m.nombres, m.nivel, x.id_supervisor
FROM MECANICO m
LEFT JOIN SUPERVISION x ON x.id_mecanico = m.id_empleado
ORDER BY m.id_empleado;

-- 14. Órdenes con el cliente dueño del vehículo y el asesor que la recibió.
SELECT o.numero, v.placa, c.nombre AS cliente, a.nombres AS asesor
FROM ORDEN o
JOIN VEHICULO v ON v.placa = o.placa
JOIN CLIENTE c ON c.documento = v.documento_cliente
JOIN ASESOR a ON a.id_empleado = o.id_asesor
ORDER BY o.numero;

-- 15. Repuestos cobrados por debajo de su precio de lista actual (por qué el valor se guarda en la relación).
SELECT ro.numero_orden, r.nombre, ro.valor_unitario, r.precio_lista
FROM REPUESTO_ORDEN ro
JOIN REPUESTO r ON r.codigo = ro.codigo_repuesto
WHERE ro.valor_unitario < r.precio_lista;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 16. Repuestos que nunca se han usado.
SELECT codigo, nombre
FROM REPUESTO
WHERE codigo NOT IN (SELECT codigo_repuesto FROM REPUESTO_ORDEN);

-- 17. Mecánicos que ganan más que el promedio de los mecánicos.
SELECT nombres, apellidos, salario
FROM MECANICO
WHERE salario > (SELECT AVG(salario) FROM MECANICO)
ORDER BY salario DESC;

-- 18. Última orden de cada vehículo (subconsulta correlacionada).
SELECT o.placa, o.numero, o.fecha_ingreso
FROM ORDEN o
WHERE o.fecha_ingreso = (SELECT MAX(x.fecha_ingreso) FROM ORDEN x WHERE x.placa = o.placa)
ORDER BY o.placa;

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 19. Nómina completa: mecánicos y asesores (UNION ALL reconstruye el supertipo).
SELECT id_empleado, nombres, salario, 'mecanico' AS cargo FROM MECANICO
UNION ALL
SELECT id_empleado, nombres, salario, 'asesor' FROM ASESOR
ORDER BY salario DESC;

-- 20. Mecánicos que no supervisan a nadie.
SELECT id_empleado FROM MECANICO
EXCEPT
SELECT id_supervisor FROM SUPERVISION;

-- 21. Mecánicos que son supervisados y también supervisan (mandos medios).
SELECT id_mecanico FROM SUPERVISION
INTERSECT
SELECT id_supervisor FROM SUPERVISION;
