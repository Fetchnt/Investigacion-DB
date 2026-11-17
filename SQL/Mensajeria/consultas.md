# Consultas SQL · Empresa de mensajería

## C2 · Recuperar datos con SELECT

### Consulta 1

Envíos con su costo y lo que se cobra por kilo.

```sql
SELECT guia, peso_kg, costo, costo / peso_kg AS costo_por_kg
FROM ENVIO;
```

| guia | peso_kg | costo | costo_por_kg |
|---|---|---|---|
| GU-000101 | 2.50 | 18000 | 7200.00 |
| GU-000102 | 0.20 | 9000 | 45000.00 |
| GU-000103 | 12 | 45000 | 3750 |
| GU-000104 | 1.10 | 12000 | 10909.09 |
| GU-000105 | 0.30 | 9500 | 31666.67 |
| GU-000106 | 5.75 | 26000 | 4521.74 |
| GU-000107 | 3.20 | 20000 | 6250.00 |

### Consulta 2

Ciudades de destino.

```sql
SELECT DISTINCT ciudad_destino
FROM ENVIO
ORDER BY ciudad_destino;
```

| ciudad_destino |
|---|
| Bogota |
| Cali |
| Medellin |

## C3 · Restringir y ordenar

### Consulta 3

Envíos de más de 2 kg que van a Cali o Medellín, del más pesado al más liviano.

```sql
SELECT guia, destinatario, ciudad_destino, peso_kg
FROM ENVIO
WHERE peso_kg > 2 AND ciudad_destino IN ('Cali', 'Medellin')
ORDER BY peso_kg DESC;
```

| guia | destinatario | ciudad_destino | peso_kg |
|---|---|---|---|
| GU-000103 | Almacen Centro | Cali | 12 |
| GU-000106 | Mario Velez | Medellin | 5.75 |
| GU-000107 | Paula Gil | Cali | 3.20 |
| GU-000101 | Carlos Mesa | Medellin | 2.50 |

### Consulta 4

Clientes que no tienen correo.

```sql
SELECT nit, razon_social
FROM CLIENTE
WHERE correo IS NULL;
```

| nit | razon_social |
|---|---|
| 900333444-5 | Tienda Natural Ltda |

### Consulta 5

Eventos con alguna observación.

```sql
SELECT guia, consecutivo, estado, observacion
FROM SEGUIMIENTO
WHERE observacion IS NOT NULL
ORDER BY guia, consecutivo;
```

| guia | consecutivo | estado | observacion |
|---|---|---|---|
| GU-000101 | 2 | en transito | Sale en linea a Medellin |
| GU-000101 | 3 | entregado | Recibe portero |
| GU-000102 | 2 | entregado | Sello de recibido |
| GU-000103 | 3 | novedad | Direccion incompleta |

## C4 · Funciones de una sola fila

### Consulta 6

Volumen de cada paquete en metros cúbicos.

```sql
SELECT guia, alto_cm, ancho_cm, largo_cm,
       ROUND(alto_cm * ancho_cm * largo_cm / 1000000, 3) AS m3
FROM PAQUETE
ORDER BY m3 DESC;
```

| guia | alto_cm | ancho_cm | largo_cm | m3 |
|---|---|---|---|---|
| GU-000103 | 60 | 40 | 40 | 0.10 |
| GU-000106 | 50 | 30 | 30 | 0.04 |
| GU-000107 | 40 | 30 | 20 | 0.02 |
| GU-000101 | 30 | 20 | 15 | 0.01 |
| GU-000104 | 25 | 25 | 10 | 0.01 |

### Consulta 7

Días que tardó cada entrega desde la recepción.

```sql
SELECT s.guia, e.fecha_recepcion, DATE(s.fecha_hora) AS entrega,
       DATEDIFF(DATE(s.fecha_hora), e.fecha_recepcion) AS dias
FROM SEGUIMIENTO s
JOIN ENVIO e ON e.guia = s.guia
WHERE s.estado = 'entregado'
ORDER BY dias DESC, s.guia;
```

| guia | fecha_recepcion | entrega | dias |
|---|---|---|---|
| GU-000103 | 2026-11-03 | 2026-11-06 | 3 |
| GU-000101 | 2026-11-02 | 2026-11-04 | 2 |
| GU-000102 | 2026-11-02 | 2026-11-02 | 0 |
| GU-000104 | 2026-11-05 | 2026-11-05 | 0 |

