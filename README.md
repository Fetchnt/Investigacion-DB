# Portafolio de Bases de Datos

**Miguel Lopez ([Fetchnt](https://github.com/Fetchnt))** · Bases de Datos 1 · Universidad El Bosque · [fetchnt.github.io](https://fetchnt.github.io)

Diez ejercicios resueltos de principio a fin: enunciado → MER y MER-E (Peter Chen y pata de gallina) →
reducción a tablas → modelo relacional → normalización hasta 4FN → implementación en MySQL con consultas y álgebra relacional.

## Ejercicios

| Ejercicio | Tablas | Modelado | Normalización | SQL |
|---|---|---|---|---|
| [Clínica veterinaria](Modelado/Veterinaria/) | 9 | [Modelado](Modelado/Veterinaria/) · [Reducción](Modelado/Veterinaria/Reduccion.md) | [PDF](Normalizacion/Veterinaria.pdf) | [Scripts](SQL/Veterinaria/) · [Consultas](SQL/Veterinaria/consultas.md) · [Álgebra](SQL/Veterinaria/algebra.md) |
| [Festival de música](Modelado/Festival/) | 10 | [Modelado](Modelado/Festival/) · [Reducción](Modelado/Festival/Reduccion.md) | [PDF](Normalizacion/Festival.pdf) | [Scripts](SQL/Festival/) · [Consultas](SQL/Festival/consultas.md) · [Álgebra](SQL/Festival/algebra.md) |
| [Empresa de mensajería](Modelado/Mensajeria/) | 8 | [Modelado](Modelado/Mensajeria/) · [Reducción](Modelado/Mensajeria/Reduccion.md) | [PDF](Normalizacion/Mensajeria.pdf) | [Scripts](SQL/Mensajeria/) · [Consultas](SQL/Mensajeria/consultas.md) · [Álgebra](SQL/Mensajeria/algebra.md) |
| [Agencia inmobiliaria](Modelado/Inmobiliaria/) | 7 | [Modelado](Modelado/Inmobiliaria/) · [Reducción](Modelado/Inmobiliaria/Reduccion.md) | [PDF](Normalizacion/Inmobiliaria.pdf) | [Scripts](SQL/Inmobiliaria/) · [Consultas](SQL/Inmobiliaria/consultas.md) · [Álgebra](SQL/Inmobiliaria/algebra.md) |
| [Concesionario de vehículos](Modelado/Concesionario/) | 9 | [Modelado](Modelado/Concesionario/) · [Reducción](Modelado/Concesionario/Reduccion.md) | [PDF](Normalizacion/Concesionario.pdf) | [Scripts](SQL/Concesionario/) · [Consultas](SQL/Concesionario/consultas.md) · [Álgebra](SQL/Concesionario/algebra.md) |
| [Cadena hotelera](Modelado/Hotel/) | 7 | [Modelado](Modelado/Hotel/) · [Reducción](Modelado/Hotel/Reduccion.md) | [PDF](Normalizacion/Hotel.pdf) | [Scripts](SQL/Hotel/) · [Consultas](SQL/Hotel/consultas.md) · [Álgebra](SQL/Hotel/algebra.md) |
| [Cadena de cines](Modelado/Cines/) | 7 | [Modelado](Modelado/Cines/) · [Reducción](Modelado/Cines/Reduccion.md) | [PDF](Normalizacion/Cines.pdf) | [Scripts](SQL/Cines/) · [Consultas](SQL/Cines/consultas.md) · [Álgebra](SQL/Cines/algebra.md) |
| [Plataforma de cursos en línea](Modelado/CursosEnLinea/) | 5 | [Modelado](Modelado/CursosEnLinea/) · [Reducción](Modelado/CursosEnLinea/Reduccion.md) | [PDF](Normalizacion/CursosEnLinea.pdf) | [Scripts](SQL/CursosEnLinea/) · [Consultas](SQL/CursosEnLinea/consultas.md) · [Álgebra](SQL/CursosEnLinea/algebra.md) |
| [Taller mecánico](Modelado/TallerMecanico/) | 9 | [Modelado](Modelado/TallerMecanico/) · [Reducción](Modelado/TallerMecanico/Reduccion.md) | [PDF](Normalizacion/TallerMecanico.pdf) | [Scripts](SQL/TallerMecanico/) · [Consultas](SQL/TallerMecanico/consultas.md) · [Álgebra](SQL/TallerMecanico/algebra.md) |
| [Liga de e-sports](Modelado/LigaEsports/) | 7 | [Modelado](Modelado/LigaEsports/) · [Reducción](Modelado/LigaEsports/Reduccion.md) | [PDF](Normalizacion/LigaEsports.pdf) | [Scripts](SQL/LigaEsports/) · [Consultas](SQL/LigaEsports/consultas.md) · [Álgebra](SQL/LigaEsports/algebra.md) |

La revisión de 4FN de los diez esquemas está en [Normalizacion/README.md](Normalizacion/README.md).

## Proyecto final

[VesperaRoom](https://github.com/Fetchnt/vesperaroom)

## Cómo ejecutar los scripts

Requiere MySQL 8.0.31 o superior (por `INTERSECT` y `EXCEPT`). Desde la carpeta `SQL/<ejercicio>`:

```sh
mysql -u root -p < 01-creacionobjetos.sql
mysql -u root -p < 02-insercionregistros.sql
mysql -u root -p < 03-usuariospermisos.sql
mysql -u root -p < 04-restriccionesadicionales.sql
mysql -u root -p < 05-vistas.sql            # opcional
mysql -u root -p < 06-verificacion.sql
mysql -u root -p --force < 07-pruebasrestricciones.sql   # opcional: todo debe fallar
mysql -u root -p < 08-consultas.sql
```

`00-eliminarobjetos.sql` borra todo para reinstalar. El `README.txt` de cada carpeta dice qué resultado esperar de cada script,
y `consultas.md` muestra el resultado de cada consulta.

## Estructura

```
Modelado/<ejercicio>/   enunciado, MER, MER-E, reducción a tablas y modelo relacional (PDF + drawio editable)
Normalizacion/          normalización de cada ejercicio (0FN → FNBC) y revisión de 4FN
SQL/<ejercicio>/        scripts 00–08, consultas con resultado y álgebra relacional
Proyecto/               enlace al proyecto final
```
