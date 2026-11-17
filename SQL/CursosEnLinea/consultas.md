# Consultas SQL · Plataforma de cursos en línea

## C2 · Recuperar datos con SELECT

### Consulta 1

Cursos con el precio en pesos y aproximado en dólares (a 4.000).

```sql
SELECT codigo, titulo, precio, precio / 4000 AS precio_usd
FROM CURSO;
```

| codigo | titulo | precio | precio_usd |
|---|---|---|---|
| PY-101 | Python desde cero | 120000 | 30 |
| PY-201 | Python para analisis de datos | 180000 | 45 |
| SQL-101 | SQL para principiantes | 99000 | 24 |
| SQL-301 | Optimizacion de consultas | 250000 | 62 |
| UX-101 | Fundamentos de UX | 110000 | 27 |
| FIG-201 | Prototipado en Figma | 150000 | 37 |

### Consulta 2

Países de los usuarios.

```sql
SELECT DISTINCT pais
FROM USUARIO
ORDER BY pais;
```

| pais |
|---|
| Chile |
| Colombia |
| Mexico |
| Peru |

## C3 · Restringir y ordenar

### Consulta 3

Inscripciones que van por debajo del 50 %.

```sql
SELECT id_estudiante, codigo_curso, progreso
FROM INSCRIPCION
WHERE progreso < 50
ORDER BY progreso;
```

| id_estudiante | codigo_curso | progreso |
|---|---|---|
| 7 | PY-101 | 10 |
| 6 | SQL-301 | 20 |
| 4 | PY-101 | 35 |

### Consulta 4

Usuarios que se registraron en 2026.

```sql
SELECT nombre, fecha_registro
FROM USUARIO
WHERE fecha_registro >= '2026-01-01'
ORDER BY fecha_registro;
```

| nombre | fecha_registro |
|---|---|
| Sara Ruiz | 2026-01-08 |
| Pablo Velez | 2026-06-17 |

### Consulta 5

Cursos básicos o intermedios de menos de 150.000, del más caro al más barato.

```sql
SELECT codigo, nivel, precio
FROM CURSO
WHERE nivel IN ('basico', 'intermedio') AND precio < 150000
ORDER BY precio DESC;
```

| codigo | nivel | precio |
|---|---|---|
| PY-101 | basico | 120000 |
| UX-101 | basico | 110000 |
| SQL-101 | basico | 99000 |

## C4 · Funciones de una sola fila

### Consulta 6

Meses que lleva registrado cada usuario.

```sql
SELECT nombre, fecha_registro, TIMESTAMPDIFF(MONTH, fecha_registro, CURDATE()) AS meses
FROM USUARIO
ORDER BY meses DESC;
```

| nombre | fecha_registro | meses |
|---|---|---|
| Martin Rojas | 2024-01-15 | 34 |
| Lucia Garcia | 2024-03-02 | 32 |
| Daniel Mora | 2024-11-30 | 23 |
| Juan Perez | 2025-02-10 | 21 |
| Ana Kim | 2025-05-21 | 17 |
| Sara Ruiz | 2026-01-08 | 10 |
| Pablo Velez | 2026-06-17 | 4 |

### Consulta 7

Usuario de cada correo (lo que va antes de la arroba).

```sql
SELECT correo, SUBSTRING_INDEX(correo, '@', 1) AS usuario
FROM USUARIO
ORDER BY usuario;
```

| correo | usuario |
|---|---|
| akim@campus.co | akim |
| dmora@campus.co | dmora |
| jperez@campus.co | jperez |
| lgarcia@campus.co | lgarcia |
| mrojas@campus.co | mrojas |
| pvelez@campus.co | pvelez |
| sruiz@campus.co | sruiz |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Rol de cada usuario a partir de las banderas.

```sql
SELECT nombre,
       CASE WHEN es_estudiante = 1 AND es_instructor = 1 THEN 'ambos'
            WHEN es_instructor = 1 THEN 'instructor'
            ELSE 'estudiante' END AS rol
FROM USUARIO
ORDER BY id_usuario;
```

| nombre | rol |
|---|---|
| Martin Rojas | instructor |
| Lucia Garcia | ambos |
| Juan Perez | estudiante |
| Ana Kim | estudiante |
| Daniel Mora | ambos |
| Sara Ruiz | estudiante |
| Pablo Velez | estudiante |

### Consulta 9

Inscripciones con la nota o el aviso de que el curso sigue en marcha.

```sql
SELECT id_estudiante, codigo_curso,
       IFNULL(CAST(calificacion AS CHAR), 'en curso') AS nota
FROM INSCRIPCION
ORDER BY id_estudiante, codigo_curso;
```

| id_estudiante | codigo_curso | nota |
|---|---|---|
| 2 | PY-101 | 5 |
| 2 | SQL-101 | 4.2 |
| 3 | PY-101 | 4.5 |
| 3 | PY-201 | en curso |
| 3 | SQL-101 | 4.8 |
| 4 | PY-101 | en curso |
| 4 | UX-101 | 3.9 |
| 5 | UX-101 | en curso |
| 6 | SQL-101 | 4 |
| 6 | SQL-301 | en curso |
| 7 | PY-101 | en curso |

## C6 · Funciones de grupo

### Consulta 10

Número de inscritos por curso (el atributo derivado), solo los que tienen dos o más.

```sql
SELECT codigo_curso, COUNT(*) AS inscritos
FROM INSCRIPCION
GROUP BY codigo_curso
HAVING COUNT(*) >= 2
ORDER BY inscritos DESC, codigo_curso;
```

| codigo_curso | inscritos |
|---|---|
| PY-101 | 4 |
| SQL-101 | 3 |
| UX-101 | 2 |

