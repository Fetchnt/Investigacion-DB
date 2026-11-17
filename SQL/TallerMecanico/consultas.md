# Consultas SQL · Taller mecánico

## C2 · Recuperar datos con SELECT

### Consulta 1

Repuestos con el valor de lo que hay en bodega.

```sql
SELECT codigo, nombre, precio_lista, stock, precio_lista * stock AS valor_bodega
FROM REPUESTO;
```

| codigo | nombre | precio_lista | stock | valor_bodega |
|---|---|---|---|---|
| R-ACE-01 | Aceite 10W40 (litro) | 38000 | 40 | 1520000 |
| R-FIL-02 | Filtro de aceite | 25000 | 15 | 375000 |
| R-PAS-03 | Pastillas de freno | 145000 | 6 | 870000 |
| R-BAT-04 | Bateria 12V | 420000 | 3 | 1260000 |
| R-BUJ-05 | Bujia | 18000 | 24 | 432000 |
| R-AMO-06 | Amortiguador trasero | 260000 | 4 | 1040000 |
| R-LIQ-07 | Liquido de frenos | 22000 | 10 | 220000 |

### Consulta 2

Especialidades de los mecánicos, sin repetir.

```sql
SELECT DISTINCT especialidad
FROM MECANICO
ORDER BY especialidad;
```

| especialidad |
|---|
| Electricidad |
| Frenos y suspension |
| Latoneria |
| Motor |

## C3 · Restringir y ordenar

### Consulta 3

Órdenes que todavía no se han entregado.

```sql
SELECT numero, placa, fecha_ingreso, estado
FROM ORDEN
WHERE fecha_entrega IS NULL
ORDER BY fecha_ingreso;
```

| numero | placa | fecha_ingreso | estado |
|---|---|---|---|
| 1005 | MNO345 | 2026-11-09 | en proceso |
| 1006 | ABC123 | 2026-11-14 | recibida |

### Consulta 4

Vehículos de modelo 2018 a 2021, del más nuevo al más viejo.

```sql
SELECT placa, marca, linea, modelo
FROM VEHICULO
WHERE modelo BETWEEN 2018 AND 2021
ORDER BY modelo DESC;
```

| placa | marca | linea | modelo |
|---|---|---|---|
| GHI789 | Mazda | 3 | 2021 |
| JKL012 | Toyota | Hilux | 2019 |
| ABC123 | Renault | Logan | 2018 |

### Consulta 5

Repuestos relacionados con frenos o con el aceite.

```sql
SELECT codigo, nombre
FROM REPUESTO
WHERE nombre LIKE '%freno%' OR nombre LIKE '%aceite%'
ORDER BY codigo;
```

| codigo | nombre |
|---|---|
| R-ACE-01 | Aceite 10W40 (litro) |
| R-FIL-02 | Filtro de aceite |
| R-LIQ-07 | Liquido de frenos |
| R-PAS-03 | Pastillas de freno |

## C4 · Funciones de una sola fila

### Consulta 6

Antigüedad de los mecánicos y su salario diario.

```sql
SELECT nombres, apellidos, TIMESTAMPDIFF(YEAR, fecha_ingreso, CURDATE()) AS antiguedad,
       ROUND(salario / 30, 0) AS salario_dia
FROM MECANICO
ORDER BY antiguedad DESC;
```

| nombres | apellidos | antiguedad | salario_dia |
|---|---|---|---|
| Jairo | Mendoza Cruz | 14 | 126666.00 |
| Wilson | Ariza Pena | 8 | 86666.00 |
| Luis | Fajardo Gil | 6 | 80000.00 |
| Brayan | Caicedo Rojas | 3 | 63333.00 |
| Kevin | Ortiz Pardo | 1 | 58333.00 |

### Consulta 7

Días que estuvo cada vehículo en el taller (órdenes entregadas).

```sql
SELECT numero, placa, DATEDIFF(fecha_entrega, fecha_ingreso) AS dias
FROM ORDEN
WHERE estado = 'entregada'
ORDER BY dias DESC, numero;
```

