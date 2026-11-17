# Consultas SQL · Cadena de cines

## C2 · Recuperar datos con SELECT

### Consulta 1

Funciones con su precio y el precio para afiliados (20 % menos).

```sql
SELECT id_funcion, fecha, hora, precio, precio * 0.8 AS precio_afiliado
FROM FUNCION;
```

| id_funcion | fecha | hora | precio | precio_afiliado |
|---|---|---|---|---|
| 1 | 2026-11-13 | 16:00:00 | 14000 | 11200.00 |
| 2 | 2026-11-13 | 19:30:00 | 16000 | 12800.00 |
| 3 | 2026-11-13 | 21:00:00 | 32000 | 25600.00 |
| 4 | 2026-11-14 | 15:00:00 | 15000 | 12000.00 |
| 5 | 2026-11-14 | 20:00:00 | 18000 | 14400.00 |
| 6 | 2026-11-14 | 18:00:00 | 13000 | 10400.00 |
| 7 | 2026-11-15 | 20:30:00 | 28000 | 22400.00 |
| 8 | 2026-11-15 | 17:00:00 | 12000 | 9600.00 |

### Consulta 2

Ciudades donde hay cines.

```sql
SELECT DISTINCT ciudad
FROM CINE;
```

| ciudad |
|---|
| Bogota |
| Medellin |

## C3 · Restringir y ordenar

### Consulta 3

Funciones del 14 de noviembre que empiezan a las 17:00 o después.

```sql
SELECT id_funcion, hora, id_pelicula, idioma
FROM FUNCION
WHERE fecha = '2026-11-14' AND hora >= '17:00:00'
ORDER BY hora;
```

| id_funcion | hora | id_pelicula | idioma |
|---|---|---|---|
| 6 | 18:00:00 | 1 | original |
| 5 | 20:00:00 | 2 | doblada |

### Consulta 4

Películas para mayores de 12 o de 15 que duran más de 100 minutos.

```sql
SELECT titulo, clasificacion, duracion_min
FROM PELICULA
WHERE clasificacion IN ('12+', '15+') AND duracion_min > 100
ORDER BY duracion_min DESC;
```

| titulo | clasificacion | duracion_min |
|---|---|---|
| Orbita cero | 12+ | 138 |
| El faro del sur | 12+ | 112 |
| La casa del silencio | 15+ | 104 |

### Consulta 5

Películas nacionales (sin título original).

```sql
SELECT titulo, fecha_estreno
FROM PELICULA
WHERE titulo_original IS NULL
ORDER BY fecha_estreno;
```

| titulo | fecha_estreno |
|---|---|
| El faro del sur | 2026-10-02 |
| Cumbia para dos | 2026-11-13 |

## C4 · Funciones de una sola fila

### Consulta 6

Dirección completa de cada cine, armada con las hojas del atributo compuesto.

```sql
SELECT nombre, CONCAT(calle, ' # ', numero, ', ', barrio, ', ', ciudad) AS direccion
FROM CINE;
```

| nombre | direccion |
|---|---|
| CineArte Centro | Cll 24 # 5-60, La Candelaria, Bogota |
| CineArte Norte | Av 19 # 120-71, Santa Barbara, Bogota |
| CineArte Laureles | Cra 76 # 33-10, Laureles, Medellin |

### Consulta 7

Duración de cada película en horas y minutos.

```sql
SELECT titulo, duracion_min,
       CONCAT(duracion_min DIV 60, 'h ', MOD(duracion_min, 60), 'min') AS duracion
FROM PELICULA
ORDER BY duracion_min;
```

| titulo | duracion_min | duracion |
|---|---|---|
| Pequenos gigantes | 95 | 1h 35min |
| Cumbia para dos | 101 | 1h 41min |
| La casa del silencio | 104 | 1h 44min |
| El faro del sur | 112 | 1h 52min |
| Orbita cero | 138 | 2h 18min |

### Consulta 8

Días que lleva cada película en cartelera.

```sql
SELECT titulo, fecha_estreno, DATEDIFF(CURDATE(), fecha_estreno) AS dias_en_cartelera
FROM PELICULA
ORDER BY dias_en_cartelera DESC;
```

| titulo | fecha_estreno | dias_en_cartelera |
|---|---|---|
| El faro del sur | 2026-10-02 | 45 |
| Orbita cero | 2026-10-16 | 31 |
| Pequenos gigantes | 2026-10-30 | 17 |
| La casa del silencio | 2026-11-06 | 10 |
| Cumbia para dos | 2026-11-13 | 3 |

## C5 · Funciones de conversión y condicionales

### Consulta 9

Funciones con fecha y hora en formato corto.

```sql
SELECT id_funcion, DATE_FORMAT(fecha, '%d/%m/%Y') AS dia, TIME_FORMAT(hora, '%H:%i') AS hora_corta
FROM FUNCION
ORDER BY id_funcion;
```

