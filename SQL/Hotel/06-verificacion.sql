-- =====================================================================
--  Cadena hotelera · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

-- 1. Tablas y motor (deben ser 7 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'hotel' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'HOTEL' AS tabla, COUNT(*) AS filas FROM HOTEL
UNION ALL SELECT 'HABITACION' AS tabla, COUNT(*) AS filas FROM HABITACION
UNION ALL SELECT 'HUESPED' AS tabla, COUNT(*) AS filas FROM HUESPED
UNION ALL SELECT 'RESERVA' AS tabla, COUNT(*) AS filas FROM RESERVA
UNION ALL SELECT 'ALOJAMIENTO' AS tabla, COUNT(*) AS filas FROM ALOJAMIENTO
UNION ALL SELECT 'SERVICIO' AS tabla, COUNT(*) AS filas FROM SERVICIO
UNION ALL SELECT 'CONSUMO' AS tabla, COUNT(*) AS filas FROM CONSUMO;

-- 3. Participación (1,n): toda reserva tiene al menos una habitación (no debe devolver filas)
SELECT r.codigo FROM RESERVA r WHERE NOT EXISTS (SELECT 1 FROM ALOJAMIENTO a WHERE a.codigo_reserva = r.codigo);

-- 4. Los consumos caen dentro de la estadía (no debe devolver filas)
SELECT c.codigo_reserva, c.fecha FROM CONSUMO c JOIN RESERVA r ON r.codigo = c.codigo_reserva WHERE c.fecha NOT BETWEEN r.fecha_entrada AND r.fecha_salida;

-- 5. Una habitación no está en dos reservas vigentes que se crucen en fechas (no debe devolver filas)
SELECT a1.id_habitacion, r1.codigo, r2.codigo FROM ALOJAMIENTO a1 JOIN RESERVA r1 ON r1.codigo = a1.codigo_reserva JOIN ALOJAMIENTO a2 ON a2.id_habitacion = a1.id_habitacion AND a2.codigo_reserva > a1.codigo_reserva JOIN RESERVA r2 ON r2.codigo = a2.codigo_reserva WHERE r1.estado <> 'cancelada' AND r2.estado <> 'cancelada' AND r1.fecha_entrada < r2.fecha_salida AND r2.fecha_entrada < r1.fecha_salida;

-- 6. Participación (1,n): todo hotel tiene al menos una habitación (no debe devolver filas)
SELECT h.nit FROM HOTEL h WHERE NOT EXISTS (SELECT 1 FROM HABITACION x WHERE x.nit_hotel = h.nit);
