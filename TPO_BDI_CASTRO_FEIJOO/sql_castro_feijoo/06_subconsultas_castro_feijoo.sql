USE CastroFeijooBDI;
GO

-- ========================================================= 
-- ETAPA 5 - SUBCONSULTAS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Subconsulta escalar: ventas que el monto total supere el promedio general de ventas
SELECT id_venta, fecha_venta, monto_total
FROM Venta
WHERE monto_total > (
    SELECT AVG(monto_total)
    FROM Venta
);


-- 2. Subconsulta con IN: clientes que tienen ventas finalizadas
SELECT id_cliente, nombre, cuit
FROM Cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM Venta
    WHERE estado_venta = 'Finalizada'
);


-- 3. Subconsulta con EXISTS: camiones que realizaron al menos un viaje externo
SELECT patente, marca, modelo
FROM Camion AS c
WHERE EXISTS (
    SELECT 1
    FROM Viaje AS v
    WHERE v.id_camion = c.id_camion
      AND v.tipo_viaje = 'Externo'
);


-- 4. Subconsulta correlacionada: ventas que el monto supere el promedio de ventas del mismo consignatario
SELECT v1.id_venta, v1.id_consignatario, v1.fecha_venta, v1.monto_total
FROM Venta AS v1
WHERE v1.monto_total > (
    SELECT AVG(v2.monto_total)
    FROM Venta AS v2
    WHERE v2.id_consignatario = v1.id_consignatario
);