| id_funcion | dia | hora_corta |
|---|---|---|
| 1 | 13/11/2026 | 16:00 |
| 2 | 13/11/2026 | 19:30 |
| 3 | 13/11/2026 | 21:00 |
| 4 | 14/11/2026 | 15:00 |
| 5 | 14/11/2026 | 20:00 |
| 6 | 14/11/2026 | 18:00 |
| 7 | 15/11/2026 | 20:30 |
| 8 | 15/11/2026 | 17:00 |

### Consulta 10

Título para la taquilla: el original si existe, si no el título en español.

```sql
SELECT id_pelicula, IFNULL(titulo_original, titulo) AS titulo_taquilla
FROM PELICULA;
```

| id_pelicula | titulo_taquilla |
|---|---|
| 1 | El faro del sur |
| 2 | Zero Orbit |
| 3 | Little Giants |
| 4 | The Silent House |
| 5 | Cumbia para dos |

### Consulta 11

Descripción de cada sala según su tipo.

```sql
SELECT id_sala, tipo,
       CASE tipo WHEN '3d' THEN CONCAT('3D con ', gafas_disponibles, ' gafas')
                 WHEN 'vip' THEN IF(servicio_mesero = 1, 'VIP con mesero', 'VIP sin mesero')
                 ELSE 'Regular' END AS descripcion
FROM SALA
ORDER BY id_sala;
```

| id_sala | tipo | descripcion |
|---|---|---|
| 1 | regular | Regular |
| 2 | 3d | 3D con 120 gafas |
| 3 | regular | Regular |
| 4 | vip | VIP con mesero |
| 5 | 3d | 3D con 140 gafas |
| 6 | regular | Regular |
| 7 | vip | VIP sin mesero |

## C6 · Funciones de grupo

### Consulta 12

Funciones que han recaudado más de 30.000.

```sql
SELECT id_funcion, COUNT(*) AS sillas, SUM(valor_pagado) AS recaudo
FROM TIQUETE
GROUP BY id_funcion
HAVING SUM(valor_pagado) > 30000
ORDER BY recaudo DESC;
```

| id_funcion | sillas | recaudo |
|---|---|---|
| 3 | 2 | 64000 |
| 4 | 3 | 45000 |
| 1 | 3 | 35000 |

### Consulta 13

Capacidad total y promedio por tipo de sala.

```sql
SELECT tipo, COUNT(*) AS salas, SUM(capacidad) AS sillas, ROUND(AVG(capacidad), 1) AS promedio
FROM SALA
GROUP BY tipo
ORDER BY sillas DESC;
```

| tipo | salas | sillas | promedio |
|---|---|---|---|
| regular | 3 | 560 | 186.70 |
| 3d | 2 | 260 | 130.00 |
| vip | 2 | 108 | 54.00 |

## C7 · Joins

### Consulta 14

Tiquetes con el cliente, la película y el cine.

```sql
SELECT cl.apellidos, p.titulo, c.nombre AS cine, t.fila, t.numero_silla
FROM TIQUETE t
JOIN CLIENTE cl ON cl.documento = t.documento_cliente
JOIN FUNCION f ON f.id_funcion = t.id_funcion
JOIN PELICULA p ON p.id_pelicula = f.id_pelicula
JOIN SALA s ON s.id_sala = f.id_sala
JOIN CINE c ON c.id_cine = s.id_cine
ORDER BY cl.apellidos, t.fila, t.numero_silla;
```

| apellidos | titulo | cine | fila | numero_silla |
|---|---|---|---|---|
| Castillo Pena | La casa del silencio | CineArte Norte | B | 3 |
| Castillo Pena | La casa del silencio | CineArte Norte | B | 4 |
| Castillo Pena | El faro del sur | CineArte Laureles | C | 12 |
| Guzman Toro | Orbita cero | CineArte Centro | D | 10 |
| Guzman Toro | Orbita cero | CineArte Norte | E | 5 |
| Molina Rey | La casa del silencio | CineArte Laureles | A | 1 |
| Molina Rey | Pequenos gigantes | CineArte Centro | F | 7 |
| Molina Rey | Pequenos gigantes | CineArte Centro | F | 8 |
| Molina Rey | Pequenos gigantes | CineArte Centro | F | 9 |
| Molina Rey | Pequenos gigantes | CineArte Norte | J | 6 |
| Soto Vega | El faro del sur | CineArte Norte | G | 4 |
| Soto Vega | Pequenos gigantes | CineArte Norte | H | 1 |
| Soto Vega | Pequenos gigantes | CineArte Norte | H | 2 |

### Consulta 15

Salas con el nombre de su cine (USING sobre id_cine; `numero` existe en las dos tablas, por eso se califica).

```sql
SELECT c.nombre, s.numero, s.tipo, s.capacidad
FROM SALA s
JOIN CINE c USING (id_cine)
ORDER BY c.nombre, s.numero;
```

