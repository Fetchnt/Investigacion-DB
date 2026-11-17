# Consultas SQL · Clínica veterinaria

## C2 · Recuperar datos con SELECT

### Consulta 1

Catálogo de medicamentos con el precio y el precio con IVA del 19 %.

```sql
SELECT nombre, presentacion, precio, precio * 1.19 AS precio_con_iva
FROM MEDICAMENTO;
```

| nombre | presentacion | precio | precio_con_iva |
|---|---|---|---|
| Amoxicilina 250 mg | Tabletas | 18000 | 21420.00 |
| Meloxicam 1.5 mg/ml | Suspension oral | 32000 | 38080.00 |
| Omeprazol 20 mg | Capsulas | 15000 | 17850.00 |
| Prednisolona 5 mg | Tabletas | 21000 | 24990.00 |
| Clorhexidina 2% | Solucion topica | 12500 | 14875.00 |
| Vacuna polivalente | Inyectable | 45000 | 53550.00 |

### Consulta 2

Especies distintas que atiende la clínica.

```sql
SELECT DISTINCT especie
FROM MASCOTA
ORDER BY especie;
```

| especie |
|---|
| ave |
| conejo |
| gato |
| perro |

## C3 · Restringir y ordenar

### Consulta 3

Consultas de octubre de 2026, de la más cara a la más barata.

```sql
SELECT id_consulta, fecha, motivo, valor
FROM CONSULTA
WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY valor DESC;
```

| id_consulta | fecha | motivo | valor |
|---|---|---|---|
| 6 | 2026-10-08 | Fractura de ala | 150000 |
| 7 | 2026-10-15 | Picazon constante | 110000 |
| 8 | 2026-10-22 | Vacunacion anual | 60000 |
| 5 | 2026-10-01 | Control de herida | 50000 |

### Consulta 4

Consultas que todavía no tienen diagnóstico.

```sql
SELECT id_consulta, fecha, motivo
FROM CONSULTA
WHERE diagnostico IS NULL;
```

| id_consulta | fecha | motivo |
|---|---|---|
| 6 | 2026-10-08 | Fractura de ala |

### Consulta 5

Perros y gatos cuyo nombre empieza por M.

```sql
SELECT nombre, especie, raza
FROM MASCOTA
WHERE especie IN ('perro', 'gato')
  AND nombre LIKE 'M%'
ORDER BY nombre;
```

| nombre | especie | raza |
|---|---|---|
| Max | perro | Golden retriever |
| Michi | gato | NULL |

## C4 · Funciones de una sola fila

### Consulta 6

Edad de cada mascota (el atributo derivado del MER), de la mayor a la menor.

```sql
SELECT nombre, especie, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM MASCOTA
ORDER BY edad DESC, nombre;
```

| nombre | especie | fecha_nacimiento | edad |
|---|---|---|---|
| Toby | perro | 2016-05-30 | 10 |
| Nala | gato | 2018-09-09 | 8 |
| Luna | perro | 2019-03-14 | 7 |
| Michi | gato | 2021-07-02 | 5 |
| Rocky | perro | 2020-11-20 | 5 |
| Coco | conejo | 2022-04-18 | 4 |
| Kiwi | ave | 2023-01-10 | 3 |
| Max | perro | 2024-02-25 | 2 |

### Consulta 7

Nombre del dueño en mayúsculas y las cuatro primeras letras de su apellido como código de archivo.

```sql
SELECT UPPER(CONCAT(nombres, ' ', apellidos)) AS dueno,
       SUBSTRING(apellidos, 1, 4) AS codigo_archivo
FROM DUENO
ORDER BY apellidos;
```

| dueno | codigo_archivo |
|---|---|
| MARTA CIFUENTES DIAZ | Cifu |
| LAURA GOMEZ RIOS | Gome |
| CAMILA ORTEGA PENA | Orte |
| ANDRES PARDO LEON | Pard |
| JORGE SALAMANCA RUIZ | Sala |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Consultas del cirujano con la fecha en formato día/mes/año y el diagnóstico pendiente marcado.

