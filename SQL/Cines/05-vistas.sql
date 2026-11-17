-- =====================================================================
--  Cadena de cines · 05-vistas.sql
--  Vistas de consulta (opcional).
--  Motor: MySQL 8.0  ·  Base de datos: cines
-- =====================================================================

USE cines;

-- Cartelera con cine, sala, película y hora.
CREATE OR REPLACE VIEW v_cartelera AS
SELECT c.nombre AS cine, s.numero AS sala, s.tipo, p.titulo, f.fecha, f.hora, f.idioma, f.precio
FROM FUNCION f
JOIN SALA s ON s.id_sala = f.id_sala
JOIN CINE c ON c.id_cine = s.id_cine
JOIN PELICULA p ON p.id_pelicula = f.id_pelicula;

-- Sillas vendidas y libres por función.
CREATE OR REPLACE VIEW v_ocupacion AS
SELECT f.id_funcion, s.capacidad, COUNT(t.fila) AS vendidas, s.capacidad - COUNT(t.fila) AS libres
FROM FUNCION f
JOIN SALA s ON s.id_sala = f.id_sala
LEFT JOIN TIQUETE t ON t.id_funcion = f.id_funcion
GROUP BY f.id_funcion, s.capacidad;
