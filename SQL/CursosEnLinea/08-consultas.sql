-- =====================================================================
--  Plataforma de cursos en línea · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Cursos con el precio en pesos y aproximado en dólares (a 4.000).
SELECT codigo, titulo, precio, precio / 4000 AS precio_usd
FROM CURSO;

-- 2. Países de los usuarios.
SELECT DISTINCT pais
FROM USUARIO
ORDER BY pais;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Inscripciones que van por debajo del 50 %.
SELECT id_estudiante, codigo_curso, progreso
FROM INSCRIPCION
WHERE progreso < 50
ORDER BY progreso;

-- 4. Usuarios que se registraron en 2026.
SELECT nombre, fecha_registro
FROM USUARIO
WHERE fecha_registro >= '2026-01-01'
ORDER BY fecha_registro;

-- 5. Cursos básicos o intermedios de menos de 150.000, del más caro al más barato.
SELECT codigo, nivel, precio
FROM CURSO
WHERE nivel IN ('basico', 'intermedio') AND precio < 150000
ORDER BY precio DESC;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Meses que lleva registrado cada usuario.
SELECT nombre, fecha_registro, TIMESTAMPDIFF(MONTH, fecha_registro, CURDATE()) AS meses
FROM USUARIO
ORDER BY meses DESC;

-- 7. Usuario de cada correo (lo que va antes de la arroba).
SELECT correo, SUBSTRING_INDEX(correo, '@', 1) AS usuario
FROM USUARIO
ORDER BY usuario;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Rol de cada usuario a partir de las banderas.
SELECT nombre,
       CASE WHEN es_estudiante = 1 AND es_instructor = 1 THEN 'ambos'
            WHEN es_instructor = 1 THEN 'instructor'
            ELSE 'estudiante' END AS rol
FROM USUARIO
ORDER BY id_usuario;

-- 9. Inscripciones con la nota o el aviso de que el curso sigue en marcha.
SELECT id_estudiante, codigo_curso,
       IFNULL(CAST(calificacion AS CHAR), 'en curso') AS nota
FROM INSCRIPCION
ORDER BY id_estudiante, codigo_curso;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Número de inscritos por curso (el atributo derivado), solo los que tienen dos o más.
SELECT codigo_curso, COUNT(*) AS inscritos
FROM INSCRIPCION
GROUP BY codigo_curso
HAVING COUNT(*) >= 2
ORDER BY inscritos DESC, codigo_curso;

-- 11. Por curso: inscritos, cuántos tienen nota y el promedio (AVG ignora los NULL).
SELECT codigo_curso, COUNT(*) AS inscritos, COUNT(calificacion) AS con_nota,
       ROUND(AVG(calificacion), 2) AS promedio
FROM INSCRIPCION
GROUP BY codigo_curso
ORDER BY codigo_curso;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Estudiante, curso e instructor: USUARIO se une dos veces, una por cada rol.
SELECT e.nombre AS estudiante, c.titulo, i.nombre AS instructor
FROM INSCRIPCION x
JOIN USUARIO e ON e.id_usuario = x.id_estudiante
JOIN CURSO c ON c.codigo = x.codigo_curso
JOIN USUARIO i ON i.id_usuario = c.id_instructor
ORDER BY i.nombre, e.nombre;

-- 13. Categorías con su número de cursos, incluso las vacías.
SELECT g.nombre, COUNT(c.codigo) AS cursos
FROM CATEGORIA g
LEFT JOIN CURSO c ON c.id_categoria = g.id_categoria
GROUP BY g.id_categoria, g.nombre
ORDER BY cursos DESC, g.nombre;

-- 14. Inscripciones de Juan Pérez con los idiomas disponibles del curso (USING sobre codigo_curso).
SELECT codigo_curso, idioma, progreso
FROM INSCRIPCION
JOIN CURSO_IDIOMA USING (codigo_curso)
WHERE id_estudiante = 3
ORDER BY codigo_curso, idioma;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 15. Cursos sin ningún inscrito.
SELECT codigo, titulo
FROM CURSO c
WHERE NOT EXISTS (SELECT 1 FROM INSCRIPCION x WHERE x.codigo_curso = c.codigo);

-- 16. Estudiantes que van más adelantados que el promedio de su curso (correlacionada).
SELECT x.id_estudiante, x.codigo_curso, x.progreso
FROM INSCRIPCION x
WHERE x.progreso > (SELECT AVG(y.progreso) FROM INSCRIPCION y WHERE y.codigo_curso = x.codigo_curso)
ORDER BY x.codigo_curso;

-- 17. Instructores que también estudian en la plataforma.
SELECT nombre
FROM USUARIO
WHERE id_usuario IN (SELECT id_instructor FROM CURSO)
  AND id_usuario IN (SELECT id_estudiante FROM INSCRIPCION);

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 18. Usuarios que dictan y también estudian (confirma que la jerarquía es solapada).
SELECT id_instructor AS id_usuario FROM CURSO
INTERSECT
SELECT id_estudiante FROM INSCRIPCION;

-- 19. Cursos que se ofrecen en inglés o que son avanzados.
SELECT codigo_curso FROM CURSO_IDIOMA WHERE idioma = 'en'
UNION
SELECT codigo FROM CURSO WHERE nivel = 'avanzado'
ORDER BY codigo_curso;

-- 20. Estudiantes que todavía no terminan ningún curso.
SELECT id_estudiante FROM INSCRIPCION
EXCEPT
SELECT id_estudiante FROM INSCRIPCION WHERE progreso = 100;
