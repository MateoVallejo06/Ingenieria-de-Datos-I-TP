USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 5 - CONSULTAS BASICAS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Listar animales vendidos
SELECT id_animal, codigo_unico, categoria, estado_animal
FROM Animal
WHERE estado_animal = 'Vendido';


-- 2. Listar animales por categoria
SELECT id_animal, codigo_unico, categoria, sexo
FROM Animal
WHERE categoria = 'Ternero';


-- 3. Listar los lotes del campo
SELECT *
FROM Lote;


-- 4. Listar camiones disponibles
SELECT id_camion, patente, marca, modelo, capacidad_maxima, estado_camion
FROM Camion
WHERE estado_camion = 'Disponible';


-- 5. Listar choferes registrados
SELECT id_chofer, nombre, apellido, dni, telefono
FROM Chofer;


-- 6. Listar viajes externos
SELECT id_viaje, tipo_viaje, fecha_viaje, origen, destino, estado_viaje
FROM Viaje
WHERE tipo_viaje = 'Externo';


-- 7. Listar viajes finalizados
SELECT id_viaje, fecha_viaje, origen, destino, estado_viaje
FROM Viaje
WHERE estado_viaje = 'Finalizado';


-- 8. Listar ventas finalizadas
SELECT id_venta, fecha_venta, cantidad_animales, peso_total, precio_por_kilo, monto_total
FROM Venta
WHERE estado_venta = 'Finalizada';


-- 9. Listar clientes compradores
SELECT id_cliente, nombre, cuit, telefono
FROM Cliente;


-- 10. Listar consignatarios con comision registrada
SELECT id_consignatario, nombre, cuit, porcentaje_comision
FROM Consignatario
WHERE porcentaje_comision IS NOT NULL;