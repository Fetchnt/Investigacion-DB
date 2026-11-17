-- =====================================================================
--  Empresa de mensajería · 03-usuariospermisos.sql
--  Usuarios con el mínimo privilegio que necesita cada uno.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

-- Las contraseñas son de ejemplo: cámbielas antes de usar el script.

-- Aplicación: lee y escribe datos, pero no puede cambiar la estructura.
CREATE USER IF NOT EXISTS 'mensajeria_app'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_1';
GRANT SELECT, INSERT, UPDATE, DELETE ON mensajeria.* TO 'mensajeria_app'@'localhost';

-- Consulta: solo lectura, para reportes.
CREATE USER IF NOT EXISTS 'mensajeria_lectura'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_2';
GRANT SELECT ON mensajeria.* TO 'mensajeria_lectura'@'localhost';

SHOW GRANTS FOR 'mensajeria_app'@'localhost';
SHOW GRANTS FOR 'mensajeria_lectura'@'localhost';
