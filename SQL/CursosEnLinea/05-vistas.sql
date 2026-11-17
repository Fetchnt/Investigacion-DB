-- =====================================================================
--  Plataforma de cursos en línea · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

-- Rol de cada usuario según las banderas de la jerarquía solapada.
CREATE OR REPLACE VIEW v_roles AS
SELECT id_usuario, nombre,
       CASE WHEN es_estudiante = 1 AND es_instructor = 1 THEN 'estudiante e instructor'
            WHEN es_instructor = 1 THEN 'instructor'
            ELSE 'estudiante' END AS rol
FROM USUARIO;

-- Avance de cada estudiante con el curso y su instructor.
CREATE OR REPLACE VIEW v_avance AS
SELECT e.nombre AS estudiante, c.titulo, i.nombre AS instructor, x.progreso, x.calificacion
FROM INSCRIPCION x
JOIN USUARIO e ON e.id_usuario = x.id_estudiante
JOIN CURSO c ON c.codigo = x.codigo_curso
JOIN USUARIO i ON i.id_usuario = c.id_instructor;
