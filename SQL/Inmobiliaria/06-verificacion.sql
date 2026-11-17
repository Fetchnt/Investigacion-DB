-- =====================================================================
--  Agencia inmobiliaria · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: inmobiliaria
-- =====================================================================

USE inmobiliaria;

-- 1. Tablas y motor (deben ser 7 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'inmobiliaria' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'RANGO_COMISION' AS tabla, COUNT(*) AS filas FROM RANGO_COMISION
UNION ALL SELECT 'AGENTE' AS tabla, COUNT(*) AS filas FROM AGENTE
UNION ALL SELECT 'PROPIETARIO' AS tabla, COUNT(*) AS filas FROM PROPIETARIO
UNION ALL SELECT 'PROP_TELEFONO' AS tabla, COUNT(*) AS filas FROM PROP_TELEFONO
UNION ALL SELECT 'INMUEBLE' AS tabla, COUNT(*) AS filas FROM INMUEBLE
UNION ALL SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'VISITA' AS tabla, COUNT(*) AS filas FROM VISITA;

-- 3. Los rangos de comisión no se cruzan (no debe devolver filas)
SELECT r1.id_rango, r2.id_rango FROM RANGO_COMISION r1 JOIN RANGO_COMISION r2 ON r1.id_rango < r2.id_rango WHERE r1.valor_min <= r2.valor_max AND r2.valor_min <= r1.valor_max;

-- 4. Todo precio de venta cae en algún rango (no debe devolver filas)
SELECT i.matricula FROM INMUEBLE i WHERE i.en_venta = 1 AND NOT EXISTS (SELECT 1 FROM RANGO_COMISION r WHERE i.precio_venta BETWEEN r.valor_min AND r.valor_max);

-- 5. Solo se visitan inmuebles ofrecidos (no debe devolver filas)
SELECT v.matricula, v.fecha FROM VISITA v JOIN INMUEBLE i ON i.matricula = v.matricula WHERE i.en_venta = 0 AND i.en_arriendo = 0;

-- 6. Todo propietario tiene al menos un teléfono (no debe devolver filas)
SELECT p.documento FROM PROPIETARIO p WHERE NOT EXISTS (SELECT 1 FROM PROP_TELEFONO t WHERE t.documento = p.documento);

-- 7. Participación (1,n): todo propietario tiene al menos un inmueble (no debe devolver filas)
SELECT p.documento FROM PROPIETARIO p WHERE NOT EXISTS (SELECT 1 FROM INMUEBLE i WHERE i.documento_propietario = p.documento);
