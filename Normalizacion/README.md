# Normalización

Cada PDF lleva el esquema de la planilla sin normalizar (0FN) hasta FNBC, paso a paso.
Aquí se agrega el paso a **cuarta forma normal (4FN)**.

## 4FN: qué se revisa

Una tabla está en 4FN si está en FNBC y toda dependencia multivaluada no trivial X →→ Y tiene a X como superllave.
En la práctica, el problema aparece cuando una tabla guarda **dos listas independientes** del mismo dueño
(por ejemplo, teléfonos y correos de una persona en la misma tabla), lo que obliga a combinar cada valor de una lista con cada valor de la otra.

Se revisaron todas las tablas con llave compuesta, que son las únicas donde puede aparecer:

- Las tablas formadas solo por llave tienen **dos columnas** (dueño, valor). Con dos columnas toda dependencia multivaluada es trivial.
- Las demás tienen atributos que dependen de la llave completa (ya están en FNBC) y no mezclan listas independientes.
- Los atributos multivaluados ya quedaron cada uno en su propia tabla en la [reducción a tablas](../Modelado/).

Por eso **ningún esquema cambia**: los diez ya están en 4FN.

### Veterinaria

**Clínica veterinaria** · 9 tablas en FNBC ([Normalización hasta FNBC](Veterinaria.pdf)).

4FN: DUE_TELEFONO(cedula, telefono) solo tiene dos columnas. RECETA y MASCOTA tienen atributos que dependen de la llave completa (dosis, dias / nombre, especie…), no hay dos listas independientes. **Cumple 4FN.**

### Festival

**Festival de música** · 10 tablas en FNBC ([Normalización hasta FNBC](Festival.pdf)).

4FN: ART_GENERO y BOLETA_JORNADA tienen dos columnas. El género de un artista y sus presentaciones son hechos independientes, y por eso ya van en tablas separadas (ART_GENERO, PRESENTACION). **Cumple 4FN.**

### Mensajeria

**Empresa de mensajería** · 8 tablas en FNBC ([Normalización hasta FNBC](Mensajeria.pdf)).

4FN: SEGUIMIENTO(guia, consecutivo, …): cada consecutivo determina un solo estado y fecha. No hay listas independientes en una misma tabla. **Cumple 4FN.**

### Inmobiliaria

**Agencia inmobiliaria** · 7 tablas en FNBC ([Normalización hasta FNBC](Inmobiliaria.pdf)).

4FN: PROP_TELEFONO tiene dos columnas. VISITA(cliente, matricula, fecha, …): hora, interes y comentario dependen de la visita completa. **Cumple 4FN.**

### Concesionario

**Concesionario de vehículos** · 9 tablas en FNBC ([Normalización hasta FNBC](Concesionario.pdf)).

4FN: VEH_ACCESORIO(vin, id_accesorio) tiene dos columnas. Los accesorios de un vehículo y su venta van en tablas distintas. **Cumple 4FN.**

### Hotel

**Cadena hotelera** · 7 tablas en FNBC ([Normalización hasta FNBC](Hotel.pdf)).

4FN: ALOJAMIENTO y CONSUMO tienen atributos que dependen de la llave completa (tarifa_noche, cantidad). Las habitaciones de una reserva y sus consumos son independientes y ya están separados. **Cumple 4FN.**

### Cines

**Cadena de cines** · 7 tablas en FNBC ([Normalización hasta FNBC](Cines.pdf)).

4FN: CINE_TELEFONO tiene dos columnas. TIQUETE(funcion, fila, silla) determina un único cliente y valor. **Cumple 4FN.**

### CursosEnLinea

**Plataforma de cursos en línea** · 5 tablas en FNBC ([Normalización hasta FNBC](CursosEnLinea.pdf)).

4FN: CURSO_IDIOMA tiene dos columnas. Los idiomas de un curso y sus inscripciones son independientes y ya están en tablas distintas. **Cumple 4FN.**

### TallerMecanico

**Taller mecánico** · 9 tablas en FNBC ([Normalización hasta FNBC](TallerMecanico.pdf)).

4FN: TRABAJO y REPUESTO_ORDEN tienen atributos de la llave completa. Los mecánicos de una orden y sus repuestos son independientes y ya están separados. **Cumple 4FN.**

### LigaEsports

**Liga de e-sports** · 7 tablas en FNBC ([Normalización hasta FNBC](LigaEsports.pdf)).

4FN: INSCRIPCION y ESTADISTICA tienen atributos de la llave completa (fecha_inscripcion, kills…). No hay dos listas independientes en una tabla. **Cumple 4FN.**
