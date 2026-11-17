-- =====================================================================
--  Plataforma de cursos en línea · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

-- Jerarquía total: todo usuario tiene al menos un rol.
ALTER TABLE USUARIO
  ADD CONSTRAINT chk_usuario_total CHECK (es_estudiante = 1 OR es_instructor = 1);

-- Si es estudiante, tiene nivel educativo.
ALTER TABLE USUARIO
  ADD CONSTRAINT chk_usuario_estudiante CHECK (es_estudiante = 0 OR nivel_educativo IS NOT NULL);

-- Si es instructor, tiene profesión.
ALTER TABLE USUARIO
  ADD CONSTRAINT chk_usuario_instructor CHECK (es_instructor = 0 OR profesion IS NOT NULL);

-- Niveles de curso.
ALTER TABLE CURSO
  ADD CONSTRAINT chk_curso_nivel CHECK (nivel IN ('basico', 'intermedio', 'avanzado'));

-- Hay cursos gratis, pero no precios negativos.
ALTER TABLE CURSO
  ADD CONSTRAINT chk_curso_precio CHECK (precio >= 0);

-- El avance es un porcentaje.
ALTER TABLE INSCRIPCION
  ADD CONSTRAINT chk_inscripcion_progreso CHECK (progreso BETWEEN 0 AND 100);

-- La nota va de 0 a 5.
ALTER TABLE INSCRIPCION
  ADD CONSTRAINT chk_inscripcion_calificacion CHECK (calificacion IS NULL OR calificacion BETWEEN 0 AND 5);

-- Solo se califica al terminar el curso.
ALTER TABLE INSCRIPCION
  ADD CONSTRAINT chk_inscripcion_nota_final CHECK (calificacion IS NULL OR progreso = 100);

-- Resumen: deben aparecer 11 restricciones (8 CHECK de este script, 0 UNIQUE de este script
-- y 3 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'cursos'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
