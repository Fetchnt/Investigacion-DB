# Consultas SQL · Agencia inmobiliaria

## C2 · Recuperar datos con SELECT

### Consulta 1

Inmuebles en venta con su precio por metro cuadrado.

```sql
SELECT matricula, area_m2, precio_venta, precio_venta / area_m2 AS precio_m2
FROM INMUEBLE
WHERE en_venta = 1;
```

| matricula | area_m2 | precio_venta | precio_m2 |
|---|---|---|---|
| 50C-1458796 | 85 | 980000000 | 11529411 |
| 50S-3321457 | 140 | 520000000 | 3714285 |
| 001-998877 | 110 | 1150000000 | 10454545 |
| 370-112233 | 260 | 1450000000 | 5576923 |
| 50C-2001133 | 54 | 280000000 | 5185185 |

### Consulta 2

Tipos de inmueble que maneja la agencia.

```sql
SELECT DISTINCT tipo
FROM INMUEBLE
ORDER BY tipo;
```

| tipo |
|---|
| apartamento |
| casa |
| local |
| oficina |

## C3 · Restringir y ordenar

### Consulta 3

Arriendos de estrato 4 o más por menos de 4 millones.

```sql
SELECT matricula, barrio, estrato, canon_mensual
FROM INMUEBLE
WHERE en_arriendo = 1 AND estrato >= 4 AND canon_mensual < 4000000
ORDER BY canon_mensual;
```

| matricula | barrio | estrato | canon_mensual |
|---|---|---|---|
| 50N-2236541 | Cedritos | 4 | 2300000 |
| 001-776655 | Laureles | 4 | 3500000 |

### Consulta 4

Inmuebles de tres o más habitaciones en Bogotá o Medellín, del más grande al más pequeño.

```sql
SELECT matricula, ciudad, habitaciones, area_m2
FROM INMUEBLE
WHERE habitaciones >= 3 AND ciudad IN ('Bogota', 'Medellin')
ORDER BY area_m2 DESC;
```

| matricula | ciudad | habitaciones | area_m2 |
|---|---|---|---|
| 50S-3321457 | Bogota | 4 | 140 |
| 001-998877 | Medellin | 3 | 110 |
| 50N-2236541 | Bogota | 3 | 62.50 |

### Consulta 5

Visitas en las que el cliente no dejó comentario.

```sql
SELECT documento_cliente, matricula, fecha
FROM VISITA
WHERE comentario IS NULL
ORDER BY fecha;
```

| documento_cliente | matricula | fecha |
|---|---|---|
| 1032998877 | 50C-1458796 | 2026-10-08 |
| 79123456 | 50N-2236541 | 2026-10-11 |
| 1144778899 | 50N-2236541 | 2026-11-06 |

## C4 · Funciones de una sola fila

### Consulta 6

Dirección completa (atributo compuesto) y precio en millones.

```sql
SELECT matricula, CONCAT(calle, ' # ', numero, ', ', barrio) AS direccion,
       ROUND(precio_venta / 1000000, 0) AS millones
FROM INMUEBLE
WHERE en_venta = 1
ORDER BY millones;
```

| matricula | direccion | millones |
|---|---|---|
| 50C-2001133 | Cll 72 # 9-15, Chapinero | 280.00 |
| 50S-3321457 | Cra 68 # 12-80, Marsella | 520.00 |
| 50C-1458796 | Cra 11 # 93-45, Chico | 980.00 |
| 001-998877 | Cll 10 # 43-15, El Poblado | 1150.00 |
| 370-112233 | Cll 5 # 66-40, Pance | 1450.00 |

### Consulta 7

Oficina de registro de cada matrícula (lo que va antes del guion).

```sql
SELECT matricula, SUBSTRING(matricula, 1, INSTR(matricula, '-') - 1) AS oficina_registro, ciudad
FROM INMUEBLE
ORDER BY oficina_registro, matricula;
```

| matricula | oficina_registro | ciudad |
|---|---|---|
| 001-776655 | 001 | Medellin |
| 001-998877 | 001 | Medellin |
| 370-112233 | 370 | Cali |
| 370-554433 | 370 | Cali |
| 50C-1458796 | 50C | Bogota |
| 50C-2001133 | 50C | Bogota |
| 50N-2236541 | 50N | Bogota |
| 50S-3321457 | 50S | Bogota |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Modalidad de cada inmueble a partir de las banderas.

```sql
SELECT matricula,
       CASE WHEN en_venta = 1 AND en_arriendo = 1 THEN 'venta y arriendo'
            WHEN en_venta = 1 THEN 'venta'
            WHEN en_arriendo = 1 THEN 'arriendo'
            ELSE 'retirado' END AS modalidad
FROM INMUEBLE
ORDER BY modalidad, matricula;
```

