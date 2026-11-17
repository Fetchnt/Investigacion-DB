# Consultas SQL · Cadena hotelera

## C2 · Recuperar datos con SELECT

### Consulta 1

Habitaciones con su tarifa por noche y lo que costaría una semana.

```sql
SELECT id_habitacion, numero, tarifa_base, tarifa_base * 7 AS tarifa_semana
FROM HABITACION;
```

| id_habitacion | numero | tarifa_base | tarifa_semana |
|---|---|---|---|
| 1 | 101 | 280000 | 1960000 |
| 2 | 102 | 220000 | 1540000 |
| 3 | 501 | 650000 | 4550000 |
| 4 | 201 | 420000 | 2940000 |
| 5 | 202 | 450000 | 3150000 |
| 6 | 901 | 1200000 | 8400000 |
| 7 | 1 | 180000 | 1260000 |
| 8 | 2 | 260000 | 1820000 |

### Consulta 2

Países de donde vienen los huéspedes, sin repetir.

```sql
SELECT DISTINCT pais
FROM HUESPED
ORDER BY pais;
```

| pais |
|---|
| Alemania |
| Argentina |
| Colombia |
| Mexico |

## C3 · Restringir y ordenar

### Consulta 3

Reservas que entran en octubre de 2026, por fecha de entrada.

```sql
SELECT codigo, fecha_entrada, fecha_salida, estado
FROM RESERVA
WHERE fecha_entrada BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY fecha_entrada;
```

| codigo | fecha_entrada | fecha_salida | estado |
|---|---|---|---|
| R-003 | 2026-10-02 | 2026-10-06 | finalizada |
| R-004 | 2026-10-15 | 2026-10-16 | finalizada |
| R-005 | 2026-10-20 | 2026-10-25 | finalizada |

### Consulta 4

Habitaciones estándar para dos o más personas que cuestan menos de 300.000.

```sql
SELECT numero, nit_hotel, capacidad, tarifa_base
FROM HABITACION
WHERE tipo = 'estandar' AND capacidad >= 2 AND tarifa_base < 300000
ORDER BY tarifa_base;
```

| numero | nit_hotel | capacidad | tarifa_base |
|---|---|---|---|
| 1 | 900345678-3 | 2 | 180000 |
| 101 | 900123456-1 | 2 | 280000 |

### Consulta 5

Huéspedes con correo que no termina en .com.

```sql
SELECT nombres, apellidos, correo
FROM HUESPED
WHERE correo NOT LIKE '%.com'
ORDER BY apellidos;
```

| nombres | apellidos | correo |
|---|---|---|
| Lucia | Fernandez | lucia.f@mail.ar |
| Diego | Lopez Ramos | dlopez@mail.mx |
| Emma | Schulz | emma.schulz@mail.de |

## C4 · Funciones de una sola fila

### Consulta 6

Noches de cada reserva (atributo derivado).

```sql
SELECT codigo, fecha_entrada, fecha_salida,
       DATEDIFF(fecha_salida, fecha_entrada) AS noches
FROM RESERVA
ORDER BY noches DESC, codigo;
```

| codigo | fecha_entrada | fecha_salida | noches |
|---|---|---|---|
| R-007 | 2026-12-20 | 2026-12-27 | 7 |
| R-005 | 2026-10-20 | 2026-10-25 | 5 |
| R-008 | 2026-12-28 | 2027-01-02 | 5 |
| R-003 | 2026-10-02 | 2026-10-06 | 4 |
| R-006 | 2026-11-14 | 2026-11-18 | 4 |
| R-001 | 2026-09-04 | 2026-09-07 | 3 |
| R-002 | 2026-09-10 | 2026-09-12 | 2 |
| R-004 | 2026-10-15 | 2026-10-16 | 1 |

### Consulta 7

Tarifa base sin el IVA del 19 %, redondeada a pesos.

```sql
SELECT numero, nit_hotel, tarifa_base,
       ROUND(tarifa_base / 1.19, 0) AS tarifa_sin_iva
FROM HABITACION
ORDER BY tarifa_base DESC;
```

