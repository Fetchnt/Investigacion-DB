-- =====================================================================
--  Clínica veterinaria · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

-- 1. Tablas y motor (deben ser 9 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'veterinaria' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'DUENO' AS tabla, COUNT(*) AS filas FROM DUENO
UNION ALL SELECT 'DUE_TELEFONO' AS tabla, COUNT(*) AS filas FROM DUE_TELEFONO
UNION ALL SELECT 'MASCOTA' AS tabla, COUNT(*) AS filas FROM MASCOTA
UNION ALL SELECT 'VETERINARIO' AS tabla, COUNT(*) AS filas FROM VETERINARIO
UNION ALL SELECT 'CONSULTA' AS tabla, COUNT(*) AS filas FROM CONSULTA
UNION ALL SELECT 'MEDICAMENTO' AS tabla, COUNT(*) AS filas FROM MEDICAMENTO
UNION ALL SELECT 'RECETA' AS tabla, COUNT(*) AS filas FROM RECETA
UNION ALL SELECT 'URGENCIA' AS tabla, COUNT(*) AS filas FROM URGENCIA
UNION ALL SELECT 'CONTROL' AS tabla, COUNT(*) AS filas FROM CONTROL;

-- 3. Jerarquía disjunta: ninguna consulta es urgencia y control a la vez (no debe devolver filas)
SELECT u.id_consulta FROM URGENCIA u JOIN CONTROL k ON k.id_consulta = u.id_consulta;

-- 4. Participación (1,n): todo dueño tiene al menos una mascota (no debe devolver filas)
SELECT d.cedula FROM DUENO d WHERE NOT EXISTS (SELECT 1 FROM MASCOTA m WHERE m.cedula_dueno = d.cedula);

-- 5. Ninguna consulta es anterior al nacimiento de la mascota (no debe devolver filas)
SELECT c.id_consulta FROM CONSULTA c JOIN MASCOTA m ON m.cedula_dueno = c.cedula_dueno AND m.numero = c.numero_mascota WHERE c.fecha < m.fecha_nacimiento;

-- 6. El próximo control es posterior a la consulta (no debe devolver filas)
SELECT k.id_consulta FROM CONTROL k JOIN CONSULTA c ON c.id_consulta = k.id_consulta WHERE k.fecha_proximo_control <= c.fecha;
