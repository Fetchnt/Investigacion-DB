=====================================================================
 Cadena hotelera - Scripts de implementacion de la base de datos
 Bases de Datos 1 - Universidad El Bosque
=====================================================================

1. DESCRIPCION
---------------------------------------------------------------------
Scripts que pasan el modelo relacional del ejercicio Cadena hotelera
(ver Modelado/Hotel) al modelo fisico en MySQL.

  RDBMS ............ MySQL 8.0 (8.0.31 o superior por INTERSECT/EXCEPT)
  Base de datos .... hotel
  Codificacion ..... utf8mb4 / utf8mb4_0900_ai_ci
  Tablas ........... 7 (motor InnoDB)
  Registros ........ 53 (datos de prueba)

2. CONTENIDO
---------------------------------------------------------------------
  Archivo                          Que hace
  -------------------------------- ------------------------------------
  00-eliminarobjetos.sql           Borra vistas y tablas (reinstalar)
  01-creacionobjetos.sql           Crea la BD y las 7 tablas con PK, FK y UNIQUE
  02-insercionregistros.sql        Inserta los 53 registros de prueba
  03-usuariospermisos.sql          Usuarios con el minimo privilegio
  04-restriccionesadicionales.sql  CHECK y UNIQUE de las reglas del negocio
  05-vistas.sql                    Vistas de consulta (OPCIONAL)
  06-verificacion.sql              Verificacion de solo lectura
  07-pruebasrestricciones.sql      Pruebas que deben fallar (ROLLBACK)
  08-consultas.sql                 Consultas por capitulo (C2 a C9)
  consultas.md                     Las mismas consultas con su resultado
  algebra.md                       Consultas en algebra relacional

3. ORDEN DE EJECUCION
---------------------------------------------------------------------
  [00] -> 01 -> 02 -> 03 -> 04 -> [05] -> 06 -> [07] -> 08
  00 solo si la base ya existe y se quiere empezar de cero.
  05 y 07 son opcionales.

  Desde la consola:
    mysql -u root -p < 01-creacionobjetos.sql
  El 07 se corre con --force para que siga despues de cada error:
    mysql -u root -p --force < 07-pruebasrestricciones.sql

4. RESULTADOS ESPERADOS
---------------------------------------------------------------------
  01  7 tablas creadas sin errores.
  02  53 registros insertados en una sola transaccion.
  03  Usuarios hotel_app y hotel_lectura. CAMBIE las contrasenas.
  04  Al final muestra 10 restricciones.
  05  2 vistas.
  06  7 tablas InnoDB y los conteos. Desde la seccion 3 no
      devuelve filas.
  07  Las 9 sentencias fallan con el error de su comentario
      (1062, 1451, 1452, 3819). Termina en ROLLBACK.
  08  Los resultados de cada consulta estan en consultas.md (calculados
      con fecha de referencia 2026-11-16 cuando la consulta usa CURDATE()).

5. NOTAS
---------------------------------------------------------------------
 - Ningun script tiene contrasenas reales.
 - Los datos no llevan tildes para evitar problemas de codificacion
   al copiar los scripts.
 - Que una habitacion no quede en dos reservas que se crucen, que los
   consumos esten dentro de la estadia y que toda reserva tenga
   habitacion miran otras tablas: se revisan con el 06.
 - BOOLEAN en MySQL es un alias de TINYINT(1): jacuzzi guarda 1 o 0.
