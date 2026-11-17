-- =====================================================================
--  Cadena de cines · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

-- La sala tiene sillas.
ALTER TABLE SALA
  ADD CONSTRAINT chk_sala_capacidad CHECK (capacidad > 0);

-- Tipos de sala (la regular es la que no tiene subtipo).
ALTER TABLE SALA
  ADD CONSTRAINT chk_sala_tipo CHECK (tipo IN ('regular', '3d', 'vip'));

-- Jerarquía disjunta en una sola tabla: cada tipo llena solo su columna.
ALTER TABLE SALA
  ADD CONSTRAINT chk_sala_subtipo CHECK ((tipo = 'regular' AND gafas_disponibles IS NULL AND servicio_mesero IS NULL) OR (tipo = '3d' AND gafas_disponibles IS NOT NULL AND servicio_mesero IS NULL) OR (tipo = 'vip' AND servicio_mesero IS NOT NULL AND gafas_disponibles IS NULL));

-- Clasificaciones válidas.
ALTER TABLE PELICULA
  ADD CONSTRAINT chk_pelicula_clasificacion CHECK (clasificacion IN ('T', '7+', '12+', '15+', '18+'));

-- Largometrajes de 1 a 4 horas.
ALTER TABLE PELICULA
  ADD CONSTRAINT chk_pelicula_duracion CHECK (duracion_min BETWEEN 60 AND 240);

-- El precio es positivo.
ALTER TABLE FUNCION
  ADD CONSTRAINT chk_funcion_precio CHECK (precio > 0);

-- Idiomas de proyección.
ALTER TABLE FUNCION
  ADD CONSTRAINT chk_funcion_idioma CHECK (idioma IN ('doblada', 'subtitulada', 'original'));

-- Las filas van de la A a la Z.
ALTER TABLE TIQUETE
  ADD CONSTRAINT chk_tiquete_fila CHECK (fila BETWEEN 'A' AND 'Z');

-- El valor pagado no es negativo (puede ser cortesía).
ALTER TABLE TIQUETE
  ADD CONSTRAINT chk_tiquete_valor CHECK (valor_pagado >= 0);

-- Los puntos no son negativos.
ALTER TABLE CLIENTE
  ADD CONSTRAINT chk_cliente_puntos CHECK (puntos >= 0);

-- El número de sala no se repite dentro de un cine.
ALTER TABLE SALA
  ADD CONSTRAINT uq_sala_id_cine_numero UNIQUE (id_cine, numero);

-- En una sala no hay dos funciones a la misma hora.
ALTER TABLE FUNCION
  ADD CONSTRAINT uq_funcion_id_sala_fecha_hora UNIQUE (id_sala, fecha, hora);

-- Resumen: deben aparecer 13 restricciones (10 CHECK de este script, 2 UNIQUE de este script
-- y 1 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'cines'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
