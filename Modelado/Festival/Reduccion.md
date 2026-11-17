# Reducción a tablas · Festival de música

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
| ESCENARIO | R1 | ESCENARIO(**codigo**, nombre, aforo) |
| ARTISTA | R1 | ARTISTA(**id_artista**, nombre_artistico, pais) |
| ARTISTA.genero (multivaluado) | R6 | ART_GENERO(**id_artista**, **genero**) |
| ARTISTA → SOLISTA / AGRUPACION (disjunta, total) | R8a | SOLISTA(**id_artista**, nombre_real, instrumento) · AGRUPACION(**id_artista**, num_integrantes, anio_formacion). Se deja el supertipo porque lo referencian ART_GENERO y PRESENTACION |
| JORNADA | R1 | JORNADA(**numero**, fecha, hora_apertura, hora_cierre) |
| presentar ARTISTA–ESCENARIO–JORNADA (N:1:M) | R7 | PRESENTACION(**id_artista**, **numero_jornada**, *codigo_escenario*, hora_inicio, duracion_min). El escenario queda fuera de la llave: con artista y jornada ya se sabe |
| ASISTENTE | R1 | ASISTENTE(**documento**, nombre, correo, fecha_nacimiento); edad es derivado |
| BOLETA · comprar 1:N | R1 + R3 | BOLETA(**codigo**, tipo, precio, fecha_compra, *documento_asistente*) |
| habilitar BOLETA–JORNADA N:M | R5 | BOLETA_JORNADA(**codigo_boleta**, **numero_jornada**) |

Resultado: 10 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Festival/01-creacionobjetos.sql).