| numero | nit_hotel | tarifa_base | tarifa_sin_iva |
|---|---|---|---|
| 901 | 900234567-2 | 1200000 | 1008403.00 |
| 501 | 900123456-1 | 650000 | 546218.00 |
| 202 | 900234567-2 | 450000 | 378151.00 |
| 201 | 900234567-2 | 420000 | 352941.00 |
| 101 | 900123456-1 | 280000 | 235294.00 |
| 2 | 900345678-3 | 260000 | 218487.00 |
| 102 | 900123456-1 | 220000 | 184874.00 |
| 1 | 900345678-3 | 180000 | 151261.00 |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Detalle de cada habitación: el tipo de cama o los metros de la suite.

```sql
SELECT numero, tipo,
       COALESCE(tipo_cama, CONCAT(CAST(metros2 AS CHAR), ' m2')) AS detalle
FROM HABITACION
ORDER BY id_habitacion;
```

| numero | tipo | detalle |
|---|---|---|
| 101 | estandar | doble |
| 102 | estandar | sencilla |
| 501 | suite | 48 m2 |
| 201 | estandar | queen |
| 202 | estandar | doble |
| 901 | suite | 75.5 m2 |
| 1 | estandar | doble |
| 2 | suite | 35 m2 |

### Consulta 9

Reservas con la fecha en formato día/mes/año y el estado explicado.

```sql
SELECT codigo, DATE_FORMAT(fecha_entrada, '%d/%m/%Y') AS entrada,
       CASE estado WHEN 'activa' THEN 'Huesped en el hotel'
                   WHEN 'confirmada' THEN 'Por llegar'
                   WHEN 'cancelada' THEN 'No se cobra'
                   ELSE 'Cerrada' END AS situacion
FROM RESERVA
ORDER BY codigo;
```

| codigo | entrada | situacion |
|---|---|---|
| R-001 | 04/09/2026 | Cerrada |
| R-002 | 10/09/2026 | Cerrada |
| R-003 | 02/10/2026 | Cerrada |
| R-004 | 15/10/2026 | Cerrada |
| R-005 | 20/10/2026 | Cerrada |
| R-006 | 14/11/2026 | Huesped en el hotel |
| R-007 | 20/12/2026 | Por llegar |
| R-008 | 28/12/2026 | No se cobra |

## C6 · Funciones de grupo

### Consulta 10

Reservas por estado.

```sql
SELECT estado, COUNT(*) AS reservas
FROM RESERVA
GROUP BY estado
ORDER BY reservas DESC, estado;
```

| estado | reservas |
|---|---|
| finalizada | 5 |
| activa | 1 |
| cancelada | 1 |
| confirmada | 1 |

### Consulta 11

Servicios de los que se han consumido 3 unidades o más.

```sql
SELECT id_servicio, SUM(cantidad) AS unidades, COUNT(*) AS cargos
FROM CONSUMO
GROUP BY id_servicio
HAVING SUM(cantidad) >= 3
ORDER BY unidades DESC;
```

| id_servicio | unidades | cargos |
|---|---|---|
| 1 | 10 | 5 |
| 5 | 5 | 2 |
| 3 | 3 | 2 |

## C7 · Joins

### Consulta 12

Quién se alojó en qué hotel y habitación (join de cinco tablas).

```sql
SELECT r.codigo, h.apellidos, ho.ciudad, ha.numero, a.tarifa_noche
FROM RESERVA r
JOIN HUESPED h ON h.documento = r.documento_huesped
JOIN ALOJAMIENTO a ON a.codigo_reserva = r.codigo
JOIN HABITACION ha ON ha.id_habitacion = a.id_habitacion
JOIN HOTEL ho ON ho.nit = ha.nit_hotel
WHERE r.estado <> 'cancelada'
ORDER BY r.codigo, ha.numero;
```

