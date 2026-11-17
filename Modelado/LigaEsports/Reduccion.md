# Reducción a tablas · Liga de e-sports

Paso del MER-E ([MERE-Chen.pdf](MERE-Chen.pdf)) al modelo relacional ([Relacional.pdf](Relacional.pdf)).
**Negrita** = llave primaria · *cursiva* = llave foránea.

## Reglas usadas

| Regla | Qué dice |
|---|---|
| R1 | Entidad fuerte → tabla con sus atributos simples. Los compuestos se separan en sus partes y los derivados no se guardan (se calculan). |
| R2 | Entidad débil → tabla cuya llave es la llave del dueño más el discriminador. |
| R3 | Relación 1:N → la llave del lado 1 pasa como FK al lado N. |
| R4 | Relación 1:1 → FK en el lado de participación total, o se fusionan las dos entidades. |
| R5 | Relación N:M → tabla propia; su llave junta las llaves de las dos entidades y lleva los atributos de la relación. |
| R6 | Atributo multivaluado → tabla propia (llave del dueño, valor). |
| R7 | Relación ternaria → tabla con las llaves de las tres entidades; la llave sale de las cardinalidades. |
| R8 | Especialización → (a) tabla del supertipo y una por subtipo con la misma llave; (b) solo tablas de subtipos, si es total y disjunta y nadie referencia al supertipo; (c) una sola tabla con discriminador o banderas, si los subtipos tienen pocos atributos. |
| R9 | Relación recursiva → se trata como 1:N o N:M sobre la misma tabla. |

## Reducción

| Elemento del MER-E | Regla | Tabla resultante |
|---|---|---|
| EQUIPO | R1 | EQUIPO(**id_equipo**, nombre, pais, fecha_fundacion); antiguedad es derivado |
| MIEMBRO → JUGADOR / ENTRENADOR (disjunta, total; nombre compuesto) · pertenecer 1:N | R8b + R3 | JUGADOR(**id_miembro**, nombres, apellidos, fecha_nacimiento, nickname, rol, *id_equipo*) · ENTRENADOR(**id_miembro**, nombres, apellidos, fecha_nacimiento, anios_experiencia, *id_equipo*). Cada relación apunta a un subtipo, así que no hay tabla MIEMBRO; edad es derivado |
| TORNEO | R1 | TORNEO(**id_torneo**, nombre, videojuego, fecha_inicio, premio) |
| inscribir ENTRENADOR–TORNEO N:M (fechaInscripcion) | R5 | INSCRIPCION(**id_torneo**, **id_entrenador**, fecha_inscripcion) |
| PARTIDA · organizar 1:N · jugarLocal 1:N · jugarVisita 1:N | R1 + R3 | PARTIDA(**id_partida**, fecha, ronda, duracion_min, puntos_local, puntos_visitante, *id_torneo*, *id_equipo_local*, *id_equipo_visitante*). Dos relaciones con EQUIPO dan dos FK; ganador es derivado |
| participar JUGADOR–PARTIDA N:M (kills, muertes, asistencias) | R5 | ESTADISTICA(**id_jugador**, **id_partida**, kills, muertes, asistencias); kda es derivado |

Resultado: 7 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/LigaEsports/01-creacionobjetos.sql).
