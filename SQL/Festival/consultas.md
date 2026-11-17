# Consultas SQL · Festival de música

## C2 · Recuperar datos con SELECT

### Consulta 1

Escenarios con su aforo y el aforo de seguridad (80 %).

```sql
SELECT codigo, nombre, aforo, aforo * 0.8 AS aforo_seguro
FROM ESCENARIO;
```

| codigo | nombre | aforo | aforo_seguro |
|---|---|---|---|
| PRI | Escenario Principal | 20000 | 16000.00 |
| BOS | Carpa Bosque | 5000 | 4000.00 |
| ELE | Domo Electronico | 3000 | 2400.00 |

### Consulta 2

Países de donde vienen los artistas.

```sql
SELECT DISTINCT pais
FROM ARTISTA
ORDER BY pais;
```

| pais |
|---|
| Argentina |
| Chile |
| Colombia |
| Espana |
| Mexico |

## C3 · Restringir y ordenar

### Consulta 3

Programación de la jornada 2 en orden de hora.

```sql
SELECT id_artista, codigo_escenario, hora_inicio, duracion_min
FROM PRESENTACION
WHERE numero_jornada = 2
ORDER BY hora_inicio;
```

| id_artista | codigo_escenario | hora_inicio | duracion_min |
|---|---|---|---|
| 5 | BOS | 19:30:00 | 60 |
| 3 | PRI | 20:00:00 | 90 |
| 7 | ELE | 21:00:00 | 90 |

### Consulta 4

Artistas cuyo nombre artístico tiene más de una palabra.

```sql
SELECT nombre_artistico, pais
FROM ARTISTA
WHERE nombre_artistico LIKE '% %'
ORDER BY nombre_artistico;
```

| nombre_artistico | pais |
|---|---|
| DJ Kaleido | Mexico |
| Lianna Voss | Chile |
| Los Cumbiamberos del Sur | Argentina |
| Marea Alta | Colombia |
| Nube Roja | Colombia |
| Selva Electrica | Colombia |
| Tomas Riel | Espana |

### Consulta 5

Boletas compradas entre octubre y noviembre que no son abonos.

```sql
SELECT codigo, tipo, fecha_compra
FROM BOLETA
WHERE fecha_compra BETWEEN '2026-10-01' AND '2026-11-30'
  AND tipo <> 'abono'
ORDER BY fecha_compra;
```

| codigo | tipo | fecha_compra |
|---|---|---|
| B-1004 | general | 2026-10-05 |
| B-1006 | vip | 2026-11-02 |
| B-1007 | general | 2026-11-10 |

## C4 · Funciones de una sola fila

### Consulta 6

Edad de cada asistente al día de hoy (atributo derivado).

```sql
SELECT nombre, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM ASISTENTE
ORDER BY edad;
```

| nombre | fecha_nacimiento | edad |
|---|---|---|
| Sofia Montoya | 2006-02-08 | 20 |
| Kevin Duarte | 2003-12-01 | 22 |
| Natalia Pineda | 2001-04-12 | 25 |
| Julian Becerra | 1998-10-30 | 28 |
| Patricia Leal | 1979-07-21 | 47 |

### Consulta 7

Hora en que termina cada show y su duración en horas.

```sql
SELECT id_artista, numero_jornada, hora_inicio,
       ADDTIME(hora_inicio, SEC_TO_TIME(duracion_min * 60)) AS hora_fin,
       ROUND(duracion_min / 60, 1) AS horas
FROM PRESENTACION
WHERE numero_jornada = 3
ORDER BY hora_inicio;
```

| id_artista | numero_jornada | hora_inicio | hora_fin | horas |
|---|---|---|---|---|
| 6 | 3 | 17:00:00 | 18:00:00 | 1.00 |
| 1 | 3 | 19:00:00 | 20:15:00 | 1.30 |
| 4 | 3 | 20:00:00 | 22:00:00 | 2.00 |
| 2 | 3 | 21:00:00 | 22:15:00 | 1.30 |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Jornadas con la fecha en formato día/mes y el horario como texto corto.

