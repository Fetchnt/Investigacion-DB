-- =====================================================================
--  Cadena hotelera · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

-- Cada reserva con el huésped, las noches y las habitaciones.
CREATE OR REPLACE VIEW v_estadias AS
SELECT r.codigo, CONCAT(h.nombres, ' ', h.apellidos) AS huesped,
       r.fecha_entrada, r.fecha_salida,
       DATEDIFF(r.fecha_salida, r.fecha_entrada) AS noches,
       ho.nombre AS hotel, ha.numero AS habitacion, a.tarifa_noche, r.estado
FROM RESERVA r
JOIN HUESPED h ON h.documento = r.documento_huesped
JOIN ALOJAMIENTO a ON a.codigo_reserva = r.codigo
JOIN HABITACION ha ON ha.id_habitacion = a.id_habitacion
JOIN HOTEL ho ON ho.nit = ha.nit_hotel;

-- Cuenta de cada reserva: alojamiento más servicios.
CREATE OR REPLACE VIEW v_cuenta_reserva AS
SELECT r.codigo,
       DATEDIFF(r.fecha_salida, r.fecha_entrada)
         * (SELECT SUM(a.tarifa_noche) FROM ALOJAMIENTO a WHERE a.codigo_reserva = r.codigo) AS alojamiento,
       IFNULL((SELECT SUM(c.cantidad * s.precio)
               FROM CONSUMO c JOIN SERVICIO s ON s.id_servicio = c.id_servicio
               WHERE c.codigo_reserva = r.codigo), 0) AS servicios
FROM RESERVA r;