| codigo | apellidos | ciudad | numero | tarifa_noche |
|---|---|---|---|---|
| R-001 | Rojas Mejia | Bogota | 101 | 280000 |
| R-002 | Schulz | Cartagena | 901 | 1150000 |
| R-003 | Fernandez | Cartagena | 201 | 420000 |
| R-003 | Fernandez | Cartagena | 202 | 450000 |
| R-004 | Mendez Ariza | Bogota | 102 | 220000 |
| R-005 | Schulz | Salento | 1 | 180000 |
| R-006 | Herrera Vela | Bogota | 501 | 650000 |
| R-007 | Rojas Mejia | Cartagena | 201 | 420000 |
| R-007 | Rojas Mejia | Cartagena | 901 | 1200000 |

### Consulta 13

Ingreso por servicio, incluidos los que nadie ha usado (LEFT JOIN).

```sql
SELECT s.nombre, IFNULL(SUM(c.cantidad * s.precio), 0) AS ingreso
FROM SERVICIO s
LEFT JOIN CONSUMO c ON c.id_servicio = s.id_servicio
GROUP BY s.id_servicio, s.nombre
ORDER BY ingreso DESC;
```

| nombre | ingreso |
|---|---|
| Desayuno buffet | 450000 |
| Spa | 360000 |
| Traslado aeropuerto | 160000 |
| Minibar | 125000 |
| Lavanderia | 30000 |
| Parqueadero | 0 |

### Consulta 14

Huéspedes que han hecho más de una reserva (self join sobre RESERVA).

```sql
SELECT DISTINCT r1.documento_huesped, r1.codigo AS reserva, r2.codigo AS otra_reserva
FROM RESERVA r1
JOIN RESERVA r2 ON r2.documento_huesped = r1.documento_huesped
               AND r2.codigo > r1.codigo
ORDER BY r1.documento_huesped;
```

| documento_huesped | reserva | otra_reserva |
|---|---|---|
| 1019876543 | R-001 | R-007 |
| X1234567 | R-002 | R-005 |

## C8 · Subconsultas

### Consulta 15

Habitaciones que nunca se han reservado.

```sql
SELECT id_habitacion, numero, nit_hotel
FROM HABITACION
WHERE id_habitacion NOT IN (SELECT id_habitacion FROM ALOJAMIENTO);
```

| id_habitacion | numero | nit_hotel |
|---|---|---|
| 8 | 2 | 900345678-3 |

### Consulta 16

La reserva más larga.

```sql
SELECT codigo, documento_huesped, DATEDIFF(fecha_salida, fecha_entrada) AS noches
FROM RESERVA
WHERE DATEDIFF(fecha_salida, fecha_entrada) = (SELECT MAX(DATEDIFF(fecha_salida, fecha_entrada))
                                               FROM RESERVA);
```

| codigo | documento_huesped | noches |
|---|---|---|
| R-007 | 1019876543 | 7 |

### Consulta 17

Habitaciones cuya tarifa supera el promedio de su propio hotel (subconsulta correlacionada).

```sql
SELECT h.numero, h.nit_hotel, h.tarifa_base
FROM HABITACION h
WHERE h.tarifa_base > (SELECT AVG(x.tarifa_base)
                       FROM HABITACION x
                       WHERE x.nit_hotel = h.nit_hotel)
ORDER BY h.nit_hotel;
```

| numero | nit_hotel | tarifa_base |
|---|---|---|
| 501 | 900123456-1 | 650000 |
| 901 | 900234567-2 | 1200000 |
| 2 | 900345678-3 | 260000 |

## C9 · Operadores de conjunto

### Consulta 18

Reservas que usaron spa o traslado (UNION quita los repetidos).

```sql
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 3
UNION
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 4
ORDER BY codigo_reserva;
```

| codigo_reserva |
|---|
| R-002 |
| R-005 |
| R-006 |

### Consulta 19

Reservas que tomaron desayuno y también traslado.

```sql
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 1
INTERSECT
SELECT codigo_reserva FROM CONSUMO WHERE id_servicio = 4;
```

| codigo_reserva |
|---|
| R-005 |

### Consulta 20

Servicios que nunca se han consumido.

```sql
SELECT id_servicio FROM SERVICIO
EXCEPT
SELECT id_servicio FROM CONSUMO;
```

| id_servicio |
|---|
| 6 |
