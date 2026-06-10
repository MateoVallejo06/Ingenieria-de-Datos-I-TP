USE CastroFeijooBDI;
GO 

-- =========================================================
-- ETAPA 6 - VISTAS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- STOCK ACTUAL POR LOTE Y CATEGORÍA

CREATE VIEW vista_stock_actual_lotes AS
SELECT l.id_lote, l.nombre_lote, a.categoria, COUNT(a.id_animal) AS cantidad_animales
FROM Lote AS l
LEFT JOIN Animal AS a ON l.id_lote = a.id_lote_actual
WHERE a.estado_animal = 'Activo'
GROUP BY l.id_lote, l.nombre_lote, a.categoria;

SELECT * FROM vista_stock_actual_lotes;


-- RESUMEN DE VENTAS

CREATE VIEW vista_resumen_ventas AS
SELECT v.id_venta, v.fecha_venta, c.nombre AS nombre_cliente, f.nombre AS nombre_feria, con.nombre AS nombre_consignatario, v.cantidad_animales, v.monto_total, v.estado_venta
FROM Venta AS v
JOIN Cliente AS c ON v.id_cliente = c.id_cliente
JOIN FeriaGanadera AS f ON v.id_feria = f.id_feria
JOIN Consignatario AS con ON v.id_consignatario = con.id_consignatario;

SELECT * FROM vista_resumen_ventas;


-- HISTORIAL DE MOVIMIENTOS INTERNOS

CREATE VIEW vista_historial_movimientos AS
SELECT m.id_movimiento, a.codigo_unico AS codigo_animal, lo.nombre_lote AS lote_origen, ld.nombre_lote AS lote_destino, m.fecha_movimiento, m.motivo
FROM MovimientoLote m
INNER JOIN Animal a ON m.id_animal = a.id_animal
INNER JOIN Lote lo ON m.id_lote_origen = lo.id_lote
INNER JOIN Lote ld ON m.id_lote_destino = ld.id_lote;

SELECT * FROM vista_historial_movimientos;


-- INFORMACIÓN DE VIAJES

CREATE VIEW vista_informacion_viajes AS
SELECT v.id_viaje, v.tipo_viaje, v.fecha_viaje, v.origen, v.destino, cam.patente AS patente_camion, ch.apellido AS apellido_chofer, v.estado_viaje
FROM Viaje v
JOIN Camion cam ON v.id_camion = cam.id_camion
JOIN Chofer ch ON v.id_chofer = ch.id_chofer;

SELECT * FROM vista_informacion_viajes;