| nombre | numero | tipo | capacidad |
|---|---|---|---|
| CineArte Centro | 1 | regular | 180 |
| CineArte Centro | 2 | 3d | 120 |
| CineArte Laureles | 1 | regular | 160 |
| CineArte Laureles | 2 | vip | 48 |
| CineArte Norte | 1 | regular | 220 |
| CineArte Norte | 2 | vip | 60 |
| CineArte Norte | 3 | 3d | 140 |

### Consulta 16

Películas con su número de funciones, incluso las que no tienen.

```sql
SELECT p.titulo, COUNT(f.id_funcion) AS funciones
FROM PELICULA p
LEFT JOIN FUNCION f ON f.id_pelicula = p.id_pelicula
GROUP BY p.id_pelicula, p.titulo
ORDER BY funciones DESC, p.titulo;
```

| titulo | funciones |
|---|---|
| El faro del sur | 2 |
| La casa del silencio | 2 |
| Orbita cero | 2 |
| Pequenos gigantes | 2 |
| Cumbia para dos | 0 |

## C8 · Subconsultas

### Consulta 17

Clientes que nunca han comprado.

```sql
SELECT documento, nombres, apellidos
FROM CLIENTE
WHERE documento NOT IN (SELECT documento_cliente FROM TIQUETE);
```

| documento | nombres | apellidos |
|---|---|---|
| 1001234321 | Tomas | Acosta Lima |

### Consulta 18

Funciones más caras que el promedio de su propia película (correlacionada).

```sql
SELECT f.id_funcion, f.id_pelicula, f.precio
FROM FUNCION f
WHERE f.precio > (SELECT AVG(x.precio) FROM FUNCION x WHERE x.id_pelicula = f.id_pelicula)
ORDER BY f.id_pelicula;
```

| id_funcion | id_pelicula | precio |
|---|---|---|
| 6 | 1 | 13000 |
| 5 | 2 | 18000 |
| 4 | 3 | 15000 |
| 3 | 4 | 32000 |

### Consulta 19

La película que más tiquetes ha vendido.

```sql
SELECT p.titulo, COUNT(*) AS tiquetes
FROM TIQUETE t
JOIN FUNCION f ON f.id_funcion = t.id_funcion
JOIN PELICULA p ON p.id_pelicula = f.id_pelicula
GROUP BY p.id_pelicula, p.titulo
HAVING COUNT(*) = (SELECT MAX(n) FROM (SELECT COUNT(*) AS n
                                       FROM TIQUETE t2
                                       JOIN FUNCION f2 ON f2.id_funcion = t2.id_funcion
                                       GROUP BY f2.id_pelicula) x);
```

| titulo | tiquetes |
|---|---|
| Pequenos gigantes | 6 |

## C9 · Operadores de conjunto

### Consulta 20

Clientes que han ido a una sala 3D y también a una VIP.

```sql
SELECT t.documento_cliente FROM TIQUETE t JOIN FUNCION f ON f.id_funcion = t.id_funcion JOIN SALA s ON s.id_sala = f.id_sala WHERE s.tipo = '3d'
INTERSECT
SELECT t.documento_cliente FROM TIQUETE t JOIN FUNCION f ON f.id_funcion = t.id_funcion JOIN SALA s ON s.id_sala = f.id_sala WHERE s.tipo = 'vip';
```

| documento_cliente |
|---|
| 1018223344 |

### Consulta 21

Películas que se proyectan en Bogotá pero no en Medellín.

```sql
SELECT f.id_pelicula FROM FUNCION f JOIN SALA s ON s.id_sala = f.id_sala JOIN CINE c ON c.id_cine = s.id_cine WHERE c.ciudad = 'Bogota'
EXCEPT
SELECT f.id_pelicula FROM FUNCION f JOIN SALA s ON s.id_sala = f.id_sala JOIN CINE c ON c.id_cine = s.id_cine WHERE c.ciudad = 'Medellin';
```

| id_pelicula |
|---|
| 2 |
| 3 |

### Consulta 22

Directorio de contactos: teléfonos de los cines y correos de los clientes.

```sql
SELECT CONCAT('Cine ', id_cine) AS quien, telefono AS contacto FROM CINE_TELEFONO
UNION
SELECT apellidos, correo FROM CLIENTE
ORDER BY quien;
```

| quien | contacto |
|---|---|
| Acosta Lima | tacosta@mail.com |
| Castillo Pena | rcastillo@mail.com |
| Cine 1 | 6013345566 |
| Cine 1 | 6013345567 |
| Cine 2 | 6017788990 |
| Cine 3 | 3125556677 |
| Cine 3 | 6044451122 |
| Guzman Toro | fguzman@mail.com |
| Molina Rey | amolina@mail.com |
| Soto Vega | msoto@mail.com |
