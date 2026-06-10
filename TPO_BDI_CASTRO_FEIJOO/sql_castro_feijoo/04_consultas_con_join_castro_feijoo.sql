USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 5 - CONSULTAS CON JOIN
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Mostrar animales y el lote donde se encuentran
SELECT a.id_animal, a.codigo_unico, a.categoria, a.estado_animal, l.nombre_lote AS lote_actual
FROM Animal AS a
INNER JOIN Lote AS l ON a.id_lote_actual = l.id_lote;


-- 2. Mostrar movimientos internos con lote de origen y destino
SELECT m.id_movimiento, a.codigo_unico, lo.nombre_lote AS lote_origen, ld.nombre_lote AS lote_destino, m.fecha_movimiento, m.motivo
FROM MovimientoLote AS m
INNER JOIN Animal AS a ON m.id_animal = a.id_animal
INNER JOIN Lote AS lo ON m.id_lote_origen = lo.id_lote
INNER JOIN Lote AS ld ON m.id_lote_destino = ld.id_lote;


-- 3. Mostrar movimientos registrados por cada usuario
SELECT m.id_movimiento, a.codigo_unico, u.usuario, u.rol, m.fecha_movimiento, m.motivo
FROM MovimientoLote AS m
INNER JOIN Animal AS a ON m.id_animal = a.id_animal
INNER JOIN Usuario AS u ON m.id_usuario = u.id_usuario;


-- 4. Mostrar viajes con el camion y chofer asignado
SELECT v.id_viaje, v.tipo_viaje, v.fecha_viaje, v.origen, v.destino, c.patente, c.marca, ch.nombre, ch.apellido
FROM Viaje AS v
INNER JOIN Camion AS c ON v.id_camion = c.id_camion
INNER JOIN Chofer ch ON v.id_chofer = ch.id_chofer;


-- 5. Mostrar todos los camiones y los viajes que realizaron. Incluir también los camiones que no hicieron viajes
SELECT c.id_camion, c.patente, c.marca, v.id_viaje, v.fecha_viaje, v.destino
FROM Camion AS c
LEFT JOIN Viaje AS v ON v.id_camion = c.id_camion;


-- 6. Mostrar pesajes asociados a cada viaje
SELECT v.id_viaje, v.fecha_viaje, v.destino, p.fecha_pesaje, p.peso_total
FROM Viaje AS v
INNER JOIN Pesaje AS p ON v.id_viaje = p.id_viaje;


-- 7. Mostrar todos los consignatarios y las ventas asociadas. Incluir también los consignatarios que todavía no hicieron ventas
SELECT c.id_consignatario, c.nombre, v.id_venta, v.fecha_venta, v.monto_total
FROM Venta AS v
RIGHT JOIN Consignatario AS c ON v.id_consignatario = c.id_consignatario;