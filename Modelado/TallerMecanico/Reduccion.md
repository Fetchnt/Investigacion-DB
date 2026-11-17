# Reducción a tablas · Taller mecánico

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
| CLIENTE | R1 | CLIENTE(**documento**, nombre, telefono, correo) |
| VEHICULO · poseer 1:N | R1 + R3 | VEHICULO(**placa**, marca, linea, modelo, color, *documento_cliente*) |
| EMPLEADO → MECANICO / ASESOR (disjunta, total; nombre compuesto) | R8b | MECANICO(**id_empleado**, nombres, apellidos, fecha_ingreso, salario, especialidad, nivel) · ASESOR(**id_empleado**, nombres, apellidos, fecha_ingreso, salario, extension, meta_mensual). Nadie referencia al empleado en general, así que no hay tabla EMPLEADO |
| supervisar MECANICO–MECANICO 1:N | R9 | SUPERVISION(**id_mecanico**, *id_supervisor*). En tabla aparte porque no todo mecánico tiene supervisor |
| ORDEN · generar 1:N · recibir 1:N | R1 + R3 | ORDEN(**numero**, fecha_ingreso, fecha_entrega, kilometraje, estado, *placa*, *id_asesor*); total es derivado |
| trabajar MECANICO–ORDEN N:M (horas, labor) | R5 | TRABAJO(**numero_orden**, **id_mecanico**, horas, labor) |
| REPUESTO | R1 | REPUESTO(**codigo**, nombre, precio_lista, stock) |
| usar ORDEN–REPUESTO N:M (cantidad, valorUnitario) | R5 | REPUESTO_ORDEN(**numero_orden**, **codigo_repuesto**, cantidad, valor_unitario) |

Resultado: 9 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/TallerMecanico/01-creacionobjetos.sql).
