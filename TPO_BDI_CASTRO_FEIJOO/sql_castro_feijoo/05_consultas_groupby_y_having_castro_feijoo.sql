USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 5 - CONSULTAS CON GROUP BY Y HAVING
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Contar la cantidad de animales por categoria
SELECT categoria, COUNT(*) AS cantidad_animales
FROM Animal
GROUP BY categoria;


-- 2. Contar la cantidad de animales por lote
SELECT l.nombre_lote, COUNT(a.id_animal) AS cantidad_animales
FROM Lote AS l
LEFT JOIN Animal AS a ON l.id_lote = a.id_lote_actual
GROUP BY l.nombre_lote;


-- 3. Mostrar solo los lotes que tienen mas de 3 animales
SELECT l.nombre_lote, COUNT(a.id_animal) AS cantidad_animales
FROM Lote AS l
INNER JOIN Animal AS a ON l.id_lote = a.id_lote_actual
GROUP BY l.nombre_lote
HAVING COUNT(a.id_animal) > 3;


-- 4. Contar la cantidad de viajes realizados por cada camion. Incluir los camiones que todavia no hicieron viajes
SELECT c.patente, COUNT(v.id_viaje) AS cantidad_viajes
FROM Camion AS c
LEFT JOIN Viaje AS v ON c.id_camion = v.id_camion
GROUP BY c.patente;


-- 5. Calcular el peso promedio registrado en los pesajes
SELECT AVG(peso_total) AS peso_promedio
FROM Pesaje;


-- 6. Calcular el peso total registrado por fecha de pesaje
SELECT fecha_pesaje, SUM(peso_total) AS peso_total_dia
FROM Pesaje
GROUP BY fecha_pesaje;


-- 7. Calcular el total vendido a cada cliente
SELECT c.nombre AS cliente, SUM(v.monto_total) AS total_vendido
FROM Cliente AS c
INNER JOIN Venta AS v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre;


-- 8. Mostrar clientes con compras superiores a 50000000
SELECT c.nombre AS cliente, SUM(v.monto_total) AS total_comprado
FROM Cliente AS c
INNER JOIN Venta AS v ON c.id_cliente = v.id_cliente
GROUP BY c.nombre
HAVING SUM(v.monto_total) > 50000000;


-- 9. Calcular el precio promedio por kilo por feria ganadera
SELECT f.nombre AS feria, AVG(v.precio_por_kilo) AS promedio_precio_kilo
FROM FeriaGanadera AS f
INNER JOIN Venta AS v ON f.id_feria = v.id_feria
GROUP BY f.nombre;