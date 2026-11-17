# Álgebra relacional · Concesionario de vehículos

### Consulta 1

**π marca, modelo, anio (VEHICULO)**

Muestra marca, modelo y año de cada vehículo.

| marca | modelo | anio |
|---|---|---|
| Volkswagen | T-Cross | 2026 |
| Mazda | CX-30 | 2026 |
| Toyota | Corolla Cross | 2025 |
| Renault | Duster | 2020 |
| Chevrolet | Onix | 2019 |
| Kia | Picanto | 2023 |
| Hyundai | Tucson | 2026 |
| Hyundai | Accent | 2022 |

### Consulta 2

**σ forma_pago = 'credito' (VENTA)**

Obtiene las ventas a crédito.

| numero_factura | fecha | valor_final | forma_pago | documento_cliente | id_vendedor | vin |
|---|---|---|---|---|---|---|
| FV-2026-001 | 2026-07-14 | 109500000 | credito | 1032456789 | 1 | 9BWZZZ377VT004251 |
| FV-2026-005 | 2026-10-18 | 155000000 | credito | 1020304050 | 4 | KMHJ3814GKU445566 |
| FV-2026-006 | 2026-11-05 | 50500000 | credito | 1032456789 | 3 | 9FBHS4AD5PM778899 |

### Consulta 3

**π vin (VEHICULO) − π vin (VENTA)**

Identifica los vehículos que no se han vendido.

| vin |
|---|
| JTDKARFP3N3012345 |
| MALA841CBNM334455 |

### Consulta 4

**π vin (VEHICULO_NUEVO) ∪ π vin (VEHICULO_USADO)**

Junta los vehículos de los dos subtipos (debe dar todo el inventario: jerarquía total).

| vin |
|---|
| 3MZBPACL5RM100234 |
| 8AJBA3CD7K1234567 |
| 93YRBB003LJ512345 |
| 9BWZZZ377VT004251 |
| 9FBHS4AD5PM778899 |
| JTDKARFP3N3012345 |
| KMHJ3814GKU445566 |
| MALA841CBNM334455 |

### Consulta 5

**π marca, modelo, kilometraje (VEHICULO ⋈ VEHICULO_USADO)**

Muestra los usados con su kilometraje (la reunión natural usa vin).

| marca | modelo | kilometraje |
|---|---|---|
| Renault | Duster | 68500 |
| Chevrolet | Onix | 92000 |
| Kia | Picanto | 21000 |
| Hyundai | Accent | 45000 |

### Consulta 6

**π nombre (ACCESORIO ⋈ (σ marca = 'Hyundai' (VEHICULO) ⋈ VEH_ACCESORIO))**

Accesorios que trae algún Hyundai.

| nombre |
|---|
| Sunroof |
| Sensores de parqueo |
| Camara de reversa |
| Rines de lujo |
| Pantalla tactil |

### Consulta 7

**π vin (VEH_ACCESORIO ⋈ σ nombre = 'Sunroof' (ACCESORIO)) ∩ π vin (VENTA)**

Vehículos con sunroof que ya se vendieron.

| vin |
|---|
| 3MZBPACL5RM100234 |
| KMHJ3814GKU445566 |

### Consulta 8

**π nombre, ciudad (VENDEDOR ⋈ VENDEDOR.id_sede = SEDE.id_sede SEDE)**

Cada vendedor con la ciudad de su sede (reunión con condición: las dos tablas tienen una columna nombre).

| nombre | ciudad |
|---|---|
| Paula Andrea Rincon | Bogota |
| Hernan Quintero | Bogota |
| Sara Villegas | Bogota |
| Mauricio Ospina | Medellin |
