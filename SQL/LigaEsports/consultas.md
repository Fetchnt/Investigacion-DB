# Consultas SQL · Liga de e-sports

## C2 · Recuperar datos con SELECT

### Consulta 1

Torneos con el premio total y lo que se lleva el campeón (60 %).

```sql
SELECT nombre, premio, premio * 0.6 AS premio_campeon
FROM TORNEO;
```

| nombre | premio | premio_campeon |
|---|---|---|
| Copa Andina 2026 | 50000000 | 30000000.00 |
| Liga Latina Clausura | 120000000 | 72000000.00 |
| Invitacional Bogota | 20000000 | 12000000.00 |

### Consulta 2

Roles que hay en la liga.

```sql
SELECT DISTINCT rol
FROM JUGADOR
ORDER BY rol;
```

| rol |
|---|
| jungla |
| medio |
| soporte |
| tirador |
| top |

## C3 · Restringir y ordenar

### Consulta 3

Partidas de más de 40 minutos, de la más larga a la más corta.

```sql
SELECT id_partida, fecha, ronda, duracion_min
FROM PARTIDA
WHERE duracion_min > 40
ORDER BY duracion_min DESC;
```

| id_partida | fecha | ronda | duracion_min |
|---|---|---|---|
| 7 | 2026-10-20 | final | 52 |
| 5 | 2026-10-09 | grupos | 45 |
| 2 | 2026-08-06 | grupos | 41 |

### Consulta 4

Partidas de semifinal o final del torneo 2.

```sql
SELECT id_partida, ronda, fecha
FROM PARTIDA
WHERE id_torneo = 2 AND ronda IN ('semifinal', 'final')
ORDER BY fecha;
```

| id_partida | ronda | fecha |
|---|---|---|
| 6 | semifinal | 2026-10-15 |
| 7 | final | 2026-10-20 |

### Consulta 5

Jugadores cuyo nickname empieza por K o termina en o.

```sql
SELECT nickname, nombres, apellidos
FROM JUGADOR
WHERE nickname LIKE 'K%' OR nickname LIKE '%o'
ORDER BY nickname;
```

| nickname | nombres | apellidos |
|---|---|---|
| Kmilo | Camilo | Restrepo |
| Lobo | Luis | Hernandez |
| Mako | Mario | Castillo |
| Tango | Tomas | Gimenez |

## C4 · Funciones de una sola fila

### Consulta 6

Edad de cada jugador (atributo derivado).

```sql
SELECT nickname, fecha_nacimiento, TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM JUGADOR
ORDER BY edad, nickname;
```

| nickname | fecha_nacimiento | edad |
|---|---|---|
| Rq | 2005-03-25 | 21 |
| Fakir | 2004-01-20 | 22 |
| Spark | 2004-02-18 | 22 |
| Jota | 2003-10-10 | 23 |
| Kmilo | 2003-05-12 | 23 |
| Mako | 2002-07-07 | 24 |
| Dsu | 2001-09-30 | 25 |
| Lobo | 2000-12-01 | 25 |
| Tango | 1999-06-14 | 27 |

### Consulta 7

KDA de cada jugador en cada partida (atributo derivado de la relación).

```sql
SELECT id_jugador, id_partida, kills, muertes, asistencias,
       ROUND((kills + asistencias) / GREATEST(muertes, 1), 2) AS kda
FROM ESTADISTICA
ORDER BY kda DESC, id_jugador
LIMIT 8;
```

| id_jugador | id_partida | kills | muertes | asistencias | kda |
|---|---|---|---|---|---|
| 101 | 1 | 5 | 1 | 7 | 12.00 |
| 104 | 3 | 7 | 1 | 5 | 12.00 |
| 108 | 5 | 9 | 1 | 3 | 12.00 |
| 109 | 5 | 0 | 2 | 15 | 7.50 |
| 105 | 3 | 4 | 2 | 9 | 6.50 |
| 102 | 1 | 8 | 2 | 4 | 6.00 |
| 107 | 2 | 6 | 2 | 6 | 6.00 |
| 108 | 7 | 6 | 2 | 5 | 5.50 |

### Consulta 8

Antigüedad de cada equipo en años.

```sql
SELECT nombre, fecha_fundacion, TIMESTAMPDIFF(YEAR, fecha_fundacion, CURDATE()) AS antiguedad
FROM EQUIPO
ORDER BY antiguedad DESC;
```