```sql
SELECT numero, DATE_FORMAT(fecha, '%d/%m') AS dia,
       CONCAT(TIME_FORMAT(hora_apertura, '%H:%i'), ' a ', TIME_FORMAT(hora_cierre, '%H:%i')) AS horario
FROM JORNADA;
```

| numero | dia | horario |
|---|---|---|
| 1 | 27/11 | 14:00 a 23:59 |
| 2 | 28/11 | 13:00 a 23:59 |
| 3 | 29/11 | 13:00 a 22:30 |

### Consulta 9

Boletas con el nombre comercial de su tipo.

```sql
SELECT codigo,
       CASE tipo WHEN 'abono' THEN 'Pasaporte 3 dias'
                 WHEN 'vip' THEN 'Zona preferencial'
                 ELSE 'Entrada general' END AS producto,
       precio
FROM BOLETA
ORDER BY codigo;
```

| codigo | producto | precio |
|---|---|---|
| B-1001 | Pasaporte 3 dias | 650000 |
| B-1002 | Entrada general | 250000 |
| B-1003 | Zona preferencial | 480000 |
| B-1004 | Entrada general | 250000 |
| B-1005 | Pasaporte 3 dias | 650000 |
| B-1006 | Zona preferencial | 480000 |
| B-1007 | Entrada general | 250000 |

## C6 · Funciones de grupo

### Consulta 10

Boletas vendidas y recaudo por tipo.

```sql
SELECT tipo, COUNT(*) AS boletas, SUM(precio) AS recaudo
FROM BOLETA
GROUP BY tipo
ORDER BY recaudo DESC;
```

| tipo | boletas | recaudo |
|---|---|---|
| abono | 2 | 1300000 |
| vip | 2 | 960000 |
| general | 3 | 750000 |

### Consulta 11

Minutos de música por jornada, solo las que pasan de 4 horas.

```sql
SELECT numero_jornada, COUNT(*) AS shows, SUM(duracion_min) AS minutos
FROM PRESENTACION
GROUP BY numero_jornada
HAVING SUM(duracion_min) > 240
ORDER BY numero_jornada;
```

| numero_jornada | shows | minutos |
|---|---|---|
| 1 | 3 | 270 |
| 3 | 4 | 330 |

## C7 · Joins

### Consulta 12

Cartel completo: jornada, escenario y artista (join sobre la tabla de la ternaria).

```sql
SELECT j.fecha, e.nombre AS escenario, p.hora_inicio, a.nombre_artistico
FROM PRESENTACION p
JOIN JORNADA j ON j.numero = p.numero_jornada
JOIN ESCENARIO e ON e.codigo = p.codigo_escenario
JOIN ARTISTA a ON a.id_artista = p.id_artista
ORDER BY j.fecha, p.hora_inicio;
```

| fecha | escenario | hora_inicio | nombre_artistico |
|---|---|---|---|
| 2026-11-27 | Carpa Bosque | 18:00:00 | Lianna Voss |
| 2026-11-27 | Escenario Principal | 21:00:00 | Marea Alta |
| 2026-11-27 | Domo Electronico | 22:00:00 | DJ Kaleido |
| 2026-11-28 | Carpa Bosque | 19:30:00 | Nube Roja |
| 2026-11-28 | Escenario Principal | 20:00:00 | Los Cumbiamberos del Sur |
| 2026-11-28 | Domo Electronico | 21:00:00 | Selva Electrica |
| 2026-11-29 | Carpa Bosque | 17:00:00 | Tomas Riel |
| 2026-11-29 | Carpa Bosque | 19:00:00 | Marea Alta |
| 2026-11-29 | Domo Electronico | 20:00:00 | DJ Kaleido |
| 2026-11-29 | Escenario Principal | 21:00:00 | Lianna Voss |

### Consulta 13

Solistas con su instrumento (NATURAL JOIN: la única columna común es id_artista).

```sql
SELECT nombre_artistico, nombre_real, instrumento
FROM ARTISTA
NATURAL JOIN SOLISTA
ORDER BY nombre_artistico;
```

