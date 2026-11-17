-- =====================================================================
--  Festival de música · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: festival
-- =====================================================================

USE festival;

-- El aforo es positivo.
ALTER TABLE ESCENARIO
  ADD CONSTRAINT chk_escenario_aforo CHECK (aforo > 0);

-- La jornada cierra después de abrir.
ALTER TABLE JORNADA
  ADD CONSTRAINT chk_jornada_horas CHECK (hora_cierre > hora_apertura);

-- Un show dura entre 15 minutos y 4 horas.
ALTER TABLE PRESENTACION
  ADD CONSTRAINT chk_presentacion_duracion CHECK (duracion_min BETWEEN 15 AND 240);

-- Una agrupación tiene por lo menos dos integrantes.
ALTER TABLE AGRUPACION
  ADD CONSTRAINT chk_agrupacion_integrantes CHECK (num_integrantes >= 2);

-- Tipos de boleta que vende el festival.
ALTER TABLE BOLETA
  ADD CONSTRAINT chk_boleta_tipo CHECK (tipo IN ('general', 'vip', 'abono'));

-- El precio es positivo.
ALTER TABLE BOLETA
  ADD CONSTRAINT chk_boleta_precio CHECK (precio > 0);

-- Clave candidata alternativa: en un escenario no empiezan dos shows a la misma hora de la misma jornada.
ALTER TABLE PRESENTACION
  ADD CONSTRAINT uq_presentacion_codigo_escenario_numero_jornada_hora_inicio UNIQUE (codigo_escenario, numero_jornada, hora_inicio);

-- Resumen: deben aparecer 9 restricciones (6 CHECK de este script, 1 UNIQUE de este script
-- y 2 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'festival'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
