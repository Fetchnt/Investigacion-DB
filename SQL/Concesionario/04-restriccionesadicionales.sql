-- =====================================================================
--  Concesionario de vehículos · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

-- Año de modelo razonable.
ALTER TABLE VEHICULO
  ADD CONSTRAINT chk_vehiculo_anio CHECK (anio BETWEEN 1990 AND 2027);

-- El precio de lista es positivo.
ALTER TABLE VEHICULO
  ADD CONSTRAINT chk_vehiculo_precio CHECK (precio_lista > 0);

-- El VIN tiene exactamente 17 caracteres.
ALTER TABLE VEHICULO
  ADD CONSTRAINT chk_vehiculo_vin CHECK (CHAR_LENGTH(vin) = 17);

-- Garantía entre 1 y 7 años.
ALTER TABLE VEHICULO_NUEVO
  ADD CONSTRAINT chk_nuevo_garantia CHECK (garantia_meses BETWEEN 12 AND 84);

-- El kilometraje no es negativo.
ALTER TABLE VEHICULO_USADO
  ADD CONSTRAINT chk_usado_km CHECK (kilometraje >= 0);

-- Un usado tuvo al menos un dueño.
ALTER TABLE VEHICULO_USADO
  ADD CONSTRAINT chk_usado_propietarios CHECK (num_propietarios >= 1);

-- La comisión va de 0 % a 10 %.
ALTER TABLE VENDEDOR
  ADD CONSTRAINT chk_vendedor_comision CHECK (porcentaje_comision BETWEEN 0 AND 10);

-- El valor de la venta es positivo.
ALTER TABLE VENTA
  ADD CONSTRAINT chk_venta_valor CHECK (valor_final > 0);

-- Formas de pago que acepta el concesionario.
ALTER TABLE VENTA
  ADD CONSTRAINT chk_venta_forma_pago CHECK (forma_pago IN ('contado', 'credito', 'leasing'));

-- Resumen: deben aparecer 12 restricciones (9 CHECK de este script, 0 UNIQUE de este script
-- y 3 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'concesionario'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