| numero | placa | dias |
|---|---|---|
| 1002 | DEF456 | 4 |
| 1004 | JKL012 | 3 |
| 1001 | ABC123 | 1 |
| 1003 | GHI789 | 1 |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Órdenes con la fecha de entrega en formato corto o «pendiente».

```sql
SELECT numero, IFNULL(DATE_FORMAT(fecha_entrega, '%d/%m/%Y'), 'pendiente') AS entrega
FROM ORDEN
ORDER BY numero;
```

| numero | entrega |
|---|---|
| 1001 | 04/09/2026 |
| 1002 | 22/09/2026 |
| 1003 | 07/10/2026 |
| 1004 | 30/10/2026 |
| 1005 | pendiente |
| 1006 | pendiente |

### Consulta 9

Mecánicos con su nivel explicado.

```sql
SELECT nombres, nivel,
       CASE nivel WHEN 'jefe' THEN 'Jefe de taller'
                  WHEN 'senior' THEN 'Trabaja solo'
                  ELSE 'Trabaja con supervision' END AS descripcion
FROM MECANICO
ORDER BY id_empleado;
```

| nombres | nivel | descripcion |
|---|---|---|
| Jairo | jefe | Jefe de taller |
| Wilson | senior | Trabaja solo |
| Brayan | junior | Trabaja con supervision |
| Luis | senior | Trabaja solo |
| Kevin | junior | Trabaja con supervision |

## C6 · Funciones de grupo

### Consulta 10

Horas trabajadas por mecánico, solo los que pasan de 3 horas.

```sql
SELECT id_mecanico, COUNT(*) AS ordenes, SUM(horas) AS horas
FROM TRABAJO
GROUP BY id_mecanico
HAVING SUM(horas) > 3
ORDER BY horas DESC;
```

| id_mecanico | ordenes | horas |
|---|---|---|
| 102 | 2 | 7 |
| 103 | 2 | 4.00 |
| 104 | 2 | 3.50 |

### Consulta 11

Valor de repuestos de cada orden.

```sql
SELECT numero_orden, SUM(cantidad * valor_unitario) AS repuestos
FROM REPUESTO_ORDEN
GROUP BY numero_orden
ORDER BY repuestos DESC;
```

| numero_orden | repuestos |
|---|---|
| 1004 | 520000 |
| 1005 | 492000 |
| 1001 | 169000 |
| 1002 | 145000 |

## C7 · Joins

### Consulta 12

Cada mecánico con el nombre de su supervisor (self join: MECANICO aparece dos veces con alias distintos).

```sql
SELECT m.nombres AS mecanico, s.nombres AS supervisor
FROM SUPERVISION x
JOIN MECANICO m ON m.id_empleado = x.id_mecanico
JOIN MECANICO s ON s.id_empleado = x.id_supervisor
ORDER BY s.nombres, m.nombres;
```

| mecanico | supervisor |
|---|---|
| Luis | Jairo |
| Wilson | Jairo |
| Kevin | Luis |
| Brayan | Wilson |

### Consulta 13

Todos los mecánicos, tengan o no supervisor (LEFT JOIN).

```sql
SELECT m.nombres, m.nivel, x.id_supervisor
FROM MECANICO m
LEFT JOIN SUPERVISION x ON x.id_mecanico = m.id_empleado
ORDER BY m.id_empleado;
```

| nombres | nivel | id_supervisor |
|---|---|---|
| Jairo | jefe | NULL |
| Wilson | senior | 101 |
| Brayan | junior | 102 |
| Luis | senior | 101 |
| Kevin | junior | 104 |

### Consulta 14

Órdenes con el cliente dueño del vehículo y el asesor que la recibió.

```sql
SELECT o.numero, v.placa, c.nombre AS cliente, a.nombres AS asesor
FROM ORDEN o
JOIN VEHICULO v ON v.placa = o.placa
JOIN CLIENTE c ON c.documento = v.documento_cliente
JOIN ASESOR a ON a.id_empleado = o.id_asesor
ORDER BY o.numero;
```

