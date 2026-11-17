-- =====================================================================
--  Concesionario de vehículos · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

-- 1. Tablas y motor (deben ser 9 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'concesionario' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'SEDE' AS tabla, COUNT(*) AS filas FROM SEDE
UNION ALL SELECT 'VENDEDOR' AS tabla, COUNT(*) AS filas FROM VENDEDOR
UNION ALL SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'VEHICULO' AS tabla, COUNT(*) AS filas FROM VEHICULO
UNION ALL SELECT 'VEHICULO_NUEVO' AS tabla, COUNT(*) AS filas FROM VEHICULO_NUEVO
UNION ALL SELECT 'VEHICULO_USADO' AS tabla, COUNT(*) AS filas FROM VEHICULO_USADO
UNION ALL SELECT 'ACCESORIO' AS tabla, COUNT(*) AS filas FROM ACCESORIO
UNION ALL SELECT 'VEH_ACCESORIO' AS tabla, COUNT(*) AS filas FROM VEH_ACCESORIO
UNION ALL SELECT 'VENTA' AS tabla, COUNT(*) AS filas FROM VENTA;

-- 3. Jerarquía disjunta: ningún vehículo es nuevo y usado a la vez (no debe devolver filas)
SELECT n.vin FROM VEHICULO_NUEVO n JOIN VEHICULO_USADO u ON u.vin = n.vin;

-- 4. Jerarquía total: todo vehículo es nuevo o usado (no debe devolver filas)
SELECT v.vin FROM VEHICULO v WHERE v.vin NOT IN (SELECT vin FROM VEHICULO_NUEVO) AND v.vin NOT IN (SELECT vin FROM VEHICULO_USADO);

-- 5. El valor de venta no supera el precio de lista (no debe devolver filas)
SELECT ve.numero_factura FROM VENTA ve JOIN VEHICULO v ON v.vin = ve.vin WHERE ve.valor_final > v.precio_lista;

-- 6. Nadie vende antes de entrar a la empresa (no debe devolver filas)
SELECT ve.numero_factura FROM VENTA ve JOIN VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor WHERE ve.fecha < vd.fecha_ingreso;

-- 7. Participación (1,n): en toda sede trabaja al menos un vendedor (no debe devolver filas)
SELECT s.id_sede FROM SEDE s WHERE NOT EXISTS (SELECT 1 FROM VENDEDOR v WHERE v.id_sede = s.id_sede);
