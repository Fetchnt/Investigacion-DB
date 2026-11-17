-- =====================================================================
--  Clínica veterinaria · 03-usuariospermisos.sql
--  Usuarios con el mínimo privilegio que necesita cada uno.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

-- Las contraseñas son de ejemplo: cámbielas antes de usar el script.

-- Aplicación: lee y escribe datos, pero no puede cambiar la estructura.
CREATE USER IF NOT EXISTS 'veterinaria_app'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_1';
GRANT SELECT, INSERT, UPDATE, DELETE ON veterinaria.* TO 'veterinaria_app'@'localhost';

-- Consulta: solo lectura, para reportes.
CREATE USER IF NOT EXISTS 'veterinaria_lectura'@'localhost' IDENTIFIED BY 'Cambiar_Esta_Clave_2';
GRANT SELECT ON veterinaria.* TO 'veterinaria_lectura'@'localhost';

SHOW GRANTS FOR 'veterinaria_app'@'localhost';
SHOW GRANTS FOR 'veterinaria_lectura'@'localhost';
