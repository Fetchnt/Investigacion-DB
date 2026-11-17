# Reducción a tablas · Concesionario de vehículos

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
| SEDE | R1 | SEDE(**id_sede**, nombre, ciudad, direccion) |
| VENDEDOR · trabajar 1:N | R1 + R3 | VENDEDOR(**id_vendedor**, nombre, porcentaje_comision, fecha_ingreso, *id_sede*); antiguedad es derivado |
| CLIENTE (nombre compuesto) | R1 | CLIENTE(**documento**, nombres, apellidos, telefono, correo) |
| VEHICULO · exhibir 1:N | R1 + R3 | VEHICULO(**vin**, marca, modelo, anio, color, precio_lista, *id_sede*) |
| VEHICULO → NUEVO / USADO (disjunta, total) | R8a | VEHICULO_NUEVO(**vin**, garantia_meses) · VEHICULO_USADO(**vin**, kilometraje, placa, num_propietarios). El supertipo se deja porque lo referencian VENTA y VEH_ACCESORIO |
| VEHICULO.accesorio (multivaluado de un catálogo) | R6 | ACCESORIO(**id_accesorio**, nombre) · VEH_ACCESORIO(**vin**, **id_accesorio**). El catálogo evita repetir el nombre del accesorio |
| VENTA · comprar 1:N · realizar 1:N · registrar 1:1 | R1 + R3 + R4 | VENTA(**numero_factura**, fecha, valor_final, forma_pago, *documento_cliente*, *id_vendedor*, *vin*). vin es UNIQUE: un vehículo se vende una sola vez |

Resultado: 9 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Concesionario/01-creacionobjetos.sql).
