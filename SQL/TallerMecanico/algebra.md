# Álgebra relacional · Taller mecánico

### Consulta 1

**π placa, marca, linea (VEHICULO)**

Placa, marca y línea de cada vehículo.

| placa | marca | linea |
|---|---|---|
| ABC123 | Renault | Logan |
| DEF456 | Chevrolet | Spark GT |
| GHI789 | Mazda | 3 |
| JKL012 | Toyota | Hilux |
| MNO345 | Kia | Rio |

### Consulta 2

**σ nivel = 'senior' (MECANICO)**

Obtiene los mecánicos senior.

| id_empleado | nombres | apellidos | fecha_ingreso | salario | especialidad | nivel |
|---|---|---|---|---|---|---|
| 102 | Wilson | Ariza Pena | 2018-07-15 | 2600000 | Frenos y suspension | senior |
| 104 | Luis | Fajardo Gil | 2020-10-10 | 2400000 | Motor | senior |

### Consulta 3

**π m.nombres, s.nombres (ρ m (MECANICO) ⋈ m.id_empleado = x.id_mecanico ρ x (SUPERVISION) ⋈ x.id_supervisor = s.id_empleado ρ s (MECANICO))**

Cada mecánico con su supervisor: con ρ se renombra la misma tabla para usarla dos veces.

| mecanico | supervisor |
|---|---|
| Wilson | Jairo |
| Brayan | Wilson |
| Luis | Jairo |
| Kevin | Luis |

### Consulta 4

**π id_empleado, nombres (MECANICO) ∪ π id_empleado, nombres (ASESOR)**

Todos los empleados (el supertipo que desapareció).

| id_empleado | nombres |
|---|---|
| 101 | Jairo |
| 102 | Wilson |
| 103 | Brayan |
| 104 | Luis |
| 105 | Kevin |
| 201 | Diana |
| 202 | Camilo |

### Consulta 5

**π id_empleado (MECANICO) − ρ id_empleado←id_mecanico (π id_mecanico (σ numero_orden ≥ 1004 (TRABAJO)))**

Mecánicos que no han trabajado en las órdenes recientes (de la 1004 en adelante).

| id_empleado |
|---|
| 105 |

### Consulta 6

**π id_mecanico (SUPERVISION) ∩ ρ id_mecanico←id_supervisor (π id_supervisor (SUPERVISION))**

Mandos medios: supervisados que también supervisan.

| id_mecanico |
|---|
| 102 |
| 104 |

### Consulta 7

**π numero, placa (σ estado = 'entregada' (ORDEN)) ⋈ VEHICULO**

Órdenes entregadas con todos los datos del vehículo.

| numero | placa | marca | linea | modelo | color | documento_cliente |
|---|---|---|---|---|---|---|
| 1001 | ABC123 | Renault | Logan | 2018 | Gris | 1010101010 |
| 1002 | DEF456 | Chevrolet | Spark GT | 2017 | Rojo | 52111222 |
| 1003 | GHI789 | Mazda | 3 | 2021 | Azul | 80222333 |
| 1004 | JKL012 | Toyota | Hilux | 2019 | Blanco | 80222333 |
