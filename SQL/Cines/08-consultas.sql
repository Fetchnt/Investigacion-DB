-- =====================================================================
--  Cadena de cines · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Funciones con su precio y el precio para afiliados (20 % menos).
SELECT id_funcion, fecha, hora, precio, precio * 0.8 AS precio_afiliado
FROM FUNCION;

-- 2. Ciudades donde hay cines.
SELECT DISTINCT ciudad
FROM CINE;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Funciones del 14 de noviembre que empiezan a las 17:00 o después.
SELECT id_funcion, hora, id_pelicula, idioma
FROM FUNCION
WHERE fecha = '2026-11-14' AND hora >= '17:00:00'
ORDER BY hora;

-- 4. Películas para mayores de 12 o de 15 que duran más de 100 minutos.
SELECT titulo, clasificacion, duracion_min
FROM PELICULA
WHERE clasificacion IN ('12+', '15+') AND duracion_min > 100
ORDER BY duracion_min DESC;

-- 5. Películas nacionales (sin título original).
SELECT titulo, fecha_estreno
FROM PELICULA
WHERE titulo_original IS NULL
ORDER BY fecha_estreno;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Dirección completa de cada cine, armada con las hojas del atributo compuesto.
SELECT nombre, CONCAT(calle, ' # ', numero, ', ', barrio, ', ', ciudad) AS direccion
FROM CINE;

-- 7. Duración de cada película en horas y minutos.
SELECT titulo, duracion_min,
       CONCAT(duracion_min DIV 60, 'h ', MOD(duracion_min, 60), 'min') AS duracion
FROM PELICULA
ORDER BY duracion_min;

-- 8. Días que lleva cada película en cartelera.
SELECT titulo, fecha_estreno, DATEDIFF(CURDATE(), fecha_estreno) AS dias_en_cartelera
FROM PELICULA
ORDER BY dias_en_cartelera DESC;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 9. Funciones con fecha y hora en formato corto.
SELECT id_funcion, DATE_FORMAT(fecha, '%d/%m/%Y') AS dia, TIME_FORMAT(hora, '%H:%i') AS hora_corta
FROM FUNCION
ORDER BY id_funcion;

-- 10. Título para la taquilla: el original si existe, si no el título en español.
SELECT id_pelicula, IFNULL(titulo_original, titulo) AS titulo_taquilla
FROM PELICULA;

-- 11. Descripción de cada sala según su tipo.
SELECT id_sala, tipo,
       CASE tipo WHEN '3d' THEN CONCAT('3D con ', gafas_disponibles, ' gafas')
                 WHEN 'vip' THEN IF(servicio_mesero = 1, 'VIP con mesero', 'VIP sin mesero')
                 ELSE 'Regular' END AS descripcion
FROM SALA
ORDER BY id_sala;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 12. Funciones que han recaudado más de 30.000.
SELECT id_funcion, COUNT(*) AS sillas, SUM(valor_pagado) AS recaudo
FROM TIQUETE
GROUP BY id_funcion
HAVING SUM(valor_pagado) > 30000
ORDER BY recaudo DESC;

-- 13. Capacidad total y promedio por tipo de sala.
SELECT tipo, COUNT(*) AS salas, SUM(capacidad) AS sillas, ROUND(AVG(capacidad), 1) AS promedio
FROM SALA
GROUP BY tipo
ORDER BY sillas DESC;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 14. Tiquetes con el cliente, la película y el cine.
SELECT cl.apellidos, p.titulo, c.nombre AS cine, t.fila, t.numero_silla
FROM TIQUETE t
JOIN CLIENTE cl ON cl.documento = t.documento_cliente
JOIN FUNCION f ON f.id_funcion = t.id_funcion
JOIN PELICULA p ON p.id_pelicula = f.id_pelicula
JOIN SALA s ON s.id_sala = f.id_sala
JOIN CINE c ON c.id_cine = s.id_cine
ORDER BY cl.apellidos, t.fila, t.numero_silla;

-- 15. Salas con el nombre de su cine (USING sobre id_cine; `numero` existe en las dos tablas, por eso se califica).
SELECT c.nombre, s.numero, s.tipo, s.capacidad
FROM SALA s
JOIN CINE c USING (id_cine)
ORDER BY c.nombre, s.numero;

-- 16. Películas con su número de funciones, incluso las que no tienen.
SELECT p.titulo, COUNT(f.id_funcion) AS funciones
FROM PELICULA p
LEFT JOIN FUNCION f ON f.id_pelicula = p.id_pelicula
GROUP BY p.id_pelicula, p.titulo
ORDER BY funciones DESC, p.titulo;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 17. Clientes que nunca han comprado.
SELECT documento, nombres, apellidos
FROM CLIENTE
WHERE documento NOT IN (SELECT documento_cliente FROM TIQUETE);

-- 18. Funciones más caras que el promedio de su propia película (correlacionada).
SELECT f.id_funcion, f.id_pelicula, f.precio
FROM FUNCION f
WHERE f.precio > (SELECT AVG(x.precio) FROM FUNCION x WHERE x.id_pelicula = f.id_pelicula)
ORDER BY f.id_pelicula;

-- 19. La película que más tiquetes ha vendido.
SELECT p.titulo, COUNT(*) AS tiquetes
FROM TIQUETE t
JOIN FUNCION f ON f.id_funcion = t.id_funcion
JOIN PELICULA p ON p.id_pelicula = f.id_pelicula
GROUP BY p.id_pelicula, p.titulo
HAVING COUNT(*) = (SELECT MAX(n) FROM (SELECT COUNT(*) AS n
                                       FROM TIQUETE t2
                                       JOIN FUNCION f2 ON f2.id_funcion = t2.id_funcion
                                       GROUP BY f2.id_pelicula) x);

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 20. Clientes que han ido a una sala 3D y también a una VIP.
SELECT t.documento_cliente FROM TIQUETE t JOIN FUNCION f ON f.id_funcion = t.id_funcion JOIN SALA s ON s.id_sala = f.id_sala WHERE s.tipo = '3d'
INTERSECT
SELECT t.documento_cliente FROM TIQUETE t JOIN FUNCION f ON f.id_funcion = t.id_funcion JOIN SALA s ON s.id_sala = f.id_sala WHERE s.tipo = 'vip';

-- 21. Películas que se proyectan en Bogotá pero no en Medellín.
SELECT f.id_pelicula FROM FUNCION f JOIN SALA s ON s.id_sala = f.id_sala JOIN CINE c ON c.id_cine = s.id_cine WHERE c.ciudad = 'Bogota'
EXCEPT
SELECT f.id_pelicula FROM FUNCION f JOIN SALA s ON s.id_sala = f.id_sala JOIN CINE c ON c.id_cine = s.id_cine WHERE c.ciudad = 'Medellin';

-- 22. Directorio de contactos: teléfonos de los cines y correos de los clientes.
SELECT CONCAT('Cine ', id_cine) AS quien, telefono AS contacto FROM CINE_TELEFONO
UNION
SELECT apellidos, correo FROM CLIENTE
ORDER BY quien;
