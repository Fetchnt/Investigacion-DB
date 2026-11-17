-- =====================================================================
--  Taller mecánico · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: taller
-- =====================================================================

USE taller;

-- 1. Tablas y motor (deben ser 9 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'taller' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'VEHICULO' AS tabla, COUNT(*) AS filas FROM VEHICULO
UNION ALL SELECT 'MECANICO' AS tabla, COUNT(*) AS filas FROM MECANICO
UNION ALL SELECT 'ASESOR' AS tabla, COUNT(*) AS filas FROM ASESOR
UNION ALL SELECT 'SUPERVISION' AS tabla, COUNT(*) AS filas FROM SUPERVISION
UNION ALL SELECT 'ORDEN' AS tabla, COUNT(*) AS filas FROM ORDEN
UNION ALL SELECT 'TRABAJO' AS tabla, COUNT(*) AS filas FROM TRABAJO
UNION ALL SELECT 'REPUESTO' AS tabla, COUNT(*) AS filas FROM REPUESTO
UNION ALL SELECT 'REPUESTO_ORDEN' AS tabla, COUNT(*) AS filas FROM REPUESTO_ORDEN;

-- 3. Jerarquía disjunta: ningún código es mecánico y asesor a la vez (no debe devolver filas)
SELECT m.id_empleado FROM MECANICO m JOIN ASESOR a ON a.id_empleado = m.id_empleado;

-- 4. Sin ciclos de dos pasos en la supervisión (no debe devolver filas)
SELECT s1.id_mecanico FROM SUPERVISION s1 JOIN SUPERVISION s2 ON s2.id_mecanico = s1.id_supervisor WHERE s2.id_supervisor = s1.id_mecanico;

-- 5. Un junior no supervisa a nadie (no debe devolver filas)
SELECT s.id_supervisor FROM SUPERVISION s JOIN MECANICO m ON m.id_empleado = s.id_supervisor WHERE m.nivel = 'junior';

-- 6. El kilometraje de un vehículo no baja entre una orden y la siguiente (no debe devolver filas)
SELECT o2.numero FROM ORDEN o1 JOIN ORDEN o2 ON o2.placa = o1.placa AND o2.fecha_ingreso > o1.fecha_ingreso WHERE o2.kilometraje < o1.kilometraje;

-- 7. Nadie trabaja en una orden anterior a su ingreso a la empresa (no debe devolver filas)
SELECT t.numero_orden, t.id_mecanico FROM TRABAJO t JOIN ORDEN o ON o.numero = t.numero_orden JOIN MECANICO m ON m.id_empleado = t.id_mecanico WHERE o.fecha_ingreso < m.fecha_ingreso;
