-- =====================================================================
--  Concesionario de vehículos · 08-consultas.sql
--  Consultas por capítulo (C2 a C9). Resultados en consultas.md.
--  Motor: MySQL 8.0  ·  Base de datos: concesionario
-- =====================================================================

USE concesionario;

-- ---------------------------------------------------------------------
-- C2 · Recuperar datos con SELECT
-- ---------------------------------------------------------------------

-- 1. Vehículos con su precio de lista y la cuota inicial del 30 %.
SELECT marca, modelo, precio_lista, precio_lista * 0.30 AS cuota_inicial
FROM VEHICULO;

-- 2. Marcas que hay en el inventario, sin repetir.
SELECT DISTINCT marca
FROM VEHICULO
ORDER BY marca;

-- ---------------------------------------------------------------------
-- C3 · Restringir y ordenar
-- ---------------------------------------------------------------------

-- 3. Vehículos de 2022 en adelante que cuestan menos de 120 millones, del más barato al más caro.
SELECT marca, modelo, anio, precio_lista
FROM VEHICULO
WHERE anio >= 2022 AND precio_lista < 120000000
ORDER BY precio_lista;

-- 4. Clientes que no registraron correo.
SELECT documento, nombres, apellidos, telefono
FROM CLIENTE
WHERE correo IS NULL;

-- 5. Vehículos Mazda, Toyota o Hyundai que no son negros.
SELECT marca, modelo, color
FROM VEHICULO
WHERE marca IN ('Mazda', 'Toyota', 'Hyundai') AND color <> 'Negro'
ORDER BY marca, modelo;

-- ---------------------------------------------------------------------
-- C4 · Funciones de una sola fila
-- ---------------------------------------------------------------------

-- 6. Antigüedad de cada vendedor en años (atributo derivado).
SELECT nombre, fecha_ingreso,
       TIMESTAMPDIFF(YEAR, fecha_ingreso, CURDATE()) AS antiguedad
FROM VENDEDOR
ORDER BY antiguedad DESC;

-- 7. Fabricante (los tres primeros caracteres del VIN) y marca en mayúsculas.
SELECT vin, SUBSTRING(vin, 1, 3) AS wmi, UPPER(marca) AS marca,
       CHAR_LENGTH(vin) AS largo
FROM VEHICULO
ORDER BY wmi;

-- ---------------------------------------------------------------------
-- C5 · Funciones de conversión y condicionales
-- ---------------------------------------------------------------------

-- 8. Mes de cada venta y valor convertido a entero (sin decimales).
SELECT numero_factura, DATE_FORMAT(fecha, '%Y-%m') AS mes,
       CAST(valor_final AS UNSIGNED) AS valor
FROM VENTA
ORDER BY numero_factura;

-- 9. Usados clasificados por kilometraje.
SELECT placa, kilometraje,
       CASE WHEN kilometraje < 30000 THEN 'Como nuevo'
            WHEN kilometraje < 70000 THEN 'Recorrido medio'
            ELSE 'Alto recorrido' END AS estado
FROM VEHICULO_USADO
ORDER BY kilometraje;

-- 10. Clientes con el correo o un aviso si no lo tienen.
SELECT apellidos, IFNULL(correo, 'sin correo') AS contacto
FROM CLIENTE
ORDER BY apellidos;

-- ---------------------------------------------------------------------
-- C6 · Funciones de grupo
-- ---------------------------------------------------------------------

-- 11. Ventas y valor total por forma de pago.
SELECT forma_pago, COUNT(*) AS ventas, SUM(valor_final) AS total
FROM VENTA
GROUP BY forma_pago
ORDER BY total DESC;

-- 12. Marcas con dos o más vehículos y su rango de precios.
SELECT marca, COUNT(*) AS vehiculos, MIN(precio_lista) AS minimo, MAX(precio_lista) AS maximo
FROM VEHICULO
GROUP BY marca
HAVING COUNT(*) >= 2;

-- ---------------------------------------------------------------------
-- C7 · Joins
-- ---------------------------------------------------------------------

-- 13. Cada venta con el cliente, el vendedor y el vehículo, y la comisión.
SELECT ve.numero_factura, c.apellidos AS cliente, vd.nombre AS vendedor,
       v.marca, v.modelo,
       ROUND(ve.valor_final * vd.porcentaje_comision / 100, 0) AS comision
FROM VENTA ve
JOIN CLIENTE c ON c.documento = ve.documento_cliente
JOIN VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
JOIN VEHICULO v ON v.vin = ve.vin
ORDER BY ve.numero_factura;

-- 14. Vehículos con la ciudad de su sede (JOIN ... USING sobre id_sede).
SELECT marca, modelo, ciudad
FROM VEHICULO
JOIN SEDE USING (id_sede)
ORDER BY ciudad, marca;

-- 15. Todos los vehículos y, si se vendieron, la factura (LEFT JOIN).
SELECT v.marca, v.modelo, ve.numero_factura
FROM VEHICULO v
LEFT JOIN VENTA ve ON ve.vin = v.vin
ORDER BY ve.numero_factura IS NULL, ve.numero_factura, v.vin;

-- ---------------------------------------------------------------------
-- C8 · Subconsultas
-- ---------------------------------------------------------------------

-- 16. Vehículos que siguen disponibles.
SELECT vin, marca, modelo, precio_lista
FROM VEHICULO
WHERE vin NOT IN (SELECT vin FROM VENTA);

-- 17. Usados más baratos que el precio promedio de los nuevos.
SELECT v.marca, v.modelo, v.precio_lista
FROM VEHICULO v
JOIN VEHICULO_USADO u ON u.vin = v.vin
WHERE v.precio_lista < (SELECT AVG(x.precio_lista)
                        FROM VEHICULO x
                        JOIN VEHICULO_NUEVO n ON n.vin = x.vin)
ORDER BY v.precio_lista;

-- 18. El vendedor que más ha vendido en pesos.
SELECT id_vendedor, SUM(valor_final) AS total
FROM VENTA
GROUP BY id_vendedor
HAVING SUM(valor_final) >= ALL (SELECT SUM(valor_final)
                               FROM VENTA
                               GROUP BY id_vendedor);

-- ---------------------------------------------------------------------
-- C9 · Operadores de conjunto
-- ---------------------------------------------------------------------

-- 19. Marcas que se ofrecen tanto en Bogotá como en Medellín.
SELECT marca FROM VEHICULO JOIN SEDE USING (id_sede) WHERE ciudad = 'Bogota'
INTERSECT
SELECT marca FROM VEHICULO JOIN SEDE USING (id_sede) WHERE ciudad = 'Medellin';

-- 20. Accesorios que aparecen en vehículos nuevos o en usados (UNION).
SELECT a.id_accesorio FROM VEH_ACCESORIO a JOIN VEHICULO_NUEVO n ON n.vin = a.vin
UNION
SELECT a.id_accesorio FROM VEH_ACCESORIO a JOIN VEHICULO_USADO u ON u.vin = a.vin
ORDER BY id_accesorio;

-- 21. Clientes que han comprado a crédito pero nunca de contado.
SELECT documento_cliente FROM VENTA WHERE forma_pago = 'credito'
EXCEPT
SELECT documento_cliente FROM VENTA WHERE forma_pago = 'contado';
