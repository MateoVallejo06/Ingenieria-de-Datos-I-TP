USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 4 - CARGAS DE DATOS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- LOTES

INSERT INTO Lote (nombre_lote, descripcion)
VALUES 
('L1', 'Lote cercano al sector norte'),
('L2', 'Lote de recria'),
('L6', 'Lote de engorde'),
('L7', 'Lote de terneros'),
('L8', 'Lote de vacas madres'),
('L9', 'Lote de toros'),
('L10', 'Lote de encierre'),
('L11', 'Lote previo a carga');


-- ANIMALES

INSERT INTO Animal
(codigo_unico, fecha_nacimiento, sexo, categoria, estado_animal, id_lote_actual)
VALUES
('AN001', '2023-01-10', 'F', 'Vaca', 'Vendido', 1),
('AN002', '2023-02-12', 'F', 'Vaquillona', 'Vendido', 1),
('AN003', '2022-11-05', 'M', 'Toro', 'Vendido', 2),
('AN004', '2023-03-18', 'M', 'Ternero', 'Activo', 2),
('AN005', '2023-04-20', 'F', 'Ternero', 'Activo', 3),
('AN006', '2022-09-15', 'M', 'Torito', 'Activo', 3),
('AN007', '2023-01-22', 'F', 'Vaca', 'Muerto', 4),
('AN008', '2023-02-01', 'F', 'Vaquillona', 'Activo', 4),
('AN009', '2023-03-11', 'M', 'Ternero', 'Activo', 5),
('AN010', '2022-08-30', 'M', 'Toro', 'Activo', 5),
('AN011', '2023-02-14', 'F', 'Vaca', 'Activo', 6),
('AN012', '2023-01-17', 'F', 'Vaquillona', 'Activo', 6),
('AN013', '2023-03-21', 'M', 'Ternero', 'Activo', 7),
('AN014', '2023-04-10', 'F', 'Ternero', 'Muerto', 7),
('AN015', '2022-10-01', 'M', 'Torito', 'Activo', 8),
('AN016', '2023-01-19', 'F', 'Vaca', 'Activo', 8),
('AN017', '2023-02-25', 'F', 'Vaquillona', 'Activo', 1),
('AN018', '2023-03-05', 'M', 'Ternero', 'Activo', 2),
('AN019', '2023-01-30', 'F', 'Ternero', 'Activo', 3),
('AN020', '2022-07-14', 'M', 'Toro', 'Activo', 4),
('AN021', '2023-02-08', 'F', 'Vaca', 'Activo', 5),
('AN022', '2023-03-12', 'M', 'Ternero', 'Activo', 6),
('AN023', '2023-04-01', 'F', 'Vaquillona', 'Activo', 7),
('AN024', '2023-02-27', 'M', 'Torito', 'Activo', 8),
('AN025', '2023-01-09', 'F', 'Vaca', 'Activo', 1);


-- USUARIOS

INSERT INTO Usuario 
(nombre, apellido, email, usuario, contrasenia, rol, estado_usuario)
VALUES
('Felipe', 'Toscano', 'felipe@castrofeijoo.com', 'ftoscano', '1234', 'Gerente', 'Activo'),
('Juan', 'Vallejo', 'juan@castrofeijoo.com', 'jvallejo', '1234', 'Administracion', 'Activo'),
('Martin', 'Bonello', 'martin@castrofeijoo.com', 'mbonello', '1234', 'Operador', 'Activo');


-- MOVIMIENTOS ENTRE LOTES

INSERT INTO MovimientoLote
(id_animal, id_lote_origen, id_lote_destino, fecha_movimiento, motivo, id_usuario)
VALUES
(1, 1, 2, '2025-05-10', 'Cambio de lote', 3),
(4, 2, 3, '2025-05-11', 'Recria', 3),
(7, 4, 5, '2025-05-12', 'Preparacion para venta', 2),
(10, 5, 6, '2025-05-13', 'Traslado interno', 3),
(15, 8, 7, '2025-05-14', 'Control de carga', 1);


-- CAMIONES

INSERT INTO Camion
(patente, marca, modelo, capacidad_maxima, estado_camion)
VALUES
('AA123BB', 'Scania', 'R450', 75, 'Disponible'),
('AC456CD', 'Volvo', 'FH', 75, 'Disponible'),
('AE789EF', 'Mercedes Benz', 'Actros', 75, 'En viaje'),
('AG147GH', 'Iveco', 'Stralis', 50, 'Disponible'),
('AI258IJ', 'Volkswagen', 'Meteor', 75, 'Fuera de servicio'),
('AK369KL', 'Ford', 'Cargo', 50, 'Disponible'),
('AM741MN', 'Scania', 'P360', 75, 'Disponible');


