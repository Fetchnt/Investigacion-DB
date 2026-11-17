-- =====================================================================
--  Empresa de mensajería · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

-- Vehículos de la flota.
ALTER TABLE MENSAJERO
  ADD CONSTRAINT chk_mensajero_vehiculo CHECK (vehiculo IN ('moto', 'bicicleta', 'furgon'));

-- Todo envío pesa algo.
ALTER TABLE ENVIO
  ADD CONSTRAINT chk_envio_peso CHECK (peso_kg > 0);

-- Un documento puede declarar 0.
ALTER TABLE ENVIO
  ADD CONSTRAINT chk_envio_valor CHECK (valor_declarado >= 0);

-- Todo envío se cobra.
ALTER TABLE ENVIO
  ADD CONSTRAINT chk_envio_costo CHECK (costo > 0);

-- Las medidas son positivas.
ALTER TABLE PAQUETE
  ADD CONSTRAINT chk_paquete_medidas CHECK (alto_cm > 0 AND ancho_cm > 0 AND largo_cm > 0);

-- Un documento tiene folios.
ALTER TABLE DOCUMENTO
  ADD CONSTRAINT chk_documento_folios CHECK (num_folios > 0);

-- Estados del rastreo.
ALTER TABLE SEGUIMIENTO
  ADD CONSTRAINT chk_seguimiento_estado CHECK (estado IN ('recibido', 'en transito', 'en reparto', 'novedad', 'entregado', 'devuelto'));

-- El discriminador empieza en 1.
ALTER TABLE SEGUIMIENTO
  ADD CONSTRAINT chk_seguimiento_consecutivo CHECK (consecutivo >= 1);

-- Resumen: deben aparecer 9 restricciones (8 CHECK de este script, 0 UNIQUE de este script
-- y 1 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'mensajeria'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