### Consulta 11

Por curso: inscritos, cuántos tienen nota y el promedio (AVG ignora los NULL).

```sql
SELECT codigo_curso, COUNT(*) AS inscritos, COUNT(calificacion) AS con_nota,
       ROUND(AVG(calificacion), 2) AS promedio
FROM INSCRIPCION
GROUP BY codigo_curso
ORDER BY codigo_curso;
```

| codigo_curso | inscritos | con_nota | promedio |
|---|---|---|---|
| PY-101 | 4 | 2 | 4.75 |
| PY-201 | 1 | 0 | NULL |
| SQL-101 | 3 | 3 | 4.33 |
| SQL-301 | 1 | 0 | NULL |
| UX-101 | 2 | 1 | 3.90 |

## C7 · Joins

### Consulta 12

Estudiante, curso e instructor: USUARIO se une dos veces, una por cada rol.

```sql
SELECT e.nombre AS estudiante, c.titulo, i.nombre AS instructor
FROM INSCRIPCION x
JOIN USUARIO e ON e.id_usuario = x.id_estudiante
JOIN CURSO c ON c.codigo = x.codigo_curso
JOIN USUARIO i ON i.id_usuario = c.id_instructor
ORDER BY i.nombre, e.nombre;
```

| estudiante | titulo | instructor |
|---|---|---|
| Juan Perez | SQL para principiantes | Daniel Mora |
| Lucia Garcia | SQL para principiantes | Daniel Mora |
| Sara Ruiz | SQL para principiantes | Daniel Mora |
| Sara Ruiz | Optimizacion de consultas | Daniel Mora |
| Ana Kim | Fundamentos de UX | Lucia Garcia |
| Daniel Mora | Fundamentos de UX | Lucia Garcia |
| Ana Kim | Python desde cero | Martin Rojas |
| Juan Perez | Python desde cero | Martin Rojas |
| Juan Perez | Python para analisis de datos | Martin Rojas |
| Lucia Garcia | Python desde cero | Martin Rojas |
| Pablo Velez | Python desde cero | Martin Rojas |

### Consulta 13

Categorías con su número de cursos, incluso las vacías.

```sql
SELECT g.nombre, COUNT(c.codigo) AS cursos
FROM CATEGORIA g
LEFT JOIN CURSO c ON c.id_categoria = g.id_categoria
GROUP BY g.id_categoria, g.nombre
ORDER BY cursos DESC, g.nombre;
```

| nombre | cursos |
|---|---|
| Bases de datos | 2 |
| Diseno | 2 |
| Programacion | 2 |
| Idiomas | 0 |

### Consulta 14

Inscripciones de Juan Pérez con los idiomas disponibles del curso (USING sobre codigo_curso).

```sql
SELECT codigo_curso, idioma, progreso
FROM INSCRIPCION
JOIN CURSO_IDIOMA USING (codigo_curso)
WHERE id_estudiante = 3
ORDER BY codigo_curso, idioma;
```

| codigo_curso | idioma | progreso |
|---|---|---|
| PY-101 | en | 100 |
| PY-101 | es | 100 |
| PY-201 | es | 60 |
| SQL-101 | es | 100 |
| SQL-101 | pt | 100 |

## C8 · Subconsultas

### Consulta 15

Cursos sin ningún inscrito.

```sql
SELECT codigo, titulo
FROM CURSO c
WHERE NOT EXISTS (SELECT 1 FROM INSCRIPCION x WHERE x.codigo_curso = c.codigo);
```

| codigo | titulo |
|---|---|
| FIG-201 | Prototipado en Figma |

### Consulta 16

Estudiantes que van más adelantados que el promedio de su curso (correlacionada).

```sql
SELECT x.id_estudiante, x.codigo_curso, x.progreso
FROM INSCRIPCION x
WHERE x.progreso > (SELECT AVG(y.progreso) FROM INSCRIPCION y WHERE y.codigo_curso = x.codigo_curso)
ORDER BY x.codigo_curso;
```

| id_estudiante | codigo_curso | progreso |
|---|---|---|
| 3 | PY-101 | 100 |
| 2 | PY-101 | 100 |
| 4 | UX-101 | 100 |

### Consulta 17

Instructores que también estudian en la plataforma.

```sql
SELECT nombre
FROM USUARIO
WHERE id_usuario IN (SELECT id_instructor FROM CURSO)
  AND id_usuario IN (SELECT id_estudiante FROM INSCRIPCION);
```

| nombre |
|---|
| Lucia Garcia |
| Daniel Mora |

## C9 · Operadores de conjunto

### Consulta 18

Usuarios que dictan y también estudian (confirma que la jerarquía es solapada).

```sql
SELECT id_instructor AS id_usuario FROM CURSO
INTERSECT
SELECT id_estudiante FROM INSCRIPCION;
```

| id_usuario |
|---|
| 2 |
| 5 |

### Consulta 19

Cursos que se ofrecen en inglés o que son avanzados.

```sql
SELECT codigo_curso FROM CURSO_IDIOMA WHERE idioma = 'en'
UNION
SELECT codigo FROM CURSO WHERE nivel = 'avanzado'
ORDER BY codigo_curso;
```

| codigo_curso |
|---|
| FIG-201 |
| PY-101 |
| SQL-301 |

### Consulta 20

Estudiantes que todavía no terminan ningún curso.

```sql
SELECT id_estudiante FROM INSCRIPCION
EXCEPT
SELECT id_estudiante FROM INSCRIPCION WHERE progreso = 100;
```

| id_estudiante |
|---|
| 5 |
| 7 |