-- CHOFERES

INSERT INTO Chofer
(nombre, apellido, dni, telefono)
VALUES
('Carlos', 'Gutierrez', '30111222', '2664123456'),
('Miguel', 'Pagnat', '28999888', '2664234567'),
('Luis', 'Vallejo', '31222444', '2664345678'),
('Jorge', 'Martinez', '27888777', '2664456789');


-- VIAJES

INSERT INTO Viaje
(tipo_viaje, fecha_viaje, hora_salida, hora_llegada, origen, destino, estado_viaje, id_camion, id_chofer)
VALUES
('Interno', '2025-06-01', '08:00:00', '09:00:00', 'L1', 'L6', 'Finalizado', 1, 1),
('Externo', '2025-06-03', '06:30:00', '12:00:00', 'San Carlos', 'Feria Villa Mercedes', 'Finalizado', 2, 2),
('Interno', '2025-06-05', '10:00:00', '11:00:00', 'L2', 'L10', 'Finalizado', 3, 3),
('Externo', '2025-06-07', '05:30:00', '13:00:00', 'San Carlos', 'Feria Rio Cuarto', 'En curso', 4, 4),
('Interno', '2025-06-08', '06:30:00', '14:00:00', 'L11', 'L9', 'Pendiente', 1, 1);


-- DETALLE VIAJE ANIMAL

INSERT INTO DetalleViajeAnimal
(id_viaje, id_animal, estado_carga, observaciones)
VALUES
(1, 1, 'Cargado', 'Sin observaciones'),
(1, 2, 'Cargado', 'Sin observaciones'),
(1, 3, 'Cargado', 'Sin observaciones'),

(2, 4, 'Cargado', 'Venta programada'),
(2, 5, 'Cargado', 'Venta programada'),
(2, 6, 'Cargado', 'Venta programada'),
(2, 7, 'Cargado', 'Venta programada'),

(3, 8, 'Cargado', 'Movimiento interno'),
(3, 9, 'Cargado', 'Movimiento interno'),

(4, 10, 'Cargado', 'Venta en feria'),
(4, 11, 'Cargado', 'Venta en feria'),
(4, 12, 'Cargado', 'Venta en feria');


-- PESAJES

INSERT INTO Pesaje
(id_viaje, fecha_pesaje, peso_total, observaciones)
VALUES
(1, '2025-06-01', 12450.50, 'Pesaje interno'),
(2, '2025-06-03', 18500.75, 'Pesaje previo a feria'),
(3, '2025-06-05', 9800.00, 'Movimiento entre lotes'),
(4, '2025-06-07', 21000.25, 'Venta programada');


-- CONSIGNATARIOS

INSERT INTO Consignatario
(nombre, cuit, telefono, direccion, porcentaje_comision)
VALUES
('Consignataria San Luis', '30-12345678-9', '2664556677', 'San Luis Capital', 5.50),
('Ganadera Central', '30-98765432-1', '3514558899', 'Cordoba', 6.00);


-- FERIAS GANADERAS

INSERT INTO FeriaGanadera
(nombre, localidad, provincia, direccion)
VALUES
('Feria Villa Mercedes', 'Villa Mercedes', 'San Luis', 'Ruta 7 KM 695'),
('Feria Rio Cuarto', 'Rio Cuarto', 'Cordoba', 'Ruta Nacional 8');


-- CLIENTES

INSERT INTO Cliente
(nombre, cuit, telefono, direccion)
VALUES
('Agropecuaria La Pampa', '30-45678912-3', '2954123456', 'Santa Rosa'),
('Ganados del Sur', '30-11223344-5', '3514778899', 'Cordoba');


-- VENTAS

INSERT INTO Venta
(fecha_venta, cantidad_animales, peso_total, precio_por_kilo, estado_venta,
id_consignatario, id_feria, id_cliente)
VALUES
('2025-06-03', 4, 18500.75, 3200, 'Finalizada', 1, 1, 1),
('2025-06-07', 3, 21000.25, 3500, 'Pendiente', 2, 2, 2),
('2025-06-12', 2, 9200.50, 3300, 'Finalizada', 1, 1, 2),
('2025-06-18', 5, 28400.00, 3150.00, 'Pendiente', 2, 2, 1);


-- DETALLE VENTA ANIMAL

INSERT INTO DetalleVentaAnimal
(id_venta, id_animal)
VALUES
(1, 4),
(1, 5),
(1, 6),
(1, 10),
(2, 11),
(2, 12),
(2, 18);