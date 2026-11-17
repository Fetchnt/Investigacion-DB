-- =====================================================================
--  Agencia inmobiliaria · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

-- Inmuebles ofrecidos con su modalidad (jerarquía solapada).
CREATE OR REPLACE VIEW v_oferta AS
SELECT matricula, ciudad, barrio, tipo,
       CASE WHEN en_venta = 1 AND en_arriendo = 1 THEN 'venta y arriendo'
            WHEN en_venta = 1 THEN 'venta'
            WHEN en_arriendo = 1 THEN 'arriendo'
            ELSE 'no disponible' END AS modalidad,
       precio_venta, canon_mensual
FROM INMUEBLE;

-- Comisión esperada de cada inmueble en venta según la tabla de rangos (non-equijoin).
CREATE OR REPLACE VIEW v_comision AS
SELECT i.matricula, i.precio_venta, r.porcentaje,
       i.precio_venta * r.porcentaje / 100 AS comision
FROM INMUEBLE i
JOIN RANGO_COMISION r ON i.precio_venta BETWEEN r.valor_min AND r.valor_max
WHERE i.en_venta = 1;
