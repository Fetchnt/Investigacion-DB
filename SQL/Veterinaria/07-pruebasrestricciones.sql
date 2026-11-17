-- =====================================================================
--  Clínica veterinaria · 07-pruebasrestricciones.sql
--  Sentencias que DEBEN fallar. Se ejecuta con: mysql --force
--  Motor: MySQL 8.0  ·  Base de datos: veterinaria
-- =====================================================================

USE veterinaria;

START TRANSACTION;

-- 1. Dueño con una cédula que ya existe
--    Error esperado: 1062 (llave duplicada)
INSERT INTO DUENO VALUES ('1012345678', 'Pedro', 'Perez', 'Cll 1 # 2-3', NULL);

-- 2. Mascota de un dueño que no existe
--    Error esperado: 1452 (el padre no existe)
INSERT INTO MASCOTA VALUES ('99999999', 1, 'Fido', 'perro', NULL, '2020-01-01');

-- 3. Repetir el discriminador dentro del mismo dueño
--    Error esperado: 1062 (llave duplicada)
INSERT INTO MASCOTA VALUES ('1012345678', 1, 'Otra', 'gato', NULL, '2022-01-01');

-- 4. Borrar un veterinario que tiene consultas
--    Error esperado: 1451 (el registro tiene hijos)
DELETE FROM VETERINARIO WHERE id_veterinario = 1;

-- 5. Especie que la clínica no atiende
--    Error esperado: 3819 (viola chk_mascota_especie)
INSERT INTO MASCOTA VALUES ('79456123', 2, 'Dino', 'dinosaurio', NULL, '2020-01-01');

-- 6. Triage fuera de rango
--    Error esperado: 3819 (viola chk_urgencia_triage)
INSERT INTO URGENCIA VALUES (1, 7);

-- 7. Receta de un medicamento que no está en el catálogo
--    Error esperado: 1452 (el padre no existe)
INSERT INTO RECETA VALUES (1, 'MED-99', '1 al dia', 3);

-- 8. Consulta con valor negativo
--    Error esperado: 3819 (viola chk_consulta_valor)
UPDATE CONSULTA SET valor = -5000 WHERE id_consulta = 1;

-- 9. Tarjeta profesional repetida
--    Error esperado: 1062 (llave duplicada)
INSERT INTO VETERINARIO VALUES (5, 'Ana Mora', 'TP-10234', 'Cirugia');

ROLLBACK;
