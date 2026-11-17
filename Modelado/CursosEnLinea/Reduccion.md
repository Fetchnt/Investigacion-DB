# Reducción a tablas · Plataforma de cursos en línea

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
| CATEGORIA | R1 | CATEGORIA(**id_categoria**, nombre) |
| USUARIO → ESTUDIANTE / INSTRUCTOR (solapada, total) | R8c | USUARIO(**id_usuario**, correo, nombre, fecha_registro, pais, es_estudiante, es_instructor, nivel_educativo, profesion, biografia). Es solapada: una persona puede ser las dos cosas |
| CURSO · clasificar 1:N · dictar 1:N | R1 + R3 | CURSO(**codigo**, titulo, nivel, precio, fecha_publicacion, *id_categoria*, *id_instructor*, …); numInscritos es derivado |
| FORO · tener 1:1 | R4 (fusión) | Se fusiona en CURSO como nombre_foro y foro_moderado: cada curso tiene exactamente un foro |
| CURSO.idioma (multivaluado) | R6 | CURSO_IDIOMA(**codigo_curso**, **idioma**) |
| inscribir ESTUDIANTE–CURSO N:M (fechaInscripcion, progreso, calificacion) | R5 | INSCRIPCION(**id_estudiante**, **codigo_curso**, fecha_inscripcion, progreso, calificacion) |

Resultado: 5 tablas, las mismas que crea [`01-creacionobjetos.sql`](../../SQL/CursosEnLinea/01-creacionobjetos.sql).
