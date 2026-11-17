# Álgebra relacional · Festival de música

### Consulta 1

**π nombre_artistico, pais (ARTISTA)**

Muestra el nombre y el país de cada artista.

| nombre_artistico | pais |
|---|---|
| Marea Alta | Colombia |
| Lianna Voss | Chile |
| Los Cumbiamberos del Sur | Argentina |
| DJ Kaleido | Mexico |
| Nube Roja | Colombia |
| Tomas Riel | Espana |
| Selva Electrica | Colombia |

### Consulta 2

**σ codigo_escenario = 'ELE' (PRESENTACION)**

Obtiene los shows del domo electrónico.

| id_artista | numero_jornada | codigo_escenario | hora_inicio | duracion_min |
|---|---|---|---|---|
| 4 | 1 | ELE | 22:00:00 | 120 |
| 7 | 2 | ELE | 21:00:00 | 90 |
| 4 | 3 | ELE | 20:00:00 | 120 |

### Consulta 3

**π id_artista (σ numero_jornada = 1 (PRESENTACION)) ∩ π id_artista (σ numero_jornada = 3 (PRESENTACION))**

Artistas que tocan el primer y el último día.

| id_artista |
|---|
| 1 |
| 2 |
| 4 |

### Consulta 4

**π id_artista (SOLISTA) ∪ π id_artista (AGRUPACION)**

Todos los artistas a partir de sus subtipos.

| id_artista |
|---|
| 1 |
| 2 |
| 3 |
| 4 |
| 5 |
| 6 |
| 7 |

### Consulta 5

**π id_artista (ARTISTA) − π id_artista (σ codigo_escenario = 'PRI' (PRESENTACION))**

Artistas que no pisan el escenario principal.

| id_artista |
|---|
| 4 |
| 5 |
| 6 |
| 7 |

### Consulta 6

**π nombre_artistico, hora_inicio (ARTISTA ⋈ σ numero_jornada = 2 (PRESENTACION))**

Artistas de la jornada 2 con su hora.

| nombre_artistico | hora_inicio |
|---|---|
| Los Cumbiamberos del Sur | 20:00:00 |
| Nube Roja | 19:30:00 |
| Selva Electrica | 21:00:00 |

### Consulta 7

**π nombre (ASISTENTE ⋈ documento = documento_asistente (σ tipo = 'vip' (BOLETA)))**

Asistentes con boleta VIP.

| nombre |
|---|
| Julian Becerra |
| Kevin Duarte |

### Consulta 8

**π nombre (ESCENARIO) × π numero (JORNADA)**

Todas las combinaciones escenario-jornada (producto cartesiano): base para saber qué escenario queda vacío algún día.

| nombre | numero |
|---|---|
| Escenario Principal | 1 |
| Escenario Principal | 2 |
| Escenario Principal | 3 |
| Carpa Bosque | 1 |
| Carpa Bosque | 2 |
| Carpa Bosque | 3 |
| Domo Electronico | 1 |
| Domo Electronico | 2 |
| Domo Electronico | 3 |
