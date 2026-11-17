# Reducción a tablas · Cadena hotelera

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
| HOTEL | R1 | HOTEL(**nit**, nombre, ciudad, direccion, estrellas) |
| HABITACION · ubicar 1:N | R1 + R3 | HABITACION(**id_habitacion**, numero, piso, capacidad, tarifa_base, *nit_hotel*, …) |
| HABITACION → SUITE / ESTANDAR (disjunta, total) | R8c | Se queda en HABITACION con el discriminador tipo y los atributos de cada subtipo (metros2, jacuzzi para la suite; tipo_cama para la estándar). Un CHECK obliga a que cada fila llene solo los de su tipo |
| HUESPED (nombre compuesto) | R1 | HUESPED(**documento**, nombres, apellidos, correo, pais) |
| RESERVA · hacer 1:N | R1 + R3 | RESERVA(**codigo**, fecha_reserva, fecha_entrada, fecha_salida, estado, *documento_huesped*); noches es derivado |
| alojar RESERVA–HABITACION N:M (tarifaNoche) | R5 | ALOJAMIENTO(**codigo_reserva**, **id_habitacion**, tarifa_noche) |
| SERVICIO | R1 | SERVICIO(**id_servicio**, nombre, precio) |
| consumir RESERVA–SERVICIO N:M (fecha, cantidad) | R5 | CONSUMO(**codigo_reserva**, **id_servicio**, **fecha**, cantidad). La fecha entra a la llave porque el mismo servicio se consume varios días |

Resultado: 7 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Hotel/01-creacionobjetos.sql).
