-- =====================================================================
--  Cadena hotelera · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Habitaciones con su tarifa por noche y lo que costaría una semana.
SELECT id_habitacion, numero, tarifa_base, tarifa_base * 7 AS tarifa_semana
FROM HABITACION;

-- 2. Países de donde vienen los huéspedes, sin repetir.
SELECT DISTINCT pais
FROM HUESPED
ORDER BY pais;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Reservas que entran en octubre de 2026, por fecha de entrada.
SELECT codigo, fecha_entrada, fecha_salida, estado
FROM RESERVA
WHERE fecha_entrada BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY fecha_entrada;

-- 4. Habitaciones estándar para dos o más personas que cuestan menos de 300.000.
SELECT numero, nit_hotel, capacidad, tarifa_base
FROM HABITACION
WHERE tipo = 'estandar' AND capacidad >= 2 AND tarifa_base < 300000
ORDER BY tarifa_base;

-- 5. Huéspedes con correo que no termina en .com.
SELECT nombres, apellidos, correo
FROM HUESPED
WHERE correo NOT LIKE '%.com'
ORDER BY apellidos;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Noches de cada reserva (atributo derivado).
SELECT codigo, fecha_entrada, fecha_salida,
       DATEDIFF(fecha_salida, fecha_entrada) AS noches
FROM RESERVA
ORDER BY noches DESC, codigo;

-- 7. Tarifa base sin el IVA del 19 %, redondeada a pesos.
SELECT numero, nit_hotel, tarifa_base,
       ROUND(tarifa_base / 1.19, 0) AS tarifa_sin_iva
FROM HABITACION
ORDER BY tarifa_base DESC;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Detalle de cada habitación: el tipo de cama o los metros de la suite.
SELECT numero, tipo,
       COALESCE(tipo_cama, CONCAT(CAST(metros2 AS CHAR), ' m2')) AS detalle
FROM HABITACION
ORDER BY id_habitacion;

-- 9. Reservas con la fecha en formato día/mes/año y el estado explicado.
SELECT codigo, DATE_FORMAT(fecha_entrada, '%d/%m/%Y') AS entrada,
       CASE estado WHEN 'activa' THEN 'Huesped en el hotel'
                   WHEN 'confirmada' THEN 'Por llegar'
                   WHEN 'cancelada' THEN 'No se cobra'
                   ELSE 'Cerrada' END AS situacion
FROM RESERVA
ORDER BY codigo;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 10. Reservas por estado.
SELECT estado, COUNT(*) AS reservas
FROM RESERVA
GROUP BY estado
ORDER BY reservas DESC, estado;

-- 11. Servicios de los que se han consumido 3 unidades o más.
SELECT id_servicio, SUM(cantidad) AS unidades, COUNT(*) AS cargos
FROM CONSUMO
GROUP BY id_servicio
HAVING SUM(cantidad) >= 3
ORDER BY unidades DESC;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 12. Quién se alojó en qué hotel y habitación (join de cinco tablas).
SELECT r.codigo, h.apellidos, ho.ciudad, ha.numero, a.tarifa_noche
FROM RESERVA r
JOIN HUESPED h ON h.documento = r.documento_huesped
JOIN ALOJAMIENTO a ON a.codigo_reserva = r.codigo
JOIN HABITACION ha ON ha.id_habitacion = a.id_habitacion
JOIN HOTEL ho ON ho.nit = ha.nit_hotel
WHERE r.estado <> 'cancelada'
ORDER BY r.codigo, ha.numero;

-- 13. Ingreso por servicio, incluidos los que nadie ha usado (LEFT JOIN).
SELECT s.nombre, IFNULL(SUM(c.cantidad * s.precio), 0) AS ingreso
FROM SERVICIO s
LEFT JOIN CONSUMO c ON c.id_servicio = s.id_servicio
GROUP BY s.id_servicio, s.nombre
ORDER BY ingreso DESC;

-- 14. Huéspedes que han hecho más de una reserva (self join sobre RESERVA).
SELECT DISTINCT r1.documento_huesped, r1.codigo AS reserva, r2.codigo AS otra_reserva
FROM RESERVA r1
JOIN RESERVA r2 ON r2.documento_huesped = r1.documento_huesped
               AND r2.codigo > r1.codigo
ORDER BY r1.documento_huesped;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 15. Habitaciones que nunca se han reservado.
SELECT id_habitacion, numero, nit_hotel
FROM HABITACION
WHERE id_habitacion NOT IN (SELECT id_habitacion FROM ALOJAMIENTO);

-- 16. La reserva más larga.
SELECT codigo, documento_huesped, DATEDIFF(fecha_salida, fecha_entrada) AS noches
FROM RESERVA
WHERE DATEDIFF(fecha_salida, fecha_entrada) = (SELECT MAX(DATEDIFF(fecha_salida, fecha_entrada))
                                               FROM RESERVA);

-- 17. Habitaciones cuya tarifa supera el promedio de su propio hotel (subconsulta correlacionada).
SELECT h.numero, h.nit_hotel, h.tarifa_base
FROM HABITACION h
WHERE h.tarifa_base > (SELECT AVG(x.tarifa_base)
                       FROM HABITACION x
                       WHERE x.nit_hotel = h.nit_hotel)
ORDER BY h.nit_hotel;

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 18. Reservas que usaron spa o traslado (UNION quita los repetidos).
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 3
UNION
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 4
ORDER BY codigo_reserva;

-- 19. Reservas que tomaron desayuno y también traslado.
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 1
INTERSECT
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 4;

-- 20. Servicios que nunca se han consumido.
SELECT id_servicio FROM SERVICIO
EXCEPT
SELECT id_servicio FROM CONSUMO;