```sql
SELECT id_consulta,
       DATE_FORMAT(fecha, '%d/%m/%Y') AS fecha,
       IFNULL(diagnostico, 'Pendiente') AS diagnostico
FROM CONSULTA
WHERE id_veterinario = 2
ORDER BY id_consulta;
```

| id_consulta | fecha | diagnostico |
|---|---|---|
| 3 | 12/09/2026 | Laceracion leve |
| 5 | 01/10/2026 | Cicatrizacion normal |
| 6 | 08/10/2026 | Pendiente |

### Consulta 9

Clasificación de los medicamentos por precio.

```sql
SELECT nombre, precio,
       CASE WHEN precio < 15000 THEN 'Economico'
            WHEN precio < 30000 THEN 'Medio'
            ELSE 'Alto' END AS rango
FROM MEDICAMENTO
ORDER BY precio;
```

| nombre | precio | rango |
|---|---|---|
| Clorhexidina 2% | 12500 | Economico |
| Omeprazol 20 mg | 15000 | Medio |
| Amoxicilina 250 mg | 18000 | Medio |
| Prednisolona 5 mg | 21000 | Medio |
| Meloxicam 1.5 mg/ml | 32000 | Alto |
| Vacuna polivalente | 45000 | Alto |

## C6 · Funciones de grupo

### Consulta 10

Veterinarios con al menos dos consultas: cuántas, cuánto facturaron y el promedio.

```sql
SELECT id_veterinario, COUNT(*) AS consultas,
       SUM(valor) AS total, ROUND(AVG(valor), 0) AS promedio
FROM CONSULTA
GROUP BY id_veterinario
HAVING COUNT(*) >= 2
ORDER BY total DESC;
```

| id_veterinario | consultas | total | promedio |
|---|---|---|---|
| 1 | 4 | 395000 | 98750.00 |
| 2 | 3 | 320000 | 106667.00 |
| 3 | 3 | 290000 | 96667.00 |

### Consulta 11

Medicamentos más recetados y total de días de tratamiento.

```sql
SELECT codigo_medicamento, COUNT(*) AS veces, SUM(dias) AS dias_tratamiento
FROM RECETA
GROUP BY codigo_medicamento
ORDER BY veces DESC, codigo_medicamento;
```

| codigo_medicamento | veces | dias_tratamiento |
|---|---|---|
| MED-04 | 3 | 31 |
| MED-02 | 2 | 8 |
| MED-03 | 2 | 8 |
| MED-05 | 2 | 25 |
| MED-01 | 1 | 7 |

## C7 · Joins

### Consulta 12

Historia de Toby (dueña 52345678, mascota 2) con el veterinario que lo atendió.

```sql
SELECT c.fecha, c.motivo, v.nombre AS veterinario
FROM CONSULTA c
JOIN VETERINARIO v ON v.id_veterinario = c.id_veterinario
WHERE c.cedula_dueno = '52345678' AND c.numero_mascota = 2
ORDER BY c.fecha;
```

| fecha | motivo | veterinario |
|---|---|---|
| 2026-09-12 | Herida en pata | Felipe Castano |
| 2026-10-01 | Control de herida | Felipe Castano |

### Consulta 13

Teléfonos de cada dueño (JOIN con USING, porque la columna se llama igual en las dos tablas).

```sql
SELECT nombres, apellidos, telefono
FROM DUENO
JOIN DUE_TELEFONO USING (cedula)
ORDER BY apellidos, telefono;
```

| nombres | apellidos | telefono |
|---|---|---|
| Marta | Cifuentes Diaz | 3009998877 |
| Marta | Cifuentes Diaz | 3201112233 |
| Laura | Gomez Rios | 3104567890 |
| Laura | Gomez Rios | 6012345678 |
| Camila | Ortega Pena | 3186667788 |
| Andres | Pardo Leon | 3157894561 |
| Jorge | Salamanca Ruiz | 3114445566 |

