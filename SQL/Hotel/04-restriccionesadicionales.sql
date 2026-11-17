-- =====================================================================
--  Cadena hotelera · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: hotel
-- =====================================================================

USE hotel;

-- La categoría va de 1 a 5 estrellas.
ALTER TABLE HOTEL
  ADD CONSTRAINT chk_hotel_estrellas CHECK (estrellas BETWEEN 1 AND 5);

-- Solo hay dos tipos de habitación (jerarquía total).
ALTER TABLE HABITACION
  ADD CONSTRAINT chk_habitacion_tipo CHECK (tipo IN ('suite', 'estandar'));

-- Jerarquía en una sola tabla: cada fila llena solo los campos de su subtipo.
ALTER TABLE HABITACION
  ADD CONSTRAINT chk_habitacion_subtipo CHECK ((tipo = 'suite' AND metros2 IS NOT NULL AND jacuzzi IS NOT NULL AND tipo_cama IS NULL) OR (tipo = 'estandar' AND tipo_cama IS NOT NULL AND metros2 IS NULL AND jacuzzi IS NULL));

-- Capacidad razonable de una habitación.
ALTER TABLE HABITACION
  ADD CONSTRAINT chk_habitacion_capacidad CHECK (capacidad BETWEEN 1 AND 8);

-- Se sale después de entrar, y no se entra antes de reservar.
ALTER TABLE RESERVA
  ADD CONSTRAINT chk_reserva_fechas CHECK (fecha_salida > fecha_entrada AND fecha_entrada >= fecha_reserva);

-- Estados válidos de una reserva.
ALTER TABLE RESERVA
  ADD CONSTRAINT chk_reserva_estado CHECK (estado IN ('confirmada', 'activa', 'finalizada', 'cancelada'));

-- La tarifa pactada es positiva.
ALTER TABLE ALOJAMIENTO
  ADD CONSTRAINT chk_alojamiento_tarifa CHECK (tarifa_noche > 0);

-- Se consume al menos una unidad.
ALTER TABLE CONSUMO
  ADD CONSTRAINT chk_consumo_cantidad CHECK (cantidad > 0);

-- El número de habitación no se repite dentro del mismo hotel.
ALTER TABLE HABITACION
  ADD CONSTRAINT uq_habitacion_nit_hotel_numero UNIQUE (nit_hotel, numero);

-- Resumen: deben aparecer 10 restricciones (8 CHECK de este script, 1 UNIQUE de este script
-- y 1 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'hotel'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