### Consulta 8

Destinatario en mayúsculas y los dos últimos dígitos de la guía.

```sql
SELECT guia, UPPER(destinatario) AS destinatario, RIGHT(guia, 2) AS sufijo
FROM ENVIO
ORDER BY guia;
```

| guia | destinatario | sufijo |
|---|---|---|
| GU-000101 | CARLOS MESA | 01 |
| GU-000102 | JUZGADO 3 CIVIL | 02 |
| GU-000103 | ALMACEN CENTRO | 03 |
| GU-000104 | LAURA RINCON | 04 |
| GU-000105 | BANCO AGRARIO | 05 |
| GU-000106 | MARIO VELEZ | 06 |
| GU-000107 | PAULA GIL | 07 |

## C5 · Funciones de conversión y condicionales

### Consulta 9

Rastreo de la guía GU-000103 con fecha y hora en formato corto.

```sql
SELECT consecutivo, DATE_FORMAT(fecha_hora, '%d/%m %H:%i') AS cuando, estado,
       IFNULL(observacion, '-') AS observacion
FROM SEGUIMIENTO
WHERE guia = 'GU-000103'
ORDER BY consecutivo;
```

| consecutivo | cuando | estado | observacion |
|---|---|---|---|
| 1 | 03/11 08:30 | recibido | - |
| 2 | 03/11 20:00 | en transito | - |
| 3 | 05/11 09:45 | novedad | Direccion incompleta |
| 4 | 06/11 14:20 | entregado | - |

### Consulta 10

Capacidad de carga según el vehículo del mensajero.

```sql
SELECT nombre, vehiculo,
       CASE vehiculo WHEN 'bicicleta' THEN 'Hasta 10 kg'
                     WHEN 'moto' THEN 'Hasta 30 kg'
                     ELSE 'Carga pesada' END AS capacidad
FROM MENSAJERO
ORDER BY id_mensajero;
```

| nombre | vehiculo | capacidad |
|---|---|---|
| Oscar Prada | moto | Hasta 30 kg |
| Yeimy Cardona | furgon | Carga pesada |
| Andres Tobon | moto | Hasta 30 kg |
| Ximena Lozano | bicicleta | Hasta 10 kg |
| Felipe Ibarra | bicicleta | Hasta 10 kg |

## C6 · Funciones de grupo

### Consulta 11

Envíos y facturación por sede de origen.

```sql
SELECT id_sede_origen, COUNT(*) AS envios, SUM(costo) AS facturado
FROM ENVIO
GROUP BY id_sede_origen
ORDER BY facturado DESC;
```

| id_sede_origen | envios | facturado |
|---|---|---|
| 1 | 4 | 62500 |
| 2 | 1 | 45000 |
| 3 | 2 | 32000 |

### Consulta 12

Peso promedio por ciudad de destino, solo donde hay dos o más envíos.

```sql
SELECT ciudad_destino, COUNT(*) AS envios, ROUND(AVG(peso_kg), 2) AS peso_promedio
FROM ENVIO
GROUP BY ciudad_destino
HAVING COUNT(*) >= 2
ORDER BY ciudad_destino;
```

| ciudad_destino | envios | peso_promedio |
|---|---|---|
| Bogota | 2 | 0.25 |
| Cali | 3 | 5.43 |
| Medellin | 2 | 4.13 |

## C7 · Joins

### Consulta 13

Cada envío con el cliente, la sede de origen y el mensajero (LEFT JOIN: el último no tiene mensajero).

```sql
SELECT e.guia, c.razon_social, s.ciudad AS origen, m.nombre AS mensajero
FROM ENVIO e
JOIN CLIENTE c ON c.nit = e.nit_cliente
JOIN SEDE s ON s.id_sede = e.id_sede_origen
LEFT JOIN ASIGNACION a ON a.guia = e.guia
LEFT JOIN MENSAJERO m ON m.id_mensajero = a.id_mensajero
ORDER BY e.guia;
```

