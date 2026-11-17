# Reducción a tablas · Cadena de cines

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
| CINE (direccion compuesta) | R1 | CINE(**id_cine**, nombre, ciudad, calle, numero, barrio) |
| CINE.telefono (multivaluado) | R6 | CINE_TELEFONO(**id_cine**, **telefono**) |
| SALA · tener 1:N | R1 + R3 | SALA(**id_sala**, numero, capacidad, *id_cine*, …) |
| SALA → SALA_3D / SALA_VIP (disjunta, parcial) | R8c | Se queda en SALA con el discriminador tipo y un atributo por subtipo (gafas_disponibles, servicio_mesero) |
| PELICULA | R1 | PELICULA(**id_pelicula**, titulo, titulo_original, duracion_min, clasificacion, fecha_estreno) |
| FUNCION · programar 1:N · proyectar 1:N | R1 + R3 | FUNCION(**id_funcion**, fecha, hora, precio, idioma, *id_sala*, *id_pelicula*) |
| CLIENTE (nombre compuesto) | R1 | CLIENTE(**documento**, nombres, apellidos, correo, puntos) |
| comprar CLIENTE–FUNCION N:M (silla, valorPagado) | R5 | TIQUETE(**id_funcion**, **fila**, **numero_silla**, *documento_cliente*, valor_pagado). La llave es la silla dentro de la función: una silla no se vende dos veces |

Resultado: 7 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Cines/01-creacionobjetos.sql).
