-- =====================================================================
--  Cadena de cines · 06-verificacion.sql
--  Verificación de solo lectura: estructura, conteos y reglas que un CHECK no alcanza.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

-- 1. Tablas y motor (deben ser 7 InnoDB)
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'cines' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. Registros por tabla
SELECT 'CINE' AS tabla, COUNT(*) AS filas FROM CINE
UNION ALL SELECT 'CINE_TELEFONO' AS tabla, COUNT(*) AS filas FROM CINE_TELEFONO
UNION ALL SELECT 'SALA' AS tabla, COUNT(*) AS filas FROM SALA
UNION ALL SELECT 'PELICULA' AS tabla, COUNT(*) AS filas FROM PELICULA
UNION ALL SELECT 'FUNCION' AS tabla, COUNT(*) AS filas FROM FUNCION
UNION ALL SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'TIQUETE' AS tabla, COUNT(*) AS filas FROM TIQUETE;

-- 3. Ninguna función vende más sillas que la capacidad de la sala (no debe devolver filas)
SELECT f.id_funcion FROM FUNCION f JOIN SALA s ON s.id_sala = f.id_sala JOIN TIQUETE t ON t.id_funcion = f.id_funcion GROUP BY f.id_funcion, s.capacidad HAVING COUNT(*) > s.capacidad;

-- 4. Ninguna función es anterior al estreno de la película (no debe devolver filas)
SELECT f.id_funcion FROM FUNCION f JOIN PELICULA p ON p.id_pelicula = f.id_pelicula WHERE f.fecha < p.fecha_estreno;

-- 5. Nadie paga más que el precio de la función (no debe devolver filas)
SELECT t.id_funcion, t.fila, t.numero_silla FROM TIQUETE t JOIN FUNCION f ON f.id_funcion = t.id_funcion WHERE t.valor_pagado > f.precio;

-- 6. Participación (1,n): todo cine tiene al menos una sala (no debe devolver filas)
SELECT c.id_cine FROM CINE c WHERE NOT EXISTS (SELECT 1 FROM SALA s WHERE s.id_cine = c.id_cine);
