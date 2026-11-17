# Álgebra relacional · Empresa de mensajería

### Consulta 1

**π guia, destinatario, ciudad_destino (ENVIO)**

Guía, destinatario y ciudad de cada envío.

| guia | destinatario | ciudad_destino |
|---|---|---|
| GU-000101 | Carlos Mesa | Medellin |
| GU-000102 | Juzgado 3 Civil | Bogota |
| GU-000103 | Almacen Centro | Cali |
| GU-000104 | Laura Rincon | Cali |
| GU-000105 | Banco Agrario | Bogota |
| GU-000106 | Mario Velez | Medellin |
| GU-000107 | Paula Gil | Cali |

### Consulta 2

**σ estado = 'novedad' (SEGUIMIENTO)**

Eventos con novedad.

| guia | consecutivo | fecha_hora | estado | observacion |
|---|---|---|---|---|
| GU-000103 | 3 | 2026-11-05 09:45:00 | novedad | Direccion incompleta |

### Consulta 3

**π guia (ENVIO) − π guia (ASIGNACION)**

Envíos sin mensajero.

| guia |
|---|
| GU-000107 |

### Consulta 4

**π guia (PAQUETE) ∪ π guia (DOCUMENTO)**

Todas las guías a partir de los subtipos (jerarquía total).

| guia |
|---|
| GU-000101 |
| GU-000102 |
| GU-000103 |
| GU-000104 |
| GU-000105 |
| GU-000106 |
| GU-000107 |

### Consulta 5

**π guia (σ estado = 'entregado' (SEGUIMIENTO)) ∩ π guia (PAQUETE)**

Paquetes ya entregados.

| guia |
|---|
| GU-000101 |
| GU-000103 |
| GU-000104 |

### Consulta 6

**π nombre, guia (MENSAJERO ⋈ ASIGNACION)**

Mensajero de cada guía asignada (reunión natural sobre id_mensajero).

| nombre | guia |
|---|---|
| Oscar Prada | GU-000101 |
| Oscar Prada | GU-000102 |
| Andres Tobon | GU-000103 |
| Ximena Lozano | GU-000104 |
| Yeimy Cardona | GU-000105 |
| Yeimy Cardona | GU-000106 |

### Consulta 7

**π razon_social (CLIENTE ⋈ nit = nit_cliente (σ ciudad_destino = 'Cali' (ENVIO)))**

Clientes que mandan a Cali.

| razon_social |
|---|
| Tienda Natural Ltda |
| Moda Express SAS |
