# Álgebra relacional · Plataforma de cursos en línea

### Consulta 1

**π titulo, nivel, precio (CURSO)**

Título, nivel y precio de cada curso.

| titulo | nivel | precio |
|---|---|---|
| Python desde cero | basico | 120000 |
| Python para analisis de datos | intermedio | 180000 |
| SQL para principiantes | basico | 99000 |
| Optimizacion de consultas | avanzado | 250000 |
| Fundamentos de UX | basico | 110000 |
| Prototipado en Figma | intermedio | 150000 |

### Consulta 2

**σ es_estudiante = 1 ∧ es_instructor = 1 (USUARIO)**

Usuarios con los dos roles.

| id_usuario | correo | nombre | fecha_registro | pais | es_estudiante | es_instructor | nivel_educativo | profesion | biografia |
|---|---|---|---|---|---|---|---|---|---|
| 2 | lgarcia@campus.co | Lucia Garcia | 2024-03-02 | Peru | 1 | 1 | Maestria | Disenadora UX | Disenadora de producto |
| 5 | dmora@campus.co | Daniel Mora | 2024-11-30 | Colombia | 1 | 1 | Pregrado | Administrador de BD | DBA certificado |

### Consulta 3

**π id_instructor (CURSO) ∩ π id_estudiante (INSCRIPCION)**

Instructores que también estudian (requiere renombrar para que los atributos coincidan).

| id_instructor |
|---|
| 2 |
| 5 |

### Consulta 4

**π codigo (CURSO) − ρ codigo←codigo_curso (π codigo_curso (INSCRIPCION))**

Cursos sin inscritos.

| codigo |
|---|
| FIG-201 |

### Consulta 5

**π nombre, titulo (ρ e (USUARIO) ⋈ e.id_usuario = x.id_estudiante (σ progreso = 100 (INSCRIPCION) ⋈ codigo_curso = codigo CURSO))**

Quién terminó qué curso.

| nombre | titulo |
|---|---|
| Juan Perez | Python desde cero |
| Juan Perez | SQL para principiantes |
| Ana Kim | Fundamentos de UX |
| Lucia Garcia | SQL para principiantes |
| Lucia Garcia | Python desde cero |
| Sara Ruiz | SQL para principiantes |

### Consulta 6

**π codigo_curso (σ idioma = 'en' (CURSO_IDIOMA)) ∪ π codigo (σ nivel = 'avanzado' (CURSO))**

Cursos en inglés o avanzados.

| codigo_curso |
|---|
| FIG-201 |
| PY-101 |
| SQL-301 |

### Consulta 7

**π titulo, nombre (CURSO ⋈ CATEGORIA)**

Cada curso con su categoría (la reunión natural usa id_categoria, la única columna común).

| titulo | nombre |
|---|---|
| Python desde cero | Programacion |
| Python para analisis de datos | Programacion |
| SQL para principiantes | Bases de datos |
| Optimizacion de consultas | Bases de datos |
| Fundamentos de UX | Diseno |
| Prototipado en Figma | Diseno |
