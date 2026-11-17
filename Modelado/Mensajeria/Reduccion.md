# Reducción a tablas · Empresa de mensajería

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
| SEDE | R1 | SEDE(**id_sede**, ciudad, direccion, telefono) |
| MENSAJERO · pertenecer 1:N | R1 + R3 | MENSAJERO(**id_mensajero**, nombre, licencia, vehiculo, *id_sede*) |
| CLIENTE | R1 | CLIENTE(**nit**, razon_social, telefono, correo) |
| ENVIO · enviar 1:N · recibir 1:N | R1 + R3 | ENVIO(**guia**, fecha_recepcion, peso_kg, valor_declarado, costo, destinatario, direccion_destino, ciudad_destino, *nit_cliente*, *id_sede_origen*) |
| ENVIO → PAQUETE / DOCUMENTO (disjunta, total) | R8a | PAQUETE(**guia**, alto_cm, ancho_cm, largo_cm, fragil) · DOCUMENTO(**guia**, num_folios, certificado). El supertipo se deja porque lo referencian SEGUIMIENTO y ASIGNACION |
| asignar MENSAJERO–ENVIO 1:N, opcional (fechaAsignacion) | R3 en tabla aparte | ASIGNACION(**guia**, *id_mensajero*, fecha_asignacion). Un envío recién recibido no tiene mensajero: con tabla aparte no quedan FK nulas |
| SEGUIMIENTO (débil) · registrar | R2 | SEGUIMIENTO(**guia**, **consecutivo**, fecha_hora, estado, observacion) |

Resultado: 8 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Mensajeria/01-creacionobjetos.sql).
