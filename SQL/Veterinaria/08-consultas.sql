-- =====================================================================
--  Clínica veterinaria · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Catálogo de medicamentos con el precio y el precio con IVA del 19 %.
SELECT nombre, presentacion, precio, precio * 1.19 AS precio_con_iva
FROM MEDICAMENTO;

-- 2. Especies distintas que atiende la clínica.
SELECT DISTINCT especie
FROM MASCOTA
ORDER BY especie;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Consultas de octubre de 2026, de la más cara a la más barata.
SELECT id_consulta, fecha, motivo, valor
FROM CONSULTA
WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY valor DESC;

-- 4. Consultas que todavía no tienen diagnóstico.
SELECT id_consulta, fecha, motivo
FROM CONSULTA
WHERE diagnostico IS NULL;

-- 5. Perros y gatos cuyo nombre empieza por M.
SELECT nombre, especie, raza
FROM MASCOTA
WHERE especie IN ('perro', 'gato')
  AND nombre LIKE 'M%'
ORDER BY nombre;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Edad de cada mascota (el atributo derivado del MER), de la mayor a la menor.
SELECT nombre, especie, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM MASCOTA
ORDER BY edad DESC, nombre;

-- 7. Nombre del dueño en mayúsculas y las cuatro primeras letras de su apellido como código de archivo.
SELECT UPPER(CONCAT(nombres, ' ', apellidos)) AS dueno,
       SUBSTRING(apellidos, 1, 4) AS codigo_archivo
FROM DUENO
ORDER BY apellidos;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Consultas del cirujano con la fecha en formato día/mes/año y el diagnóstico pendiente marcado.
SELECT id_consulta,
       DATE_FORMAT(fecha, '%d/%m/%Y') AS fecha,
       IFNULL(diagnostico, 'Pendiente') AS diagnostico
FROM CONSULTA
WHERE id_veterinario = 2
ORDER BY id_consulta;

-- 9. Clasificación de los medicamentos por precio.
SELECT nombre, precio,
       CASE WHEN precio < 15000 THEN 'Economico'
            WHEN precio < 30000 THEN 'Medio'
            ELSE 'Alto' END AS rango
FROM MEDICAMENTO
ORDER BY precio;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Veterinarios con al menos dos consultas: cuántas, cuánto facturaron y el promedio.
SELECT id_veterinario, COUNT(*) AS consultas,
       SUM(valor) AS total, ROUND(AVG(valor), 0) AS promedio
FROM CONSULTA
GROUP BY id_veterinario
HAVING COUNT(*) >= 2
ORDER BY total DESC;

-- 11. Medicamentos más recetados y total de días de tratamiento.
SELECT codigo_medicamento, COUNT(*) AS veces, SUM(dias) AS dias_tratamiento
FROM RECETA
GROUP BY codigo_medicamento
ORDER BY veces DESC, codigo_medicamento;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Historia de Toby (dueña 52345678, mascota 2) con el veterinario que lo atendió.
SELECT c.fecha, c.motivo, v.nombre AS veterinario
FROM CONSULTA c
JOIN VETERINARIO v ON v.id_veterinario = c.id_veterinario
WHERE c.cedula_dueno = '52345678' AND c.numero_mascota = 2
ORDER BY c.fecha;

-- 13. Teléfonos de cada dueño (JOIN con USING, porque la columna se llama igual en las dos tablas).
SELECT nombres, apellidos, telefono
FROM DUENO
JOIN DUE_TELEFONO USING (cedula)
ORDER BY apellidos, telefono;

-- 14. Todos los veterinarios con su número de consultas, incluso los que no tienen (LEFT JOIN).
SELECT v.nombre, COUNT(c.id_consulta) AS consultas
FROM VETERINARIO v
LEFT JOIN CONSULTA c ON c.id_veterinario = v.id_veterinario
GROUP BY v.id_veterinario, v.nombre
ORDER BY consultas DESC, v.nombre;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 15. Consultas que cuestan más que el promedio.
SELECT id_consulta, motivo, valor
FROM CONSULTA
WHERE valor > (SELECT AVG(valor) FROM CONSULTA)
ORDER BY valor DESC;

-- 16. Medicamentos que nunca se han recetado.
SELECT m.codigo, m.nombre
FROM MEDICAMENTO m
WHERE NOT EXISTS (SELECT 1 FROM RECETA r
                  WHERE r.codigo_medicamento = m.codigo);

-- 17. Mascotas que ha atendido alguien de dermatología.
SELECT nombre, especie
FROM MASCOTA
WHERE (cedula_dueno, numero) IN (SELECT cedula_dueno, numero_mascota
                                 FROM CONSULTA
                                 WHERE id_veterinario IN (SELECT id_veterinario
                                                          FROM VETERINARIO
                                                          WHERE especialidad = 'Dermatologia'));

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 18. Directorio de la clínica: dueños y veterinarios en una sola lista.
SELECT CONCAT(nombres, ' ', apellidos) AS nombre, 'dueno' AS rol FROM DUENO
UNION
SELECT nombre, 'veterinario' FROM VETERINARIO
ORDER BY rol, nombre;

-- 19. Medicamentos que se recetaron tanto en urgencias como en consultas que no lo son.
SELECT codigo_medicamento FROM RECETA
WHERE id_consulta IN (SELECT id_consulta FROM URGENCIA)
INTERSECT
SELECT codigo_medicamento FROM RECETA
WHERE id_consulta NOT IN (SELECT id_consulta FROM URGENCIA);

-- 20. Veterinarios que nunca han atendido una urgencia.
SELECT id_veterinario FROM VETERINARIO
EXCEPT
SELECT c.id_veterinario
FROM CONSULTA c JOIN URGENCIA u ON u.id_consulta = c.id_consulta;
