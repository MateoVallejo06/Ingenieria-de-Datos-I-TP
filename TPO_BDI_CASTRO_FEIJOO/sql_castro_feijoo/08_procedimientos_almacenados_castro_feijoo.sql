USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 7 - PROCEDIMIENTOS ALMACENADOS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Mover un animal de lote 

CREATE PROCEDURE sp_MoverAnimal
    @id_animal INT,
    @id_lote_destino INT,
    @motivo VARCHAR(255),
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_lote_origen INT;

    SELECT @id_lote_origen = id_lote_actual 
    FROM Animal 
    WHERE id_animal = @id_animal;

    IF @id_lote_origen = @id_lote_destino
    BEGIN
        PRINT 'Error: El animal ya se encuentra en el lote de destino.';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO MovimientoLote 
            (id_animal, id_lote_origen, id_lote_destino, fecha_movimiento, motivo, id_usuario)
        VALUES 
            (@id_animal, @id_lote_origen, @id_lote_destino, GETDATE(), @motivo, @id_usuario);

        UPDATE Animal
        SET id_lote_actual = @id_lote_destino
        WHERE id_animal = @id_animal;

        COMMIT TRAN;
        PRINT 'Movimiento registrado y estado actualizado con éxito.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        PRINT 'Ocurrió un error. Se revirtieron los cambios.';
    END CATCH
END;
GO


-- 2. Cargar un animal a un camión

CREATE PROCEDURE sp_CargarAnimal
    @id_viaje INT,
    @id_animal INT,
    @observaciones VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @cantidad_actual INT;
    DECLARE @capacidad_max INT;

    SELECT @capacidad_max = c.capacidad_maxima
    FROM Viaje v
    INNER JOIN Camion c ON v.id_camion = c.id_camion
    WHERE v.id_viaje = @id_viaje;

    SELECT @cantidad_actual = COUNT(*)
    FROM DetalleViajeAnimal 
    WHERE id_viaje = @id_viaje AND estado_carga = 'Cargado';

    IF @cantidad_actual >= @capacidad_max
    BEGIN
        PRINT 'Error: El camión ya alcanzó su capacidad máxima (' + CAST(@capacidad_max AS VARCHAR) + '). No se puede cargar.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM DetalleViajeAnimal WHERE id_viaje = @id_viaje AND id_animal = @id_animal)
    BEGIN
        PRINT 'Error: El animal ya se encuentra cargado en este viaje.';
        RETURN;
    END

    BEGIN TRY
        INSERT INTO DetalleViajeAnimal (id_viaje, id_animal, estado_carga, observaciones)
        VALUES (@id_viaje, @id_animal, 'Cargado', @observaciones);

        PRINT 'Animal cargado con éxito.';
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error al registrar la carga.';
    END CATCH
END;
GO

 
-- 3. Iniciar viaje

CREATE PROCEDURE sp_IniciarViaje
    @tipo_viaje VARCHAR(20),
    @origen VARCHAR(100),
    @destino VARCHAR(100),
    @id_camion INT,
    @id_chofer INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @estado_camion VARCHAR(30);

    SELECT @estado_camion = estado_camion 
    FROM Camion 
    WHERE id_camion = @id_camion;

    IF @estado_camion <> 'Disponible'
    BEGIN
        PRINT 'Error: El camión no está disponible (puede estar en viaje o fuera de servicio).';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO Viaje 
            (tipo_viaje, fecha_viaje, hora_salida, origen, destino, estado_viaje, id_camion, id_chofer)
        VALUES 
            (@tipo_viaje, CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME), @origen, @destino, 'En curso', @id_camion, @id_chofer);

        UPDATE Camion
        SET estado_camion = 'En viaje'
        WHERE id_camion = @id_camion;

        COMMIT TRAN;
        PRINT 'Viaje iniciado y camión asignado con éxito.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        PRINT 'Ocurrió un error. Se revirtieron los cambios.';
    END CATCH
END;
GO


-- 4. Finalizar viaje

CREATE PROCEDURE sp_FinalizarViaje
    @id_viaje INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_camion INT;

    SELECT @id_camion = id_camion 
    FROM Viaje 
    WHERE id_viaje = @id_viaje;

    BEGIN TRY
        BEGIN TRAN;

        UPDATE Viaje
        SET estado_viaje = 'Finalizado', 
            hora_llegada = CAST(GETDATE() AS TIME)
        WHERE id_viaje = @id_viaje;

        UPDATE Camion
        SET estado_camion = 'Disponible'
        WHERE id_camion = @id_camion;

        COMMIT TRAN;
        PRINT 'Viaje finalizado y camión liberado con éxito.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        PRINT 'Ocurrió un error. No se pudo finalizar el viaje.';
    END CATCH
END;
GO


-- 5. Registrar venta de un animal

CREATE PROCEDURE sp_RegistrarAnimalVendido
    @id_venta INT,
    @id_animal INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Animal WHERE id_animal = @id_animal AND estado_animal = 'Vendido')
    BEGIN
        PRINT 'Error: El animal ya figura como vendido en el sistema.';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO DetalleVentaAnimal (id_venta, id_animal)
        VALUES (@id_venta, @id_animal);

        UPDATE Animal
        SET estado_animal = 'Vendido'
        WHERE id_animal = @id_animal;

        COMMIT TRAN;
        PRINT 'Animal asociado a la venta y estado actualizado con éxito.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        PRINT 'Ocurrió un error. Se revirtieron los cambios.';
    END CATCH
END;
GO