| matricula | modalidad |
|---|---|
| 001-776655 | arriendo |
| 50N-2236541 | arriendo |
| 370-554433 | retirado |
| 001-998877 | venta |
| 50C-2001133 | venta |
| 50S-3321457 | venta |
| 370-112233 | venta y arriendo |
| 50C-1458796 | venta y arriendo |

### Consulta 9

Visitas con fecha en formato corto y el comentario o un aviso.

```sql
SELECT DATE_FORMAT(fecha, '%d/%m/%Y') AS dia, matricula,
       IFNULL(comentario, 'sin comentario') AS comentario
FROM VISITA
ORDER BY fecha;
```

| dia | matricula | comentario |
|---|---|---|
| 03/10/2026 | 50S-3321457 | Le gusto el patio |
| 08/10/2026 | 50C-1458796 | sin comentario |
| 11/10/2026 | 50N-2236541 | sin comentario |
| 17/10/2026 | 50S-3321457 | Vino con la familia |
| 20/10/2026 | 001-998877 | Quiere negociar el precio |
| 25/10/2026 | 50C-1458796 | Muy costoso |
| 02/11/2026 | 001-776655 | Para su negocio |
| 06/11/2026 | 50N-2236541 | sin comentario |

## C6 · Funciones de grupo

### Consulta 10

Inmuebles por ciudad y tipo.

```sql
SELECT ciudad, tipo, COUNT(*) AS inmuebles
FROM INMUEBLE
GROUP BY ciudad, tipo
ORDER BY ciudad, tipo;
```

| ciudad | tipo | inmuebles |
|---|---|---|
| Bogota | apartamento | 2 |
| Bogota | casa | 1 |
| Bogota | oficina | 1 |
| Cali | casa | 1 |
| Cali | oficina | 1 |
| Medellin | apartamento | 1 |
| Medellin | local | 1 |

### Consulta 11

Inmuebles con interés promedio de 4 o más en sus visitas.

```sql
SELECT matricula, COUNT(*) AS visitas, AVG(interes) AS interes_promedio
FROM VISITA
GROUP BY matricula
HAVING AVG(interes) >= 4
ORDER BY interes_promedio DESC, matricula;
```

| matricula | visitas | interes_promedio |
|---|---|---|
| 001-998877 | 1 | 5.00 |
| 50N-2236541 | 2 | 4.50 |
| 50S-3321457 | 2 | 4.50 |
| 001-776655 | 1 | 4.00 |

## C7 · Joins

### Consulta 12

Comisión de cada venta según la tabla de rangos (non-equijoin con BETWEEN).

```sql
SELECT i.matricula, i.precio_venta, r.porcentaje,
       i.precio_venta * r.porcentaje / 100 AS comision
FROM INMUEBLE i
JOIN RANGO_COMISION r ON i.precio_venta BETWEEN r.valor_min AND r.valor_max
WHERE i.en_venta = 1
ORDER BY i.precio_venta;
```

| matricula | precio_venta | porcentaje | comision |
|---|---|---|---|
| 50C-2001133 | 280000000 | 4 | 11200000 |
| 50S-3321457 | 520000000 | 3 | 15600000 |
| 50C-1458796 | 980000000 | 2.50 | 24500000.00 |
| 001-998877 | 1150000000 | 2.50 | 28750000.00 |
| 370-112233 | 1450000000 | 2.50 | 36250000.00 |

### Consulta 13

Visitas con el cliente y el agente que gestiona el inmueble.

```sql
SELECT v.fecha, c.nombre AS cliente, i.barrio, a.nombre AS agente
FROM VISITA v
JOIN CLIENTE c ON c.documento = v.documento_cliente
JOIN INMUEBLE i ON i.matricula = v.matricula
JOIN AGENTE a ON a.id_agente = i.id_agente
ORDER BY v.fecha;
```

| fecha | cliente | barrio | agente |
|---|---|---|---|
| 2026-10-03 | Jorge Bautista | Marsella | Ricardo Bernal |
| 2026-10-08 | Paola Ruiz | Chico | Natalia Cuervo |
| 2026-10-11 | Esteban Gil | Cedritos | Natalia Cuervo |
| 2026-10-17 | Jorge Bautista | Marsella | Ricardo Bernal |
| 2026-10-20 | Paola Ruiz | El Poblado | Monica Salgado |
| 2026-10-25 | Esteban Gil | Chico | Natalia Cuervo |
| 2026-11-02 | Valeria Ochoa | Laureles | Monica Salgado |
| 2026-11-06 | Valeria Ochoa | Cedritos | Natalia Cuervo |

