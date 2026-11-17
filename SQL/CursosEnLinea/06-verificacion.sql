-- =====================================================================
--  Plataforma de cursos en línea · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

-- 1. Tablas y motor (deben ser 5 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'cursos' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'CATEGORIA' AS tabla, COUNT(*) AS filas FROM CATEGORIA
UNION ALL SELECT 'USUARIO' AS tabla, COUNT(*) AS filas FROM USUARIO
UNION ALL SELECT 'CURSO' AS tabla, COUNT(*) AS filas FROM CURSO
UNION ALL SELECT 'CURSO_IDIOMA' AS tabla, COUNT(*) AS filas FROM CURSO_IDIOMA
UNION ALL SELECT 'INSCRIPCION' AS tabla, COUNT(*) AS filas FROM INSCRIPCION;

-- 3. Quien dicta un curso tiene la bandera de instructor (no debe devolver filas)
SELECT c.codigo FROM CURSO c JOIN USUARIO u ON u.id_usuario = c.id_instructor WHERE u.es_instructor = 0;

-- 4. Quien se inscribe tiene la bandera de estudiante (no debe devolver filas)
SELECT x.id_estudiante, x.codigo_curso FROM INSCRIPCION x JOIN USUARIO u ON u.id_usuario = x.id_estudiante WHERE u.es_estudiante = 0;

-- 5. Nadie se inscribe en su propio curso (no debe devolver filas)
SELECT x.id_estudiante, x.codigo_curso FROM INSCRIPCION x JOIN CURSO c ON c.codigo = x.codigo_curso WHERE c.id_instructor = x.id_estudiante;

-- 6. Nadie se inscribe antes de registrarse ni antes de que se publique el curso (no debe devolver filas)
SELECT x.id_estudiante, x.codigo_curso FROM INSCRIPCION x JOIN USUARIO u ON u.id_usuario = x.id_estudiante JOIN CURSO c ON c.codigo = x.codigo_curso WHERE x.fecha_inscripcion < u.fecha_registro OR x.fecha_inscripcion < c.fecha_publicacion;

-- 7. Todo curso tiene por lo menos un idioma (no debe devolver filas)
SELECT c.codigo FROM CURSO c WHERE NOT EXISTS (SELECT 1 FROM CURSO_IDIOMA i WHERE i.codigo_curso = c.codigo);