| nombre | fecha_fundacion | antiguedad |
|---|---|---|
| Jaguar Esports | 2017-08-22 | 9 |
| Pampa Wolves | 2018-11-03 | 8 |
| Condores Gaming | 2019-04-10 | 7 |
| Andes Rising | 2021-01-15 | 5 |

## C5 · Funciones de conversión y condicionales

### Consulta 9

Nombre de presentación del jugador: nombre, nickname entre comillas y apellido.

```sql
SELECT CONCAT(nombres, ' "', nickname, '" ', apellidos) AS presentacion, UPPER(rol) AS rol
FROM JUGADOR
ORDER BY id_equipo, nickname;
```

| presentacion | rol |
|---|---|
| Daniel "Dsu" Suarez | TIRADOR |
| Camilo "Kmilo" Restrepo | MEDIO |
| Sergio "Spark" Pena | SOPORTE |
| Luis "Lobo" Hernandez | MEDIO |
| Mario "Mako" Castillo | JUNGLA |
| Joaquin "Jota" Paz | MEDIO |
| Renzo "Rq" Quispe | TOP |
| Facundo "Fakir" Rey | SOPORTE |
| Tomas "Tango" Gimenez | TIRADOR |

### Consulta 10

Resultado de cada partida en texto.

```sql
SELECT id_partida, DATE_FORMAT(fecha, '%d/%m') AS dia,
       CASE WHEN puntos_local > puntos_visitante THEN 'gana local' ELSE 'gana visitante' END AS resultado
FROM PARTIDA
ORDER BY id_partida;
```

| id_partida | dia | resultado |
|---|---|---|
| 1 | 05/08 | gana local |
| 2 | 06/08 | gana visitante |
| 3 | 07/08 | gana local |
| 4 | 08/10 | gana local |
| 5 | 09/10 | gana visitante |
| 6 | 15/10 | gana local |
| 7 | 20/10 | gana visitante |

## C6 · Funciones de grupo

### Consulta 11

Totales por jugador, solo los que suman más de 10 kills.

```sql
SELECT id_jugador, COUNT(*) AS partidas, SUM(kills) AS kills, SUM(muertes) AS muertes, SUM(asistencias) AS asistencias
FROM ESTADISTICA
GROUP BY id_jugador
HAVING SUM(kills) > 10
ORDER BY kills DESC;
```

| id_jugador | partidas | kills | muertes | asistencias |
|---|---|---|---|---|
| 108 | 2 | 15 | 3 | 8 |
| 104 | 3 | 14 | 9 | 10 |
| 102 | 2 | 11 | 5 | 6 |

### Consulta 12

Partidas y duración promedio por torneo.

```sql
SELECT id_torneo, COUNT(*) AS partidas, ROUND(AVG(duracion_min), 1) AS duracion_promedio
FROM PARTIDA
GROUP BY id_torneo;
```

| id_torneo | partidas | duracion_promedio |
|---|---|---|
| 1 | 3 | 34.70 |
| 2 | 4 | 43.00 |

## C7 · Joins

### Consulta 13

Cada partida con el nombre del local y del visitante (EQUIPO se une dos veces, una por rol).

```sql
SELECT p.id_partida, l.nombre AS local, v.nombre AS visitante, p.puntos_local, p.puntos_visitante
FROM PARTIDA p
JOIN EQUIPO l ON l.id_equipo = p.id_equipo_local
JOIN EQUIPO v ON v.id_equipo = p.id_equipo_visitante
ORDER BY p.id_partida;
```

| id_partida | local | visitante | puntos_local | puntos_visitante |
|---|---|---|---|---|
| 1 | Condores Gaming | Jaguar Esports | 1 | 0 |
| 2 | Andes Rising | Condores Gaming | 0 | 1 |
| 3 | Jaguar Esports | Andes Rising | 1 | 0 |
| 4 | Pampa Wolves | Andes Rising | 1 | 0 |
| 5 | Condores Gaming | Pampa Wolves | 0 | 1 |
| 6 | Jaguar Esports | Condores Gaming | 1 | 0 |
| 7 | Pampa Wolves | Jaguar Esports | 0 | 1 |

### Consulta 14

Inscripciones con el equipo, que se recupera a través del entrenador (consecuencia de FNBC).

```sql
SELECT i.id_torneo, q.nombre AS equipo, e.nombres AS entrenador, i.fecha_inscripcion
FROM INSCRIPCION i
JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador
JOIN EQUIPO q ON q.id_equipo = e.id_equipo
ORDER BY i.id_torneo, q.nombre;
```

