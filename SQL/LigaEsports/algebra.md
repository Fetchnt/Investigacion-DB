# Álgebra relacional · Liga de e-sports

### Consulta 1

**π nickname, rol (JUGADOR)**

Nickname y rol de cada jugador.

| nickname | rol |
|---|---|
| Kmilo | medio |
| Dsu | tirador |
| Spark | soporte |
| Lobo | medio |
| Mako | jungla |
| Rq | top |
| Jota | medio |
| Tango | tirador |
| Fakir | soporte |

### Consulta 2

**σ ronda = 'grupos' ∧ duracion_min > 35 (PARTIDA)**

Partidas de grupos de más de 35 minutos.

| id_partida | fecha | ronda | duracion_min | puntos_local | puntos_visitante | id_torneo | id_equipo_local | id_equipo_visitante |
|---|---|---|---|---|---|---|---|---|
| 2 | 2026-08-06 | grupos | 41 | 0 | 1 | 1 | 3 | 1 |
| 4 | 2026-10-08 | grupos | 37 | 1 | 0 | 2 | 4 | 3 |
| 5 | 2026-10-09 | grupos | 45 | 0 | 1 | 2 | 1 | 4 |

### Consulta 3

**π id_miembro, nombres (JUGADOR) ∪ π id_miembro, nombres (ENTRENADOR)**

Todos los miembros (el supertipo que desapareció).

| id_miembro | nombres |
|---|---|
| 101 | Camilo |
| 102 | Daniel |
| 103 | Sergio |
| 104 | Luis |
| 105 | Mario |
| 106 | Renzo |
| 107 | Joaquin |
| 108 | Tomas |
| 109 | Facundo |
| 201 | Alejandro |
| 202 | Ricardo |
| 203 | Pedro |
| 204 | Martin |
| 205 | Andres |

### Consulta 4

**π id_miembro (JUGADOR) − ρ id_miembro←id_jugador (π id_jugador (ESTADISTICA ⋈ σ id_torneo = 2 (PARTIDA)))**

Jugadores sin estadísticas en la Liga Latina (torneo 2).

| id_miembro |
|---|
| 102 |
| 105 |
| 106 |
| 107 |

### Consulta 5

**π l.nombre, v.nombre (ρ l (EQUIPO) ⋈ l.id_equipo = id_equipo_local PARTIDA ⋈ id_equipo_visitante = v.id_equipo ρ v (EQUIPO))**

Local y visitante de cada partida: ρ permite usar EQUIPO dos veces.

| local | visitante |
|---|---|
| Condores Gaming | Jaguar Esports |
| Andes Rising | Condores Gaming |
| Jaguar Esports | Andes Rising |
| Pampa Wolves | Andes Rising |
| Condores Gaming | Pampa Wolves |
| Jaguar Esports | Condores Gaming |
| Pampa Wolves | Jaguar Esports |

### Consulta 6

**π id_equipo (ENTRENADOR ⋈ id_miembro = id_entrenador σ id_torneo = 1 (INSCRIPCION)) ∩ π id_equipo (ENTRENADOR ⋈ id_miembro = id_entrenador σ id_torneo = 2 (INSCRIPCION))**

Equipos inscritos en los dos torneos (el equipo sale del entrenador).

| id_equipo |
|---|
| 1 |
| 2 |
| 3 |

### Consulta 7

**π nickname, kills (JUGADOR ⋈ id_miembro = id_jugador σ id_partida = 1 (ESTADISTICA))**

Kills de cada jugador en la partida 1.

| nickname | kills |
|---|---|
| Kmilo | 5 |
| Dsu | 8 |
| Spark | 0 |
| Lobo | 3 |
| Mako | 2 |
