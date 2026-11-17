-- =====================================================================
--  Liga de e-sports · 04-restriccionesadicionales.sql
--  Reglas del negocio que se pueden declarar: CHECK y UNIQUE.
--  Motor: MySQL 8.0  ·  Base de datos: esports
-- =====================================================================

USE esports;

-- Roles del juego.
ALTER TABLE JUGADOR
  ADD CONSTRAINT chk_jugador_rol CHECK (rol IN ('top', 'jungla', 'medio', 'tirador', 'soporte'));

-- La experiencia no es negativa.
ALTER TABLE ENTRENADOR
  ADD CONSTRAINT chk_entrenador_experiencia CHECK (anios_experiencia >= 0);

-- El premio es positivo.
ALTER TABLE TORNEO
  ADD CONSTRAINT chk_torneo_premio CHECK (premio > 0);

-- Un equipo no juega contra sí mismo (dos roles de la misma tabla).
ALTER TABLE PARTIDA
  ADD CONSTRAINT chk_partida_rivales CHECK (id_equipo_local <> id_equipo_visitante);

-- Rondas del torneo.
ALTER TABLE PARTIDA
  ADD CONSTRAINT chk_partida_ronda CHECK (ronda IN ('grupos', 'cuartos', 'semifinal', 'final'));

-- Duración positiva.
ALTER TABLE PARTIDA
  ADD CONSTRAINT chk_partida_duracion CHECK (duracion_min > 0);

-- No hay empates.
ALTER TABLE PARTIDA
  ADD CONSTRAINT chk_partida_puntos CHECK (puntos_local >= 0 AND puntos_visitante >= 0 AND puntos_local <> puntos_visitante);

-- Las estadísticas no son negativas.
ALTER TABLE ESTADISTICA
  ADD CONSTRAINT chk_estadistica_valores CHECK (kills >= 0 AND muertes >= 0 AND asistencias >= 0);

-- Resumen: deben aparecer 10 restricciones (8 CHECK de este script, 0 UNIQUE de este script
-- y 2 UNIQUE de columna que ya venían del 01)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'esports'
  AND constraint_type IN ('CHECK', 'UNIQUE')
  AND (constraint_name LIKE 'chk%' OR constraint_name LIKE 'uq%')
ORDER BY table_name, constraint_type, constraint_name;
