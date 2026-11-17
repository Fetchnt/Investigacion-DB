-- =====================================================================
--  Concesionario de vehículos · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

-- Estado de cada vehículo: disponible o vendido, con su tipo.
CREATE OR REPLACE VIEW v_inventario AS
SELECT v.vin, v.marca, v.modelo, v.anio, s.nombre AS sede,
       CASE WHEN n.vin IS NOT NULL THEN 'nuevo' ELSE 'usado' END AS tipo,
       CASE WHEN ve.vin IS NULL THEN 'disponible' ELSE 'vendido' END AS estado
FROM VEHICULO v
JOIN SEDE s ON s.id_sede = v.id_sede
LEFT JOIN VEHICULO_NUEVO n ON n.vin = v.vin
LEFT JOIN VENTA ve ON ve.vin = v.vin;

-- Comisión de cada venta.
CREATE OR REPLACE VIEW v_comisiones AS
SELECT ve.numero_factura, ve.fecha, vd.nombre AS vendedor, ve.valor_final,
       ROUND(ve.valor_final * vd.porcentaje_comision / 100, 0) AS comision
FROM VENTA ve
JOIN VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor;
