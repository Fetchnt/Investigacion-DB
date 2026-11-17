# Álgebra relacional · Agencia inmobiliaria

### Consulta 1

**π matricula, ciudad, tipo (INMUEBLE)**

Matrícula, ciudad y tipo de cada inmueble.

| matricula | ciudad | tipo |
|---|---|---|
| 50C-1458796 | Bogota | apartamento |
| 50N-2236541 | Bogota | apartamento |
| 50S-3321457 | Bogota | casa |
| 001-998877 | Medellin | apartamento |
| 001-776655 | Medellin | local |
| 370-554433 | Cali | oficina |
| 370-112233 | Cali | casa |
| 50C-2001133 | Bogota | oficina |

### Consulta 2

**σ en_venta = 1 ∧ en_arriendo = 1 (INMUEBLE)**

Inmuebles en las dos modalidades (la parte solapada).

| matricula | barrio | precio_venta | canon_mensual |
|---|---|---|---|
| 50C-1458796 | Chico | 980000000 | 4200000 |
| 370-112233 | Pance | 1450000000 | 6800000 |

### Consulta 3

**π matricula (σ en_venta = 1 ∨ en_arriendo = 1 (INMUEBLE)) − π matricula (VISITA)**

Inmuebles ofrecidos sin visitas.

| matricula |
|---|
| 370-112233 |
| 50C-2001133 |

### Consulta 4

**π matricula, porcentaje (INMUEBLE ⋈ precio_venta ≥ valor_min ∧ precio_venta ≤ valor_max RANGO_COMISION)**

Porcentaje de comisión de cada venta: reunión θ con desigualdades.

| matricula | porcentaje |
|---|---|
| 50C-1458796 | 2.50 |
| 50S-3321457 | 3 |
| 001-998877 | 2.50 |
| 370-112233 | 2.50 |
| 50C-2001133 | 4 |

### Consulta 5

**π documento_cliente (σ interes = 5 (VISITA)) ∩ π documento_cliente (σ interes ≤ 3 (VISITA))**

Clientes que encontraron algo que les encantó y algo que no.

| documento_cliente |
|---|
| 1032998877 |

### Consulta 6

**π nombre, telefono (PROPIETARIO ⋈ PROP_TELEFONO)**

Teléfonos de los propietarios (reunión natural sobre documento).

| nombre | telefono |
|---|---|
| Hernando Lopez Ruiz | 3105550001 |
| Hernando Lopez Ruiz | 6012220001 |
| Claudia Marin Suarez | 3115550002 |
| Sebastian Duque Mora | 3125550003 |
| Beatriz Cano Rios | 3135550004 |
| Beatriz Cano Rios | 3145550005 |

### Consulta 7

**π matricula (σ ciudad = 'Cali' (INMUEBLE)) ∪ π matricula (σ tipo = 'local' (INMUEBLE))**

Inmuebles en Cali o que son locales.

| matricula |
|---|
| 001-776655 |
| 370-112233 |
| 370-554433 |