| numero | placa | cliente | asesor |
|---|---|---|---|
| 1001 | ABC123 | Gustavo Pineda | Diana |
| 1002 | DEF456 | Liliana Torres | Diana |
| 1003 | GHI789 | Ernesto Vargas | Camilo |
| 1004 | JKL012 | Ernesto Vargas | Camilo |
| 1005 | MNO345 | Carolina Mejia | Diana |
| 1006 | ABC123 | Gustavo Pineda | Camilo |

### Consulta 15

Repuestos cobrados por debajo de su precio de lista actual (por qué el valor se guarda en la relación).

```sql
SELECT ro.numero_orden, r.nombre, ro.valor_unitario, r.precio_lista
FROM REPUESTO_ORDEN ro
JOIN REPUESTO r ON r.codigo = ro.codigo_repuesto
WHERE ro.valor_unitario < r.precio_lista;
```

| numero_orden | nombre | valor_unitario | precio_lista |
|---|---|---|---|
| 1001 | Aceite 10W40 (litro) | 36000 | 38000 |

## C8 · Subconsultas

### Consulta 16

Repuestos que nunca se han usado.

```sql
SELECT codigo, nombre
FROM REPUESTO
WHERE codigo NOT IN (SELECT codigo_repuesto FROM REPUESTO_ORDEN);
```

| codigo | nombre |
|---|---|
| R-LIQ-07 | Liquido de frenos |

### Consulta 17

Mecánicos que ganan más que el promedio de los mecánicos.

```sql
SELECT nombres, apellidos, salario
FROM MECANICO
WHERE salario > (SELECT AVG(salario) FROM MECANICO)
ORDER BY salario DESC;
```

| nombres | apellidos | salario |
|---|---|---|
| Jairo | Mendoza Cruz | 3800000 |
| Wilson | Ariza Pena | 2600000 |

### Consulta 18

Última orden de cada vehículo (subconsulta correlacionada).

```sql
SELECT o.placa, o.numero, o.fecha_ingreso
FROM ORDEN o
WHERE o.fecha_ingreso = (SELECT MAX(x.fecha_ingreso) FROM ORDEN x WHERE x.placa = o.placa)
ORDER BY o.placa;
```

| placa | numero | fecha_ingreso |
|---|---|---|
| ABC123 | 1006 | 2026-11-14 |
| DEF456 | 1002 | 2026-09-18 |
| GHI789 | 1003 | 2026-10-06 |
| JKL012 | 1004 | 2026-10-27 |
| MNO345 | 1005 | 2026-11-09 |

## C9 · Operadores de conjunto

### Consulta 19

Nómina completa: mecánicos y asesores (UNION ALL reconstruye el supertipo).

```sql
SELECT id_empleado, nombres, salario, 'mecanico' AS cargo FROM MECANICO
UNION ALL
SELECT id_empleado, nombres, salario, 'asesor' FROM ASESOR
ORDER BY salario DESC;
```

| id_empleado | nombres | salario | cargo |
|---|---|---|---|
| 101 | Jairo | 3800000 | mecanico |
| 201 | Diana | 2900000 | asesor |
| 102 | Wilson | 2600000 | mecanico |
| 104 | Luis | 2400000 | mecanico |
| 202 | Camilo | 2300000 | asesor |
| 103 | Brayan | 1900000 | mecanico |
| 105 | Kevin | 1750000 | mecanico |

### Consulta 20

Mecánicos que no supervisan a nadie.

```sql
SELECT id_empleado FROM MECANICO
EXCEPT
SELECT id_supervisor FROM SUPERVISION;
```

| id_empleado |
|---|
| 103 |
| 105 |

### Consulta 21

Mecánicos que son supervisados y también supervisan (mandos medios).

```sql
SELECT id_mecanico FROM SUPERVISION
INTERSECT
SELECT id_supervisor FROM SUPERVISION;
```

| id_mecanico |
|---|
| 102 |
| 104 |