| guia | razon_social | origen | mensajero |
|---|---|---|---|
| GU-000101 | Libreria El Saber SAS | Bogota | Oscar Prada |
| GU-000102 | Notaria 12 de Bogota | Bogota | Oscar Prada |
| GU-000103 | Tienda Natural Ltda | Medellin | Andres Tobon |
| GU-000104 | Moda Express SAS | Cali | Ximena Lozano |
| GU-000105 | Libreria El Saber SAS | Bogota | Yeimy Cardona |
| GU-000106 | Libreria El Saber SAS | Bogota | Yeimy Cardona |
| GU-000107 | Moda Express SAS | Cali | NULL |

### Consulta 14

Mensajeros con la ciudad de su sede (USING sobre id_sede).

```sql
SELECT nombre, vehiculo, ciudad
FROM MENSAJERO
JOIN SEDE USING (id_sede)
ORDER BY ciudad, nombre;
```

| nombre | vehiculo | ciudad |
|---|---|---|
| Felipe Ibarra | bicicleta | Bogota |
| Oscar Prada | moto | Bogota |
| Yeimy Cardona | furgon | Bogota |
| Ximena Lozano | bicicleta | Cali |
| Andres Tobon | moto | Medellin |

### Consulta 15

Paquetes frágiles con su destino (NATURAL JOIN sobre guia).

```sql
SELECT guia, destinatario, ciudad_destino
FROM ENVIO
NATURAL JOIN PAQUETE
WHERE fragil = 1;
```

| guia | destinatario | ciudad_destino |
|---|---|---|
| GU-000103 | Almacen Centro | Cali |
| GU-000106 | Mario Velez | Medellin |

## C8 · Subconsultas

### Consulta 16

Estado actual de cada guía: el evento con el consecutivo más alto (correlacionada).

```sql
SELECT s.guia, s.estado, s.fecha_hora
FROM SEGUIMIENTO s
WHERE s.consecutivo = (SELECT MAX(x.consecutivo) FROM SEGUIMIENTO x WHERE x.guia = s.guia)
ORDER BY s.guia;
```

| guia | estado | fecha_hora |
|---|---|---|
| GU-000101 | entregado | 2026-11-04 11:05:00 |
| GU-000102 | entregado | 2026-11-02 15:30:00 |
| GU-000103 | entregado | 2026-11-06 14:20:00 |
| GU-000104 | entregado | 2026-11-05 16:00:00 |
| GU-000105 | en reparto | 2026-11-09 13:15:00 |
| GU-000106 | en transito | 2026-11-12 19:00:00 |
| GU-000107 | recibido | 2026-11-15 11:00:00 |

### Consulta 17

Envíos que todavía no tienen mensajero.

```sql
SELECT guia, fecha_recepcion, destinatario
FROM ENVIO e
WHERE NOT EXISTS (SELECT 1 FROM ASIGNACION a WHERE a.guia = e.guia);
```

| guia | fecha_recepcion | destinatario |
|---|---|---|
| GU-000107 | 2026-11-15 | Paula Gil |

### Consulta 18

Mensajeros sin ningún envío asignado.

```sql
SELECT nombre
FROM MENSAJERO
WHERE id_mensajero NOT IN (SELECT id_mensajero FROM ASIGNACION);
```

| nombre |
|---|
| Felipe Ibarra |

## C9 · Operadores de conjunto

### Consulta 19

Guías que requieren atención: tuvieron novedad o no tienen mensajero.

```sql
SELECT guia FROM SEGUIMIENTO WHERE estado = 'novedad'
UNION
SELECT guia FROM ENVIO WHERE guia NOT IN (SELECT guia FROM ASIGNACION)
ORDER BY guia;
```

| guia |
|---|
| GU-000103 |
| GU-000107 |

### Consulta 20

Clientes que mandan paquetes y también documentos.

```sql
SELECT e.nit_cliente FROM ENVIO e JOIN PAQUETE p ON p.guia = e.guia
INTERSECT
SELECT e.nit_cliente FROM ENVIO e JOIN DOCUMENTO d ON d.guia = e.guia;
```

| nit_cliente |
|---|
| 900111222-3 |

### Consulta 21

Guías que todavía no se han entregado.

```sql
SELECT guia FROM ENVIO
EXCEPT
SELECT guia FROM SEGUIMIENTO WHERE estado = 'entregado';
```

| guia |
|---|
| GU-000105 |
| GU-000106 |
| GU-000107 |