### Consulta 14

Todos los veterinarios con su número de consultas, incluso los que no tienen (LEFT JOIN).

```sql
SELECT v.nombre, COUNT(c.id_consulta) AS consultas
FROM VETERINARIO v
LEFT JOIN CONSULTA c ON c.id_veterinario = v.id_veterinario
GROUP BY v.id_veterinario, v.nombre
ORDER BY consultas DESC, v.nombre;
```

| nombre | consultas |
|---|---|
| Diana Morales | 4 |
| Felipe Castano | 3 |
| Natalia Ruiz | 3 |
| Oscar Benitez | 0 |

## C8 · Subconsultas

### Consulta 15

Consultas que cuestan más que el promedio.

```sql
SELECT id_consulta, motivo, valor
FROM CONSULTA
WHERE valor > (SELECT AVG(valor) FROM CONSULTA)
ORDER BY valor DESC;
```

| id_consulta | motivo | valor |
|---|---|---|
| 10 | Intoxicacion | 180000 |
| 6 | Fractura de ala | 150000 |
| 3 | Herida en pata | 120000 |
| 4 | Caida de pelo | 110000 |
| 7 | Picazon constante | 110000 |

### Consulta 16

Medicamentos que nunca se han recetado.

```sql
SELECT m.codigo, m.nombre
FROM MEDICAMENTO m
WHERE NOT EXISTS (SELECT 1 FROM RECETA r
                  WHERE r.codigo_medicamento = m.codigo);
```

| codigo | nombre |
|---|---|
| MED-06 | Vacuna polivalente |

### Consulta 17

Mascotas que ha atendido alguien de dermatología.

```sql
SELECT nombre, especie
FROM MASCOTA
WHERE (cedula_dueno, numero) IN (SELECT cedula_dueno, numero_mascota
                                 FROM CONSULTA
                                 WHERE id_veterinario IN (SELECT id_veterinario
                                                          FROM VETERINARIO
                                                          WHERE especialidad = 'Dermatologia'));
```

| nombre | especie |
|---|---|
| Michi | gato |
| Nala | gato |

## C9 · Operadores de conjunto

### Consulta 18

Directorio de la clínica: dueños y veterinarios en una sola lista.

```sql
SELECT CONCAT(nombres, ' ', apellidos) AS nombre, 'dueno' AS rol FROM DUENO
UNION
SELECT nombre, 'veterinario' FROM VETERINARIO
ORDER BY rol, nombre;
```

| nombre | rol |
|---|---|
| Andres Pardo Leon | dueno |
| Camila Ortega Pena | dueno |
| Jorge Salamanca Ruiz | dueno |
| Laura Gomez Rios | dueno |
| Marta Cifuentes Diaz | dueno |
| Diana Morales | veterinario |
| Felipe Castano | veterinario |
| Natalia Ruiz | veterinario |
| Oscar Benitez | veterinario |

### Consulta 19

Medicamentos que se recetaron tanto en urgencias como en consultas que no lo son.

```sql
SELECT codigo_medicamento FROM RECETA
WHERE id_consulta IN (SELECT id_consulta FROM URGENCIA)
INTERSECT
SELECT codigo_medicamento FROM RECETA
WHERE id_consulta NOT IN (SELECT id_consulta FROM URGENCIA);
```

| codigo_medicamento |
|---|
| MED-05 |

### Consulta 20

Veterinarios que nunca han atendido una urgencia.

```sql
SELECT id_veterinario FROM VETERINARIO
EXCEPT
SELECT c.id_veterinario
FROM CONSULTA c JOIN URGENCIA u ON u.id_consulta = c.id_consulta;
```

| id_veterinario |
|---|
| 3 |
| 4 |
