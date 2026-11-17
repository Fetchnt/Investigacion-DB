-- =====================================================================
--  Clínica veterinaria · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

-- La clínica solo atiende estas especies.
ALTER TABLE MASCOTA
  ADD CONSTRAINT chk_mascota_especie CHECK (especie IN ('perro', 'gato', 'ave', 'conejo', 'reptil', 'otro'));

-- El discriminador empieza en 1.
ALTER TABLE MASCOTA
  ADD CONSTRAINT chk_mascota_numero CHECK (numero >= 1);

-- Toda consulta cobra algo.
ALTER TABLE CONSULTA
  ADD CONSTRAINT chk_consulta_valor CHECK (valor > 0);

-- El precio de catálogo es positivo.
ALTER TABLE MEDICAMENTO
  ADD CONSTRAINT chk_medicamento_precio CHECK (precio > 0);

-- Un tratamiento dura entre 1 y 90 días.
ALTER TABLE RECETA
  ADD CONSTRAINT chk_receta_dias CHECK (dias BETWEEN 1 AND 90);

-- El triage va de 1 (más grave) a 5.
ALTER TABLE URGENCIA
  ADD CONSTRAINT chk_urgencia_triage CHECK (nivel_triage BETWEEN 1 AND 5);

-- Resumen: deben aparecer 8 restricciones (6 CHECK de este script, 0 UNIQUE de este script
-- y 2 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'veterinaria'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