| nombre_artistico | nombre_real | instrumento |
|---|---|---|
| DJ Kaleido | Kevin Alarcon | sintetizador |
| Lianna Voss | Liliana Vasquez Soto | voz |
| Tomas Riel | Tomas Rielo Garcia | guitarra |

### Consulta 14

Cada artista con sus géneros en una sola celda.

```sql
SELECT a.nombre_artistico,
       GROUP_CONCAT(g.genero ORDER BY g.genero SEPARATOR ', ') AS generos
FROM ARTISTA a
LEFT JOIN ART_GENERO g ON g.id_artista = a.id_artista
GROUP BY a.id_artista, a.nombre_artistico
ORDER BY a.nombre_artistico;
```

| nombre_artistico | generos |
|---|---|
| DJ Kaleido | electronica, house |
| Lianna Voss | pop |
| Los Cumbiamberos del Sur | cumbia, tropical |
| Marea Alta | alternativo, rock |
| Nube Roja | rock |
| Selva Electrica | electronica, tropical |
| Tomas Riel | folk, pop |

## C8 · Subconsultas

### Consulta 15

Artistas que se presentan en más de una jornada.

```sql
SELECT nombre_artistico
FROM ARTISTA
WHERE id_artista IN (SELECT id_artista
                     FROM PRESENTACION
                     GROUP BY id_artista
                     HAVING COUNT(*) > 1)
ORDER BY nombre_artistico;
```

| nombre_artistico |
|---|
| DJ Kaleido |
| Lianna Voss |
| Marea Alta |

### Consulta 16

Shows más largos que el promedio del festival.

```sql
SELECT id_artista, numero_jornada, duracion_min
FROM PRESENTACION
WHERE duracion_min > (SELECT AVG(duracion_min) FROM PRESENTACION)
ORDER BY duracion_min DESC;
```

| id_artista | numero_jornada | duracion_min |
|---|---|---|
| 4 | 1 | 120 |
| 4 | 3 | 120 |
| 1 | 1 | 90 |
| 3 | 2 | 90 |
| 7 | 2 | 90 |

### Consulta 17

Asistentes que tienen al menos un abono.

```sql
SELECT a.nombre
FROM ASISTENTE a
WHERE EXISTS (SELECT 1 FROM BOLETA b
              WHERE b.documento_asistente = a.documento AND b.tipo = 'abono');
```

| nombre |
|---|
| Natalia Pineda |
| Patricia Leal |

## C9 · Operadores de conjunto

### Consulta 18

Artistas que tocan el primer día y también el último.

```sql
SELECT id_artista FROM PRESENTACION WHERE numero_jornada = 1
INTERSECT
SELECT id_artista FROM PRESENTACION WHERE numero_jornada = 3;
```

| id_artista |
|---|
| 1 |
| 2 |
| 4 |

### Consulta 19

Artistas que nunca han estado en el escenario principal.

```sql
SELECT id_artista FROM ARTISTA
EXCEPT
SELECT id_artista FROM PRESENTACION WHERE codigo_escenario = 'PRI';
```

| id_artista |
|---|
| 4 |
| 5 |
| 6 |
| 7 |

### Consulta 20

Ingresos esperados en la jornada 1 y en la 3, sin quitar repetidos (UNION ALL).

```sql
SELECT b.documento_asistente, bj.numero_jornada
FROM BOLETA b JOIN BOLETA_JORNADA bj ON bj.codigo_boleta = b.codigo
WHERE bj.numero_jornada = 1
UNION ALL
SELECT b.documento_asistente, bj.numero_jornada
FROM BOLETA b JOIN BOLETA_JORNADA bj ON bj.codigo_boleta = b.codigo
WHERE bj.numero_jornada = 3
ORDER BY numero_jornada, documento_asistente;
```

| documento_asistente | numero_jornada |
|---|---|
| 1007766554 | 1 |
| 1015443322 | 1 |
| 52987654 | 1 |
| 1015443322 | 3 |
| 1099887766 | 3 |
| 1122334455 | 3 |
| 52987654 | 3 |
