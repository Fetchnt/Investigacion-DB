-- =====================================================================
--  Clínica veterinaria · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

-- Historia clínica: cada consulta con la mascota, su dueño y el veterinario.
CREATE OR REPLACE VIEW v_historia_clinica AS
SELECT c.id_consulta, c.fecha, m.nombre AS mascota, m.especie,
       CONCAT(d.nombres, ' ', d.apellidos) AS dueno,
       v.nombre AS veterinario, c.motivo, c.diagnostico, c.valor
FROM CONSULTA c
JOIN MASCOTA m ON m.cedula_dueno = c.cedula_dueno AND m.numero = c.numero_mascota
JOIN DUENO d ON d.cedula = m.cedula_dueno
JOIN VETERINARIO v ON v.id_veterinario = c.id_veterinario;

-- Cada consulta con su tipo según la jerarquía.
CREATE OR REPLACE VIEW v_tipo_consulta AS
SELECT c.id_consulta, c.fecha,
       CASE WHEN u.id_consulta IS NOT NULL THEN 'urgencia'
            WHEN k.id_consulta IS NOT NULL THEN 'control'
            ELSE 'general' END AS tipo
FROM CONSULTA c
LEFT JOIN URGENCIA u ON u.id_consulta = c.id_consulta
LEFT JOIN CONTROL k ON k.id_consulta = c.id_consulta;