| id_torneo | equipo | entrenador | fecha_inscripcion |
|---|---|---|---|
| 1 | Andes Rising | Pedro | 2026-07-05 |
| 1 | Condores Gaming | Alejandro | 2026-07-01 |
| 1 | Jaguar Esports | Ricardo | 2026-07-03 |
| 2 | Andes Rising | Pedro | 2026-09-20 |
| 2 | Condores Gaming | Andres | 2026-09-10 |
| 2 | Jaguar Esports | Ricardo | 2026-09-12 |
| 2 | Pampa Wolves | Martin | 2026-09-15 |

### Consulta 15

Todos los torneos con su número de inscritos, incluso el que aún no tiene.

```sql
SELECT t.nombre, COUNT(i.id_entrenador) AS inscritos
FROM TORNEO t
LEFT JOIN INSCRIPCION i ON i.id_torneo = t.id_torneo
GROUP BY t.id_torneo, t.nombre
ORDER BY inscritos DESC;
```

| nombre | inscritos |
|---|---|
| Liga Latina Clausura | 4 |
| Copa Andina 2026 | 3 |
| Invitacional Bogota | 0 |

## C8 · Subconsultas

### Consulta 16

Jugadores con más kills totales que el promedio de kills por jugador.

```sql
SELECT id_jugador, SUM(kills) AS kills
FROM ESTADISTICA
GROUP BY id_jugador
HAVING SUM(kills) > (SELECT AVG(total) FROM (SELECT SUM(kills) AS total
                                              FROM ESTADISTICA
                                              GROUP BY id_jugador) x)
ORDER BY kills DESC;
```

| id_jugador | kills |
|---|---|
| 108 | 15 |
| 104 | 14 |
| 102 | 11 |
| 101 | 10 |
| 107 | 8 |

### Consulta 17

El jugador con más kills en cada partida (correlacionada).

```sql
SELECT s.id_partida, s.id_jugador, s.kills
FROM ESTADISTICA s
WHERE s.kills = (SELECT MAX(x.kills) FROM ESTADISTICA x WHERE x.id_partida = s.id_partida)
ORDER BY s.id_partida;
```

| id_partida | id_jugador | kills |
|---|---|---|
| 1 | 102 | 8 |
| 2 | 107 | 6 |
| 3 | 104 | 7 |
| 5 | 108 | 9 |
| 7 | 108 | 6 |

### Consulta 18

Equipos que nunca han ganado una partida.

```sql
SELECT nombre
FROM EQUIPO
WHERE id_equipo NOT IN (SELECT CASE WHEN puntos_local > puntos_visitante
                                  THEN id_equipo_local ELSE id_equipo_visitante END
                       FROM PARTIDA);
```

| nombre |
|---|
| Andes Rising |

## C9 · Operadores de conjunto

### Consulta 19

Plantilla completa de Cóndores: jugadores y entrenadores (UNION ALL reconstruye MIEMBRO).

```sql
SELECT id_miembro, nombres, apellidos, 'jugador' AS tipo FROM JUGADOR WHERE id_equipo = 1
UNION ALL
SELECT id_miembro, nombres, apellidos, 'entrenador' FROM ENTRENADOR WHERE id_equipo = 1
ORDER BY tipo, id_miembro;
```

| id_miembro | nombres | apellidos | tipo |
|---|---|---|---|
| 201 | Alejandro | Mora | entrenador |
| 205 | Andres | Vela | entrenador |
| 101 | Camilo | Restrepo | jugador |
| 102 | Daniel | Suarez | jugador |
| 103 | Sergio | Pena | jugador |

### Consulta 20

Equipos que jugaron los dos torneos (como local o visitante). La unión va en una tabla derivada porque INTERSECT se evalúa antes que UNION.

```sql
SELECT id_equipo
FROM (SELECT id_equipo_local AS id_equipo FROM PARTIDA WHERE id_torneo = 1
      UNION
      SELECT id_equipo_visitante FROM PARTIDA WHERE id_torneo = 1) AS copa
INTERSECT
SELECT id_equipo_local FROM PARTIDA WHERE id_torneo = 2
ORDER BY id_equipo;
```

| id_equipo |
|---|
| 1 |
| 2 |

### Consulta 21

Equipos inscritos en la Liga Latina que no estuvieron en la Copa Andina.

```sql
SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = 2
EXCEPT
SELECT e.id_equipo FROM INSCRIPCION i JOIN ENTRENADOR e ON e.id_miembro = i.id_entrenador WHERE i.id_torneo = 1;
```

| id_equipo |
|---|
| 4 |
