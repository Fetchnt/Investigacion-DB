# Álgebra relacional · Clínica veterinaria

### Consulta 1

**π nombre, especie (MASCOTA)**

Muestra el nombre y la especie de todas las mascotas.

| nombre | especie |
|---|---|
| Luna | perro |
| Michi | gato |
| Rocky | perro |
| Kiwi | ave |
| Toby | perro |
| Nala | gato |
| Coco | conejo |
| Max | perro |

### Consulta 2

**σ especialidad = 'Medicina general' (VETERINARIO)**

Obtiene los veterinarios de medicina general.

| id_veterinario | nombre | tarjeta_profesional | especialidad |
|---|---|---|---|
| 1 | Diana Morales | TP-10234 | Medicina general |
| 4 | Oscar Benitez | TP-13421 | Medicina general |

### Consulta 3

**π nombre, presentacion (σ precio < 20000 (MEDICAMENTO))**

Muestra los medicamentos que cuestan menos de 20.000.

| nombre | presentacion |
|---|---|
| Amoxicilina 250 mg | Tabletas |
| Omeprazol 20 mg | Capsulas |
| Clorhexidina 2% | Solucion topica |

### Consulta 4

**π id_consulta (URGENCIA) ∪ π id_consulta (CONTROL)**

Obtiene las consultas que son urgencia o control.

| id_consulta |
|---|
| 2 |
| 3 |
| 5 |
| 6 |
| 9 |
| 10 |

### Consulta 5

**π codigo (MEDICAMENTO) − ρ codigo←codigo_medicamento (π codigo_medicamento (RECETA))**

Identifica los medicamentos que nunca se han recetado.

| codigo |
|---|
| MED-06 |

### Consulta 6

**π fecha, motivo, nombre (CONSULTA ⋈ VETERINARIO)**

Muestra cada consulta con el nombre del veterinario (la reunión natural usa id_veterinario).

| fecha | motivo | nombre |
|---|---|---|
| 2026-09-02 | Vacunacion anual | Diana Morales |
| 2026-09-05 | Vomito y decaimiento | Diana Morales |
| 2026-09-12 | Herida en pata | Felipe Castano |
| 2026-09-20 | Caida de pelo | Natalia Ruiz |
| 2026-10-01 | Control de herida | Felipe Castano |
| 2026-10-08 | Fractura de ala | Felipe Castano |
| 2026-10-15 | Picazon constante | Natalia Ruiz |
| 2026-10-22 | Vacunacion anual | Diana Morales |
| 2026-11-03 | Control dermatitis | Natalia Ruiz |
| 2026-11-10 | Intoxicacion | Diana Morales |

### Consulta 7

**π nombre (VETERINARIO ⋈ (CONSULTA ⋈ σ nivel_triage ≤ 2 (URGENCIA)))**

Obtiene los veterinarios que atendieron urgencias graves (triage 1 o 2).

| nombre |
|---|
| Felipe Castano |
| Diana Morales |

### Consulta 8

**π id_consulta (CONSULTA) ∩ π id_consulta (RECETA)**

Obtiene las consultas en las que se recetó algo.

| id_consulta |
|---|
| 2 |
| 3 |
| 4 |
| 6 |
| 7 |
| 9 |
| 10 |
