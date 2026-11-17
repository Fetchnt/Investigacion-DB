-- =====================================================================
--  Plataforma de cursos en línea · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

USE cursos;

START TRANSACTION;

-- CATEGORIA (4)
INSERT INTO CATEGORIA (id_categoria, nombre) VALUES
  (1, 'Programacion'),
  (2, 'Bases de datos'),
  (3, 'Diseno'),
  (4, 'Idiomas');

-- USUARIO (7)
INSERT INTO USUARIO (id_usuario, correo, nombre, fecha_registro, pais, es_estudiante, es_instructor, nivel_educativo, profesion, biografia) VALUES
  (1, 'mrojas@campus.co', 'Martin Rojas', '2024-01-15', 'Colombia', 0, 1, NULL, 'Ingeniero de sistemas', 'Diez anios desarrollando backend'),
  (2, 'lgarcia@campus.co', 'Lucia Garcia', '2024-03-02', 'Peru', 1, 1, 'Maestria', 'Disenadora UX', 'Disenadora de producto'),
  (3, 'jperez@campus.co', 'Juan Perez', '2025-02-10', 'Colombia', 1, 0, 'Pregrado', NULL, NULL),
  (4, 'akim@campus.co', 'Ana Kim', '2025-05-21', 'Chile', 1, 0, 'Bachillerato', NULL, NULL),
  (5, 'dmora@campus.co', 'Daniel Mora', '2024-11-30', 'Colombia', 1, 1, 'Pregrado', 'Administrador de BD', 'DBA certificado'),
  (6, 'sruiz@campus.co', 'Sara Ruiz', '2026-01-08', 'Mexico', 1, 0, 'Pregrado', NULL, NULL),
  (7, 'pvelez@campus.co', 'Pablo Velez', '2026-06-17', 'Colombia', 1, 0, 'Tecnico', NULL, NULL);

-- CURSO (6)
INSERT INTO CURSO (codigo, titulo, nivel, precio, fecha_publicacion, id_categoria, id_instructor, nombre_foro, foro_moderado) VALUES
  ('PY-101', 'Python desde cero', 'basico', 120000.0, '2024-06-01', 1, 1, 'Foro Python 101', 1),
  ('PY-201', 'Python para analisis de datos', 'intermedio', 180000.0, '2025-01-15', 1, 1, 'Foro Datos con Python', 1),
  ('SQL-101', 'SQL para principiantes', 'basico', 99000.0, '2025-03-10', 2, 5, 'Foro SQL', 0),
  ('SQL-301', 'Optimizacion de consultas', 'avanzado', 250000.0, '2025-09-01', 2, 5, 'Foro Rendimiento', 1),
  ('UX-101', 'Fundamentos de UX', 'basico', 110000.0, '2024-08-20', 3, 2, 'Foro UX', 0),
  ('FIG-201', 'Prototipado en Figma', 'intermedio', 150000.0, '2026-02-01', 3, 2, 'Foro Figma', 0);

-- CURSO_IDIOMA (10)
INSERT INTO CURSO_IDIOMA (codigo_curso, idioma) VALUES
  ('PY-101', 'es'),
  ('PY-101', 'en'),
  ('PY-201', 'es'),
  ('SQL-101', 'es'),
  ('SQL-101', 'pt'),
  ('SQL-301', 'es'),
  ('SQL-301', 'en'),
  ('UX-101', 'es'),
  ('FIG-201', 'es'),
  ('FIG-201', 'en');

-- INSCRIPCION (11)
INSERT INTO INSCRIPCION (id_estudiante, codigo_curso, fecha_inscripcion, progreso, calificacion) VALUES
  (3, 'PY-101', '2025-02-12', 100, 4.5),
  (3, 'SQL-101', '2025-04-01', 100, 4.8),
  (3, 'PY-201', '2026-03-05', 60, NULL),
  (4, 'PY-101', '2025-06-01', 35, NULL),
  (4, 'UX-101', '2025-06-10', 100, 3.9),
  (2, 'SQL-101', '2025-03-20', 100, 4.2),
  (2, 'PY-101', '2024-07-01', 100, 5.0),
  (5, 'UX-101', '2025-01-05', 80, NULL),
  (6, 'SQL-301', '2026-02-14', 20, NULL),
  (6, 'SQL-101', '2026-01-20', 100, 4.0),
  (7, 'PY-101', '2026-06-20', 10, NULL);

COMMIT;
