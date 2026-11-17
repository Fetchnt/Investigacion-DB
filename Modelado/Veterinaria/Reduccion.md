# Reducción a tablas · Clínica veterinaria

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
| DUENO (nombre compuesto) | R1 | DUENO(**cedula**, nombres, apellidos, direccion, correo) |
| DUENO.telefono (multivaluado) | R6 | DUE_TELEFONO(**cedula**, **telefono**) |
| MASCOTA (débil, discriminador numero) · tener 1:N | R2 | MASCOTA(**cedula_dueno**, **numero**, nombre, especie, raza, fecha_nacimiento); edad es derivado y no se guarda |
| VETERINARIO | R1 | VETERINARIO(**id_veterinario**, nombre, tarjeta_profesional, especialidad) |
| CONSULTA · recibir 1:N · atender 1:N | R1 + R3 | CONSULTA(**id_consulta**, fecha, motivo, diagnostico, valor, *cedula_dueno*, *numero_mascota*, *id_veterinario*) |
| MEDICAMENTO | R1 | MEDICAMENTO(**codigo**, nombre, presentacion, precio) |
| recetar N:M (dosis, dias) | R5 | RECETA(**id_consulta**, **codigo_medicamento**, dosis, dias) |
| CONSULTA → URGENCIA / CONTROL (disjunta, parcial) | R8a | URGENCIA(**id_consulta**, nivel_triage) · CONTROL(**id_consulta**, fecha_proximo_control). Es parcial: una consulta general no aparece en ninguna |

Resultado: 9 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/Veterinaria/01-creacionobjetos.sql).
