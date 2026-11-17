-- =====================================================================
--  Taller mecánico · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

-- Año de modelo razonable.
ALTER TABLE VEHICULO
  ADD CONSTRAINT chk_vehiculo_modelo CHECK (modelo BETWEEN 1980 AND 2027);

-- Niveles de los mecánicos.
ALTER TABLE MECANICO
  ADD CONSTRAINT chk_mecanico_nivel CHECK (nivel IN ('junior', 'senior', 'jefe'));

-- Salario positivo.
ALTER TABLE MECANICO
  ADD CONSTRAINT chk_mecanico_salario CHECK (salario > 0);

-- Salario positivo.
ALTER TABLE ASESOR
  ADD CONSTRAINT chk_asesor_salario CHECK (salario > 0);

-- Nadie se supervisa a sí mismo (reflexiva).
ALTER TABLE SUPERVISION
  ADD CONSTRAINT chk_supervision_distintos CHECK (id_mecanico <> id_supervisor);

-- Estados de una orden.
ALTER TABLE ORDEN
  ADD CONSTRAINT chk_orden_estado CHECK (estado IN ('recibida', 'en proceso', 'entregada'));

-- No se entrega antes de recibir.
ALTER TABLE ORDEN
  ADD CONSTRAINT chk_orden_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_ingreso);

-- Una orden entregada tiene fecha de entrega.
ALTER TABLE ORDEN
  ADD CONSTRAINT chk_orden_entrega CHECK (estado <> 'entregada' OR fecha_entrega IS NOT NULL);

-- El kilometraje no es negativo.
ALTER TABLE ORDEN
  ADD CONSTRAINT chk_orden_km CHECK (kilometraje >= 0);

-- Horas de un día de trabajo.
ALTER TABLE TRABAJO
  ADD CONSTRAINT chk_trabajo_horas CHECK (horas > 0 AND horas <= 24);

-- No hay existencias negativas.
ALTER TABLE REPUESTO
  ADD CONSTRAINT chk_repuesto_stock CHECK (stock >= 0);

-- Se usa al menos una unidad.
ALTER TABLE REPUESTO_ORDEN
  ADD CONSTRAINT chk_repuesto_orden_cantidad CHECK (cantidad > 0);

-- Resumen: deben aparecer 12 restricciones (12 CHECK de este script, 0 UNIQUE de este script
-- y 0 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'taller'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
