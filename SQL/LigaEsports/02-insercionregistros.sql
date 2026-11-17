-- =====================================================================
--  Liga de e-sports · 02-insercionregistros.sql
--  Inserta los datos de prueba en una sola transacción.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

START TRANSACTION;

-- EQUIPO (4)
INSERT INTO EQUIPO (id_equipo, nombre, pais, fecha_fundacion) VALUES
  (1, 'Condores Gaming', 'Colombia', '2019-04-10'),
  (2, 'Jaguar Esports', 'Mexico', '2017-08-22'),
  (3, 'Andes Rising', 'Peru', '2021-01-15'),
  (4, 'Pampa Wolves', 'Argentina', '2018-11-03');

-- JUGADOR (9)
INSERT INTO JUGADOR (id_miembro, nombres, apellidos, fecha_nacimiento, nickname, rol, id_equipo) VALUES
  (101, 'Camilo', 'Restrepo', '2003-05-12', 'Kmilo', 'medio', 1),
  (102, 'Daniel', 'Suarez', '2001-09-30', 'Dsu', 'tirador', 1),
  (103, 'Sergio', 'Pena', '2004-02-18', 'Spark', 'soporte', 1),
  (104, 'Luis', 'Hernandez', '2000-12-01', 'Lobo', 'medio', 2),
  (105, 'Mario', 'Castillo', '2002-07-07', 'Mako', 'jungla', 2),
  (106, 'Renzo', 'Quispe', '2005-03-25', 'Rq', 'top', 3),
  (107, 'Joaquin', 'Paz', '2003-10-10', 'Jota', 'medio', 3),
  (108, 'Tomas', 'Gimenez', '1999-06-14', 'Tango', 'tirador', 4),
  (109, 'Facundo', 'Rey', '2004-01-20', 'Fakir', 'soporte', 4);

-- ENTRENADOR (5)
INSERT INTO ENTRENADOR (id_miembro, nombres, apellidos, fecha_nacimiento, anios_experiencia, id_equipo) VALUES
  (201, 'Alejandro', 'Mora', '1990-03-03', 6, 1),
  (202, 'Ricardo', 'Lugo', '1988-08-08', 9, 2),
  (203, 'Pedro', 'Salas', '1993-11-11', 3, 3),
  (204, 'Martin', 'Ferrari', '1985-05-05', 12, 4),
  (205, 'Andres', 'Vela', '1995-02-02', 2, 1);

-- TORNEO (3)
INSERT INTO TORNEO (id_torneo, nombre, videojuego, fecha_inicio, premio) VALUES
  (1, 'Copa Andina 2026', 'League of Legends', '2026-08-01', 50000000.0),
  (2, 'Liga Latina Clausura', 'League of Legends', '2026-10-05', 120000000.0),
  (3, 'Invitacional Bogota', 'League of Legends', '2026-12-01', 20000000.0);

-- INSCRIPCION (7)
INSERT INTO INSCRIPCION (id_torneo, id_entrenador, fecha_inscripcion) VALUES
  (1, 201, '2026-07-01'),
  (1, 202, '2026-07-03'),
  (1, 203, '2026-07-05'),
  (2, 205, '2026-09-10'),
  (2, 202, '2026-09-12'),
  (2, 204, '2026-09-15'),
  (2, 203, '2026-09-20');

-- PARTIDA (7)
INSERT INTO PARTIDA (id_partida, fecha, ronda, duracion_min, puntos_local, puntos_visitante, id_torneo, id_equipo_local, id_equipo_visitante) VALUES
  (1, '2026-08-05', 'grupos', 34, 1, 0, 1, 1, 2),
  (2, '2026-08-06', 'grupos', 41, 0, 1, 1, 3, 1),
  (3, '2026-08-07', 'grupos', 29, 1, 0, 1, 2, 3),
  (4, '2026-10-08', 'grupos', 37, 1, 0, 2, 4, 3),
  (5, '2026-10-09', 'grupos', 45, 0, 1, 2, 1, 4),
  (6, '2026-10-15', 'semifinal', 38, 1, 0, 2, 2, 1),
  (7, '2026-10-20', 'final', 52, 0, 1, 2, 4, 2);

-- ESTADISTICA (20)
INSERT INTO ESTADISTICA (id_jugador, id_partida, kills, muertes, asistencias) VALUES
  (101, 1, 5, 1, 7),
  (102, 1, 8, 2, 4),
  (103, 1, 0, 3, 14),
  (104, 1, 3, 4, 2),
  (105, 1, 2, 5, 3),
  (106, 2, 4, 3, 5),
  (107, 2, 6, 2, 6),
  (101, 2, 2, 4, 3),
  (102, 2, 3, 3, 2),
  (104, 3, 7, 1, 5),
  (105, 3, 4, 2, 9),
  (106, 3, 1, 5, 2),
  (107, 3, 2, 4, 3),
  (101, 5, 3, 3, 4),
  (103, 5, 1, 4, 6),
  (108, 5, 9, 1, 3),
  (109, 5, 0, 2, 15),
  (108, 7, 6, 2, 5),
  (109, 7, 1, 3, 11),
  (104, 7, 4, 4, 3);

COMMIT;
