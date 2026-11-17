-- =====================================================================
--  Plataforma de cursos en línea · 03-usuariospermisos.sql
--  Usuarios con el mínimo privilegio que necesita cada uno.
--  Motor: MySQL 8.0  ·  Base de datos: cursos
-- =====================================================================

-- Las contraseñas son de ejemplo: cámbielas antes de usar el script.

-- Aplicación: lee y escribe datos, pero no puede cambiar la estructura.
CREATE USER IF NOT EXISTS 'cursos_app'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_1';
GRANT SELECT, INSERT, UPDATE, DELETE ON cursos.* TO 'cursos_app'@'localhost';

-- Consulta: solo lectura, para reportes.
CREATE USER IF NOT EXISTS 'cursos_lectura'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_2';
GRANT SELECT ON cursos.* TO 'cursos_lectura'@'localhost';

SHOW GRANTS FOR 'cursos_app'@'localhost';
SHOW GRANTS FOR 'cursos_lectura'@'localhost';
