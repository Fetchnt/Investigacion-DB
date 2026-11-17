-- =====================================================================
--  Empresa de mensajería · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: mensajeria
-- =====================================================================

USE mensajeria;

-- 1. Tablas y motor (deben ser 8 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'mensajeria' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'SEDE' AS tabla, COUNT(*) AS filas FROM SEDE
UNION ALL SELECT 'MENSAJERO' AS tabla, COUNT(*) AS filas FROM MENSAJERO
UNION ALL SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'ENVIO' AS tabla, COUNT(*) AS filas FROM ENVIO
UNION ALL SELECT 'PAQUETE' AS tabla, COUNT(*) AS filas FROM PAQUETE
UNION ALL SELECT 'DOCUMENTO' AS tabla, COUNT(*) AS filas FROM DOCUMENTO
UNION ALL SELECT 'ASIGNACION' AS tabla, COUNT(*) AS filas FROM ASIGNACION
UNION ALL SELECT 'SEGUIMIENTO' AS tabla, COUNT(*) AS filas FROM SEGUIMIENTO;

-- 3. Jerarquía disjunta: ninguna guía es paquete y documento (no debe devolver filas)
SELECT p.guia FROM PAQUETE p JOIN DOCUMENTO d ON d.guia = p.guia;

-- 4. Jerarquía total: toda guía es paquete o documento (no debe devolver filas)
SELECT e.guia FROM ENVIO e WHERE e.guia NOT IN (SELECT guia FROM PAQUETE) AND e.guia NOT IN (SELECT guia FROM DOCUMENTO);

-- 5. Todo envío empieza con el evento 1 'recibido' (no debe devolver filas)
SELECT e.guia FROM ENVIO e WHERE NOT EXISTS (SELECT 1 FROM SEGUIMIENTO s WHERE s.guia = e.guia AND s.consecutivo = 1 AND s.estado = 'recibido');

-- 6. Los eventos van en orden cronológico (no debe devolver filas)
SELECT s2.guia, s2.consecutivo FROM SEGUIMIENTO s1 JOIN SEGUIMIENTO s2 ON s2.guia = s1.guia AND s2.consecutivo > s1.consecutivo WHERE s2.fecha_hora < s1.fecha_hora;

-- 7. No se asigna un envío antes de recibirlo (no debe devolver filas)
SELECT a.guia FROM ASIGNACION a JOIN ENVIO e ON e.guia = a.guia WHERE a.fecha_asignacion < e.fecha_recepcion;

-- 8. Un mensajero en bicicleta no lleva paquetes de más de 10 kg (no debe devolver filas)
SELECT a.guia FROM ASIGNACION a JOIN MENSAJERO m ON m.id_mensajero = a.id_mensajero JOIN ENVIO e ON e.guia = a.guia WHERE m.vehiculo = 'bicicleta' AND e.peso_kg > 10;
