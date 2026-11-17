-- =====================================================================
--  Plataforma de cursos en línea · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

START TRANSACTION;

-- 1. Usuario sin ningún rol
--    Error esperado: 3819 (viola chk_usuario_total)
INSERT INTO USUARIO VALUES (8, 'x@campus.co', 'Sin Rol', '2026-11-01', 'Colombia', 0, 0, NULL, NULL, NULL);

-- 2. Instructor sin profesión
--    Error esperado: 3819 (viola chk_usuario_instructor)
UPDATE USUARIO SET es_instructor = 1 WHERE id_usuario = 4;

-- 3. Inscribirse dos veces en el mismo curso
--    Error esperado: 1062 (llave duplicada)
INSERT INTO INSCRIPCION VALUES (3, 'PY-101', '2026-11-01', 0, NULL);

-- 4. Avance mayor al 100 %
--    Error esperado: 3819 (viola chk_inscripcion_progreso)
UPDATE INSCRIPCION SET progreso = 120 WHERE id_estudiante = 4 AND codigo_curso = 'PY-101';

-- 5. Calificar un curso sin terminar
--    Error esperado: 3819 (viola chk_inscripcion_nota_final)
UPDATE INSCRIPCION SET calificacion = 4.0 WHERE id_estudiante = 7 AND codigo_curso = 'PY-101';

-- 6. Curso de una categoría que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO CURSO VALUES ('JS-101', 'JavaScript', 'basico', 90000, '2026-11-01', 9, 1, 'Foro JS', 0);

-- 7. Borrar una categoría que tiene cursos
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM CATEGORIA WHERE id_categoria = 2;

-- 8. Correo repetido
--    Error esperado: 1062 (llave duplicada)
INSERT INTO USUARIO VALUES (9, 'jperez@campus.co', 'Otro Juan', '2026-11-01', 'Colombia', 1, 0, 'Pregrado', NULL, NULL);

-- 9. Dos cursos con el mismo foro (rompería la 1:1)
--    Error esperado: 1062 (viola uq_curso_nombre_foro)
UPDATE CURSO SET nombre_foro = 'Foro SQL' WHERE codigo = 'SQL-301';

ROLLBACK;
