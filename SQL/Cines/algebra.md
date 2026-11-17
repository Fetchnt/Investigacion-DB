# Álgebra relacional · Cadena de cines

### Consulta 1

**π titulo, duracion_min (PELICULA)**

Título y duración de cada película.

| titulo | duracion_min |
|---|---|
| El faro del sur | 112 |
| Orbita cero | 138 |
| Pequenos gigantes | 95 |
| La casa del silencio | 104 |
| Cumbia para dos | 101 |

### Consulta 2

**σ tipo = 'vip' (SALA)**

Obtiene las salas VIP.

| id_sala | numero | capacidad | id_cine | tipo | gafas_disponibles | servicio_mesero |
|---|---|---|---|---|---|---|
| 4 | 2 | 60 | 2 | vip | NULL | 1 |
| 7 | 2 | 48 | 3 | vip | NULL | 0 |

### Consulta 3

**π id_funcion, hora (σ fecha = '2026-11-13' ∧ precio < 20000 (FUNCION))**

Funciones económicas del 13 de noviembre.

| id_funcion | hora |
|---|---|
| 1 | 16:00:00 |
| 2 | 19:30:00 |

### Consulta 4

**π documento (CLIENTE) − ρ documento←documento_cliente (π documento_cliente (TIQUETE))**

Clientes que nunca han comprado.

| documento |
|---|
| 1001234321 |

### Consulta 5

**π id_pelicula (σ idioma = 'doblada' (FUNCION)) ∩ π id_pelicula (σ idioma = 'subtitulada' (FUNCION))**

Películas que se dan dobladas y subtituladas.

| id_pelicula |
|---|
| 2 |

### Consulta 6

**π titulo, fecha, hora (PELICULA ⋈ FUNCION)**

Cada función con el título de su película (reunión natural sobre id_pelicula).

| titulo | fecha | hora |
|---|---|---|
| Pequenos gigantes | 2026-11-13 | 16:00:00 |
| Orbita cero | 2026-11-13 | 19:30:00 |
| La casa del silencio | 2026-11-13 | 21:00:00 |
| Pequenos gigantes | 2026-11-14 | 15:00:00 |
| Orbita cero | 2026-11-14 | 20:00:00 |
| El faro del sur | 2026-11-14 | 18:00:00 |
| La casa del silencio | 2026-11-15 | 20:30:00 |
| El faro del sur | 2026-11-15 | 17:00:00 |

### Consulta 7

**π fila, numero_silla (σ id_funcion = 1 (TIQUETE))**

Sillas vendidas en la función 1.

| fila | numero_silla |
|---|---|
| F | 7 |
| F | 8 |
| F | 9 |

### Consulta 8

**π id_cine (CINE_TELEFONO) ∪ π id_cine (σ tipo = 'vip' (SALA))**

Cines con más de un medio de reserva: tienen teléfono o sala VIP.

| id_cine |
|---|
| 1 |
| 2 |
| 3 |
