-- =====================================================================
--  Agencia inmobiliaria · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

-- El rango tiene sentido.
ALTER TABLE RANGO_COMISION
  ADD CONSTRAINT chk_rango_valores CHECK (valor_max > valor_min AND valor_min >= 0);

-- Porcentaje de comisión razonable.
ALTER TABLE RANGO_COMISION
  ADD CONSTRAINT chk_rango_porcentaje CHECK (porcentaje BETWEEN 0 AND 10);

-- Tipos de inmueble.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_tipo CHECK (tipo IN ('apartamento', 'casa', 'local', 'oficina'));

-- El área es positiva.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_area CHECK (area_m2 > 0);

-- Estratos de 1 a 6.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_estrato CHECK (estrato BETWEEN 1 AND 6);

-- Los locales y oficinas tienen 0.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_habitaciones CHECK (habitaciones >= 0);

-- Subtipo EN_VENTA dentro de la tabla única: sus datos existen si y solo si la bandera está en 1.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_venta CHECK ((en_venta = 1 AND precio_venta IS NOT NULL AND acepta_permuta IS NOT NULL) OR (en_venta = 0 AND precio_venta IS NULL AND acepta_permuta IS NULL));

-- Subtipo EN_ARRIENDO, misma idea.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_arriendo CHECK ((en_arriendo = 1 AND canon_mensual IS NOT NULL AND deposito IS NOT NULL) OR (en_arriendo = 0 AND canon_mensual IS NULL AND deposito IS NULL));

-- El depósito no pasa de dos cánones.
ALTER TABLE INMUEBLE
  ADD CONSTRAINT chk_inmueble_deposito CHECK (deposito IS NULL OR deposito <= 2 * canon_mensual);

-- Interés en escala de 1 a 5.
ALTER TABLE VISITA
  ADD CONSTRAINT chk_visita_interes CHECK (interes BETWEEN 1 AND 5);

-- Resumen: deben aparecer 10 restricciones (10 CHECK de este script, 0 UNIQUE de este script
-- y 0 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'inmobiliaria'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
