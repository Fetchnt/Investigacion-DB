# Álgebra relacional · Cadena hotelera

### Consulta 1

**π nombre, ciudad (HOTEL)**

Muestra el nombre y la ciudad de cada hotel.

| nombre | ciudad |
|---|---|
| Hotel Monserrate Plaza | Bogota |
| Hotel Bahia Azul | Cartagena |
| Hostal Cafe Verde | Salento |

### Consulta 2

**σ tipo = 'suite' (HABITACION)**

Obtiene las suites.

| id_habitacion | numero | piso | capacidad | tarifa_base | nit_hotel | tipo | metros2 | jacuzzi | tipo_cama |
|---|---|---|---|---|---|---|---|---|---|
| 3 | 501 | 5 | 4 | 650000 | 900123456-1 | suite | 48 | 1 | NULL |
| 6 | 901 | 9 | 4 | 1200000 | 900234567-2 | suite | 75.50 | 1 | NULL |
| 8 | 2 | 1 | 4 | 260000 | 900345678-3 | suite | 35 | 0 | NULL |

### Consulta 3

**π codigo, fecha_entrada (σ estado = 'finalizada' ∧ fecha_entrada ≥ '2026-10-01' (RESERVA))**

Reservas finalizadas que entraron desde octubre.

| codigo | fecha_entrada |
|---|---|
| R-003 | 2026-10-02 |
| R-004 | 2026-10-15 |
| R-005 | 2026-10-20 |

### Consulta 4

**π id_habitacion (HABITACION) − π id_habitacion (ALOJAMIENTO)**

Habitaciones que nunca se han reservado.

| id_habitacion |
|---|
| 8 |

### Consulta 5

**π codigo_reserva (σ id_servicio = 1 (CONSUMO)) ∩ π codigo_reserva (σ id_servicio = 4 (CONSUMO))**

Reservas con desayuno y traslado.

| codigo_reserva |
|---|
| R-005 |

### Consulta 6

**π apellidos, codigo (HUESPED ⋈ documento = documento_huesped RESERVA)**

Cada reserva con el apellido del huésped (reunión con condición, porque las columnas se llaman distinto).

| apellidos | codigo |
|---|---|
| Rojas Mejia | R-001 |
| Schulz | R-002 |
| Fernandez | R-003 |
| Mendez Ariza | R-004 |
| Schulz | R-005 |
| Herrera Vela | R-006 |
| Rojas Mejia | R-007 |
| Lopez Ramos | R-008 |

### Consulta 7

**π nombre (HOTEL ⋈ nit = nit_hotel (σ tipo = 'suite' ∧ jacuzzi = 1 (HABITACION)))**

Hoteles que tienen suites con jacuzzi.

| nombre |
|---|
| Hotel Monserrate Plaza |
| Hotel Bahia Azul |

### Consulta 8

**π documento (HUESPED) − π documento_huesped (σ estado = 'cancelada' (RESERVA))**

Huéspedes que nunca han cancelado.

| documento |
|---|
| 1019876543 |
| 1098765432 |
| 80123456 |
| AR556677 |
| X1234567 |