### Consulta 14

Agentes con el número de inmuebles, incluso los que no tienen.

```sql
SELECT a.nombre, COUNT(i.matricula) AS inmuebles
FROM AGENTE a
LEFT JOIN INMUEBLE i ON i.id_agente = a.id_agente
GROUP BY a.id_agente, a.nombre
ORDER BY inmuebles DESC, a.nombre;
```

| nombre | inmuebles |
|---|---|
| Natalia Cuervo | 3 |
| Ricardo Bernal | 3 |
| Monica Salgado | 2 |
| Ivan Pedraza | 0 |

### Consulta 15

Teléfonos de cada propietario (USING sobre documento).

```sql
SELECT nombre, telefono
FROM PROPIETARIO
JOIN PROP_TELEFONO USING (documento)
ORDER BY nombre, telefono;
```

| nombre | telefono |
|---|---|
| Beatriz Cano Rios | 3135550004 |
| Beatriz Cano Rios | 3145550005 |
| Claudia Marin Suarez | 3115550002 |
| Hernando Lopez Ruiz | 3105550001 |
| Hernando Lopez Ruiz | 6012220001 |
| Sebastian Duque Mora | 3125550003 |

## C8 · Subconsultas

### Consulta 16

Clientes a los que les alcanza el presupuesto para comprar algún inmueble (EXISTS correlacionado).

```sql
SELECT c.nombre, c.presupuesto
FROM CLIENTE c
WHERE EXISTS (SELECT 1 FROM INMUEBLE i
              WHERE i.en_venta = 1 AND i.precio_venta <= c.presupuesto);
```

| nombre | presupuesto |
|---|---|
| Jorge Bautista | 600000000 |
| Paola Ruiz | 1200000000 |

### Consulta 17

Inmuebles ofrecidos que nadie ha visitado.

```sql
SELECT matricula, barrio, ciudad
FROM INMUEBLE
WHERE (en_venta = 1 OR en_arriendo = 1)
  AND matricula NOT IN (SELECT matricula FROM VISITA);
```

| matricula | barrio | ciudad |
|---|---|---|
| 370-112233 | Pance | Cali |
| 50C-2001133 | Chapinero | Bogota |

### Consulta 18

El inmueble más grande de cada ciudad.

```sql
SELECT i.ciudad, i.matricula, i.area_m2
FROM INMUEBLE i
WHERE i.area_m2 = (SELECT MAX(x.area_m2) FROM INMUEBLE x WHERE x.ciudad = i.ciudad)
ORDER BY i.ciudad;
```

| ciudad | matricula | area_m2 |
|---|---|---|
| Bogota | 50S-3321457 | 140 |
| Cali | 370-112233 | 260 |
| Medellin | 001-998877 | 110 |

## C9 · Operadores de conjunto

### Consulta 19

Clientes que han visitado inmuebles en Bogotá y también en Medellín.

```sql
SELECT v.documento_cliente FROM VISITA v JOIN INMUEBLE i ON i.matricula = v.matricula WHERE i.ciudad = 'Bogota'
INTERSECT
SELECT v.documento_cliente FROM VISITA v JOIN INMUEBLE i ON i.matricula = v.matricula WHERE i.ciudad = 'Medellin';
```

| documento_cliente |
|---|
| 1032998877 |
| 1144778899 |

### Consulta 20

Directorio telefónico: propietarios y agentes.

```sql
SELECT p.nombre, t.telefono, 'propietario' AS rol FROM PROPIETARIO p JOIN PROP_TELEFONO t ON t.documento = p.documento
UNION
SELECT nombre, telefono, 'agente' FROM AGENTE
ORDER BY rol, nombre;
```

| nombre | telefono | rol |
|---|---|---|
| Ivan Pedraza | 3201110004 | agente |
| Monica Salgado | 3201110003 | agente |
| Natalia Cuervo | 3201110001 | agente |
| Ricardo Bernal | 3201110002 | agente |
| Beatriz Cano Rios | 3135550004 | propietario |
| Beatriz Cano Rios | 3145550005 | propietario |
| Claudia Marin Suarez | 3115550002 | propietario |
| Hernando Lopez Ruiz | 3105550001 | propietario |
| Hernando Lopez Ruiz | 6012220001 | propietario |
| Sebastian Duque Mora | 3125550003 | propietario |

### Consulta 21

Inmuebles en arriendo que no están también en venta.

```sql
SELECT matricula FROM INMUEBLE WHERE en_arriendo = 1
EXCEPT
SELECT matricula FROM INMUEBLE WHERE en_venta = 1;
```

| matricula |
|---|
| 001-776655 |
| 50N-2236541 |
