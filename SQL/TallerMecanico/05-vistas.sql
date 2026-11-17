-- =====================================================================
--  Taller mecánico · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

-- Los empleados juntos: con «una tabla por subtipo» el supertipo se reconstruye con UNION.
CREATE OR REPLACE VIEW v_nomina AS
SELECT id_empleado, nombres, apellidos, salario, 'mecanico' AS cargo FROM MECANICO
UNION ALL
SELECT id_empleado, nombres, apellidos, salario, 'asesor' FROM ASESOR;

-- Total de cada orden (atributo derivado): repuestos más mano de obra a 60.000 la hora.
CREATE OR REPLACE VIEW v_total_orden AS
SELECT o.numero, o.placa, o.estado,
       IFNULL((SELECT SUM(r.cantidad * r.valor_unitario) FROM REPUESTO_ORDEN r WHERE r.numero_orden = o.numero), 0) AS repuestos,
       IFNULL((SELECT SUM(t.horas) FROM TRABAJO t WHERE t.numero_orden = o.numero), 0) * 60000 AS mano_obra
FROM ORDEN o;
