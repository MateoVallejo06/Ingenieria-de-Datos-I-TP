USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 8 - TRIGGERS (DISPARADORES)
-- Sistema de Gestion Logistica de Transporte
-- Castro Feijoo S.R.L.
-- =========================================================


-- 1. Automatización de cambio de estado a 'Vendido'
-- Al registrar una venta, el animal debe pasar automáticamente a 'Vendido' para evitar que sea asignado a viajes futuros por error.

CREATE TRIGGER TR_ActualizarEstadoVendido
ON DetalleVentaAnimal
AFTER INSERT
AS
BEGIN
    UPDATE Animal
    SET estado_animal = 'Vendido'
    FROM Animal a
    INNER JOIN inserted i ON a.id_animal = i.id_animal;
END;
GO


-- 2. Validación de integridad (Prevenir venta de animales vendidos)
-- Impide que se agregue a un viaje un animal que ya ha sido vendido previamente.

CREATE TRIGGER TR_ValidarAnimalDisponibleParaViaje
ON DetalleViajeAnimal
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Animal a
        INNER JOIN inserted i ON a.id_animal = i.id_animal
        WHERE a.estado_animal IN ('Vendido', 'Muerto')
    )
    BEGIN
        RAISERROR ('Error: No se puede asignar a un viaje un animal que ya ha sido vendido.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- 3. Control de Capacidad Máxima de Camiones
-- Valida que la cantidad de animales en un viaje no supere la capacidad máxima del camión asignado.

CREATE TRIGGER TR_ControlarCapacidadCamion
ON DetalleViajeAnimal
AFTER INSERT
AS
BEGIN
    DECLARE @id_viaje INT;
    DECLARE @capacidad_maxima INT;
    DECLARE @cantidad_actual INT;

    -- Obtenemos el ID del viaje del nuevo registro
    SELECT @id_viaje = id_viaje FROM inserted;

    -- Obtenemos la capacidad máxima del camión asignado a ese viaje
    SELECT @capacidad_maxima = c.capacidad_maxima
    FROM Camion c
    INNER JOIN Viaje v ON c.id_camion = v.id_camion
    WHERE v.id_viaje = @id_viaje;

    -- Contamos cuántos animales hay ya cargados en ese viaje (incluyendo el nuevo)
    SELECT @cantidad_actual = COUNT(*)
    FROM DetalleViajeAnimal
    WHERE id_viaje = @id_viaje;

    -- Si se supera la capacidad, bloqueamos la inserción
    IF @cantidad_actual > @capacidad_maxima
    BEGIN
        RAISERROR ('Error: El camión ha alcanzado su capacidad máxima de carga para este viaje.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO