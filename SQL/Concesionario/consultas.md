# Consultas SQL · Concesionario de vehículos

## C2 · Recuperar datos con SELECT

### Consulta 1

Vehículos con su precio de lista y la cuota inicial del 30 %.

```sql
SELECT marca, modelo, precio_lista, precio_lista * 0.30 AS cuota_inicial
FROM VEHICULO;
```

| marca | modelo | precio_lista | cuota_inicial |
|---|---|---|---|
| Volkswagen | T-Cross | 112000000 | 33600000.00 |
| Mazda | CX-30 | 135000000 | 40500000.00 |
| Toyota | Corolla Cross | 128000000 | 38400000.00 |
| Renault | Duster | 58000000 | 17400000.00 |
| Chevrolet | Onix | 46000000 | 13800000.00 |
| Kia | Picanto | 52000000 | 15600000.00 |
| Hyundai | Tucson | 158000000 | 47400000.00 |
| Hyundai | Accent | 61000000 | 18300000.00 |

### Consulta 2

Marcas que hay en el inventario, sin repetir.

```sql
SELECT DISTINCT marca
FROM VEHICULO
ORDER BY marca;
```

| marca |
|---|
| Chevrolet |
| Hyundai |
| Kia |
| Mazda |
| Renault |
| Toyota |
| Volkswagen |

## C3 · Restringir y ordenar

### Consulta 3

Vehículos de 2022 en adelante que cuestan menos de 120 millones, del más barato al más caro.

```sql
SELECT marca, modelo, anio, precio_lista
FROM VEHICULO
WHERE anio >= 2022 AND precio_lista < 120000000
ORDER BY precio_lista;
```

| marca | modelo | anio | precio_lista |
|---|---|---|---|
| Kia | Picanto | 2023 | 52000000 |
| Hyundai | Accent | 2022 | 61000000 |
| Volkswagen | T-Cross | 2026 | 112000000 |

### Consulta 4

Clientes que no registraron correo.

```sql
SELECT documento, nombres, apellidos, telefono
FROM CLIENTE
WHERE correo IS NULL;
```

| documento | nombres | apellidos | telefono |
|---|---|---|---|
| 79888777 | Ricardo | Nunez Prieto | 3006667788 |

### Consulta 5

Vehículos Mazda, Toyota o Hyundai que no son negros.

```sql
SELECT marca, modelo, color
FROM VEHICULO
WHERE marca IN ('Mazda', 'Toyota', 'Hyundai') AND color <> 'Negro'
ORDER BY marca, modelo;
```

| marca | modelo | color |
|---|---|---|
| Hyundai | Accent | Blanco |
| Mazda | CX-30 | Rojo |
| Toyota | Corolla Cross | Gris |

## C4 · Funciones de una sola fila

### Consulta 6

Antigüedad de cada vendedor en años (atributo derivado).

```sql
SELECT nombre, fecha_ingreso,
       TIMESTAMPDIFF(YEAR, fecha_ingreso, CURDATE()) AS antiguedad
FROM VENDEDOR
ORDER BY antiguedad DESC;
```

| nombre | fecha_ingreso | antiguedad |
|---|---|---|
| Sara Villegas | 2017-09-18 | 9 |
| Paula Andrea Rincon | 2019-02-11 | 7 |
| Hernan Quintero | 2022-06-01 | 4 |
| Mauricio Ospina | 2024-01-15 | 2 |

### Consulta 7

Fabricante (los tres primeros caracteres del VIN) y marca en mayúsculas.

```sql
SELECT vin, SUBSTRING(vin, 1, 3) AS wmi, UPPER(marca) AS marca,
       CHAR_LENGTH(vin) AS largo
FROM VEHICULO
ORDER BY wmi;
```

| vin | wmi | marca | largo |
|---|---|---|---|
| 3MZBPACL5RM100234 | 3MZ | MAZDA | 17 |
| 8AJBA3CD7K1234567 | 8AJ | CHEVROLET | 17 |
| 93YRBB003LJ512345 | 93Y | RENAULT | 17 |
| 9BWZZZ377VT004251 | 9BW | VOLKSWAGEN | 17 |
| 9FBHS4AD5PM778899 | 9FB | KIA | 17 |
| JTDKARFP3N3012345 | JTD | TOYOTA | 17 |
| KMHJ3814GKU445566 | KMH | HYUNDAI | 17 |
| MALA841CBNM334455 | MAL | HYUNDAI | 17 |

## C5 · Funciones de conversión y condicionales

### Consulta 8

Mes de cada venta y valor convertido a entero (sin decimales).

```sql
SELECT numero_factura, DATE_FORMAT(fecha, '%Y-%m') AS mes,
       CAST(valor_final AS UNSIGNED) AS valor
FROM VENTA
ORDER BY numero_factura;
```

| numero_factura | mes | valor |
|---|---|---|
| FV-2026-001 | 2026-07 | 109500000 |
| FV-2026-002 | 2026-08 | 56000000 |
| FV-2026-003 | 2026-08 | 44500000 |
| FV-2026-004 | 2026-09 | 133000000 |
| FV-2026-005 | 2026-10 | 155000000 |
| FV-2026-006 | 2026-11 | 50500000 |

### Consulta 9

Usados clasificados por kilometraje.

```sql
SELECT placa, kilometraje,
       CASE WHEN kilometraje < 30000 THEN 'Como nuevo'
            WHEN kilometraje < 70000 THEN 'Recorrido medio'
            ELSE 'Alto recorrido' END AS estado
FROM VEHICULO_USADO
ORDER BY kilometraje;
```

| placa | kilometraje | estado |
|---|---|---|
| PQR789 | 21000 | Como nuevo |
| STU234 | 45000 | Recorrido medio |
| JKL123 | 68500 | Recorrido medio |
| MNO456 | 92000 | Alto recorrido |

### Consulta 10

Clientes con el correo o un aviso si no lo tienen.

```sql
SELECT apellidos, IFNULL(correo, 'sin correo') AS contacto
FROM CLIENTE
ORDER BY apellidos;
```

| apellidos | contacto |
|---|---|
| Arango Silva | darango@mail.com |
| Bedoya Mesa | gbedoya@mail.com |
| Cardenas Ruiz | mcardenas@mail.com |
| Nunez Prieto | sin correo |
| Restrepo Gil | jrestrepo@mail.com |

## C6 · Funciones de grupo

### Consulta 11

Ventas y valor total por forma de pago.

```sql
SELECT forma_pago, COUNT(*) AS ventas, SUM(valor_final) AS total
FROM VENTA
GROUP BY forma_pago
ORDER BY total DESC;
```

| forma_pago | ventas | total |
|---|---|---|
| credito | 3 | 315000000 |
| leasing | 1 | 133000000 |
| contado | 2 | 100500000 |

### Consulta 12

Marcas con dos o más vehículos y su rango de precios.

```sql
SELECT marca, COUNT(*) AS vehiculos, MIN(precio_lista) AS minimo, MAX(precio_lista) AS maximo
FROM VEHICULO
GROUP BY marca
HAVING COUNT(*) >= 2;
```

| marca | vehiculos | minimo | maximo |
|---|---|---|---|
| Hyundai | 2 | 61000000 | 158000000 |

## C7 · Joins

### Consulta 13

Cada venta con el cliente, el vendedor y el vehículo, y la comisión.

```sql
SELECT ve.numero_factura, c.apellidos AS cliente, vd.nombre AS vendedor,
       v.marca, v.modelo,
       ROUND(ve.valor_final * vd.porcentaje_comision / 100, 0) AS comision
FROM VENTA ve
JOIN CLIENTE c ON c.documento = ve.documento_cliente
JOIN VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
JOIN VEHICULO v ON v.vin = ve.vin
ORDER BY ve.numero_factura;
```

| numero_factura | cliente | vendedor | marca | modelo | comision |
|---|---|---|---|---|---|
| FV-2026-001 | Arango Silva | Paula Andrea Rincon | Volkswagen | T-Cross | 2737500.00 |
| FV-2026-002 | Nunez Prieto | Hernan Quintero | Renault | Duster | 1120000.00 |
| FV-2026-003 | Restrepo Gil | Mauricio Ospina | Chevrolet | Onix | 1112500.00 |
| FV-2026-004 | Bedoya Mesa | Paula Andrea Rincon | Mazda | CX-30 | 3325000.00 |
| FV-2026-005 | Cardenas Ruiz | Mauricio Ospina | Hyundai | Tucson | 3875000.00 |
| FV-2026-006 | Arango Silva | Sara Villegas | Kia | Picanto | 1515000.00 |

### Consulta 14

Vehículos con la ciudad de su sede (JOIN ... USING sobre id_sede).

```sql
SELECT marca, modelo, ciudad
FROM VEHICULO
JOIN SEDE USING (id_sede)
ORDER BY ciudad, marca;
```

| marca | modelo | ciudad |
|---|---|---|
| Hyundai | Accent | Bogota |
| Kia | Picanto | Bogota |
| Mazda | CX-30 | Bogota |
| Renault | Duster | Bogota |
| Toyota | Corolla Cross | Bogota |
| Volkswagen | T-Cross | Bogota |
| Chevrolet | Onix | Medellin |
| Hyundai | Tucson | Medellin |

### Consulta 15

Todos los vehículos y, si se vendieron, la factura (LEFT JOIN).

```sql
SELECT v.marca, v.modelo, ve.numero_factura
FROM VEHICULO v
LEFT JOIN VENTA ve ON ve.vin = v.vin
ORDER BY ve.numero_factura IS NULL, ve.numero_factura, v.vin;
```

| marca | modelo | numero_factura |
|---|---|---|
| Volkswagen | T-Cross | FV-2026-001 |
| Renault | Duster | FV-2026-002 |
| Chevrolet | Onix | FV-2026-003 |
| Mazda | CX-30 | FV-2026-004 |
| Hyundai | Tucson | FV-2026-005 |
| Kia | Picanto | FV-2026-006 |
| Toyota | Corolla Cross | NULL |
| Hyundai | Accent | NULL |

## C8 · Subconsultas

### Consulta 16

Vehículos que siguen disponibles.

```sql
SELECT vin, marca, modelo, precio_lista
FROM VEHICULO
WHERE vin NOT IN (SELECT vin FROM VENTA);
```

| vin | marca | modelo | precio_lista |
|---|---|---|---|
| JTDKARFP3N3012345 | Toyota | Corolla Cross | 128000000 |
| MALA841CBNM334455 | Hyundai | Accent | 61000000 |

### Consulta 17

Usados más baratos que el precio promedio de los nuevos.

```sql
SELECT v.marca, v.modelo, v.precio_lista
FROM VEHICULO v
JOIN VEHICULO_USADO u ON u.vin = v.vin
WHERE v.precio_lista < (SELECT AVG(x.precio_lista)
                        FROM VEHICULO x
                        JOIN VEHICULO_NUEVO n ON n.vin = x.vin)
ORDER BY v.precio_lista;
```

| marca | modelo | precio_lista |
|---|---|---|
| Chevrolet | Onix | 46000000 |
| Kia | Picanto | 52000000 |
| Renault | Duster | 58000000 |
| Hyundai | Accent | 61000000 |

### Consulta 18

El vendedor que más ha vendido en pesos.

```sql
SELECT id_vendedor, SUM(valor_final) AS total
FROM VENTA
GROUP BY id_vendedor
HAVING SUM(valor_final) >= ALL (SELECT SUM(valor_final)
                               FROM VENTA
                               GROUP BY id_vendedor);
```

| id_vendedor | total |
|---|---|
| 1 | 242500000 |

## C9 · Operadores de conjunto

### Consulta 19

Marcas que se ofrecen tanto en Bogotá como en Medellín.

```sql
SELECT marca FROM VEHICULO JOIN SEDE USING (id_sede) WHERE ciudad = 'Bogota'
INTERSECT
SELECT marca FROM VEHICULO JOIN SEDE USING (id_sede) WHERE ciudad = 'Medellin';
```

| marca |
|---|
| Hyundai |

### Consulta 20

Accesorios que aparecen en vehículos nuevos o en usados (UNION).

```sql
SELECT a.id_accesorio FROM VEH_ACCESORIO a JOIN VEHICULO_NUEVO n ON n.vin = a.vin
UNION
SELECT a.id_accesorio FROM VEH_ACCESORIO a JOIN VEHICULO_USADO u ON u.vin = a.vin
ORDER BY id_accesorio;
```

| id_accesorio |
|---|
| 1 |
| 2 |
| 3 |
| 4 |
| 5 |

### Consulta 21

Clientes que han comprado a crédito pero nunca de contado.

```sql
SELECT documento_cliente FROM VENTA WHERE forma_pago = 'credito'
EXCEPT
SELECT documento_cliente FROM VENTA WHERE forma_pago = 'contado';
```

| documento_cliente |
|---|
| 1020304050 |
| 1032456789 |
