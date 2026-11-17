# Reducción a tablas · Agencia inmobiliaria

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
| RANGO_COMISION | R1 | RANGO_COMISION(**id_rango**, valor_min, valor_max, porcentaje). Se cruza por rango de precio, no por FK |
| AGENTE | R1 | AGENTE(**id_agente**, nombre, telefono) |
| PROPIETARIO | R1 | PROPIETARIO(**documento**, nombre, correo) |
| PROPIETARIO.telefono (multivaluado) | R6 | PROP_TELEFONO(**documento**, **telefono**) |
| INMUEBLE (direccion compuesta) · poseer 1:N · gestionar 1:N | R1 + R3 | INMUEBLE(**matricula**, calle, numero, barrio, ciudad, tipo, area_m2, estrato, habitaciones, *documento_propietario*, *id_agente*, …) |
| INMUEBLE → EN_VENTA / EN_ARRIENDO (solapada, parcial) | R8c | Se queda en INMUEBLE con banderas en_venta, en_arriendo y los atributos de cada subtipo (precio_venta, acepta_permuta, canon_mensual, deposito). Es solapada: un inmueble puede estar en las dos |
| CLIENTE | R1 | CLIENTE(**documento**, nombre, telefono, presupuesto) |
| visitar CLIENTE–INMUEBLE N:M (fecha, hora, interes, comentario) | R5 | VISITA(**documento_cliente**, **matricula**, **fecha**, hora, interes, comentario). La fecha entra a la llave porque un cliente puede volver al mismo inmueble |

Resultado: 7 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Inmobiliaria/01-creacionobjetos.sql).
