CREATE DATABASE CastroFeijooBDI;
GO

USE CastroFeijooBDI;
GO

-- =========================================================
-- ETAPA 4 - CREACIÓN DE BASE DE DATOS
-- Sistema de Gestion Logistica de Transporte para la venta de hacienda
-- Castro Feijoo S.R.L.
-- =========================================================


-- LOTES

CREATE TABLE Lote (
    id_lote INT IDENTITY(1,1) PRIMARY KEY,
    nombre_lote VARCHAR(20) NOT NULL UNIQUE,
    descripcion VARCHAR(255),

    CONSTRAINT CHK_Lote_Nombre
        CHECK (nombre_lote IN ('L1', 'L2', 'L6', 'L7', 'L8', 'L9', 'L10', 'L11'))
);


-- ANIMALES

CREATE TABLE Animal (
    id_animal INT IDENTITY(1,1) PRIMARY KEY,
    codigo_unico VARCHAR(50) NOT NULL UNIQUE,
    fecha_nacimiento DATE,
    sexo CHAR(1) NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    estado_animal VARCHAR(20) NOT NULL,
    id_lote_actual INT NOT NULL,

    CONSTRAINT FK_Animal_Lote 
        FOREIGN KEY (id_lote_actual) REFERENCES Lote(id_lote),

    CONSTRAINT CHK_Animal_Sexo 
        CHECK (sexo IN ('M', 'F')),

    CONSTRAINT CHK_Animal_Categoria 
        CHECK (categoria IN ('Vaca', 'Vaquillona', 'Toro', 'Torito', 'Ternero')),

    CONSTRAINT CHK_Animal_Estado 
        CHECK (estado_animal IN ('Activo', 'Vendido', 'Muerto'))
);


-- USUARIOS

CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasenia VARCHAR(100) NOT NULL,
    rol VARCHAR(30) NOT NULL,
    estado_usuario VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_Usuario_Rol 
        CHECK (rol IN ('Gerente', 'Administracion', 'Operador')),

    CONSTRAINT CHK_Usuario_Estado 
        CHECK (estado_usuario IN ('Activo', 'Inactivo'))
);


-- MOVIMIENTOS ENTRE LOTES

CREATE TABLE MovimientoLote (
    id_movimiento INT IDENTITY(1,1) PRIMARY KEY,
    id_animal INT NOT NULL,
    id_lote_origen INT NOT NULL,
    id_lote_destino INT NOT NULL,
    fecha_movimiento DATE NOT NULL,
    motivo VARCHAR(255),
    id_usuario INT NOT NULL,

    CONSTRAINT FK_Movimiento_Animal 
        FOREIGN KEY (id_animal) REFERENCES Animal(id_animal),

    CONSTRAINT FK_Movimiento_LoteOrigen 
        FOREIGN KEY (id_lote_origen) REFERENCES Lote(id_lote),

    CONSTRAINT FK_Movimiento_LoteDestino 
        FOREIGN KEY (id_lote_destino) REFERENCES Lote(id_lote),

    CONSTRAINT FK_Movimiento_Usuario 
        FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),

    CONSTRAINT CHK_Movimiento_Lotes_Distintos
        CHECK (id_lote_origen <> id_lote_destino)
);


-- CAMIONES

CREATE TABLE Camion (
    id_camion INT IDENTITY(1,1) PRIMARY KEY,
    patente VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    capacidad_maxima INT NOT NULL,
    estado_camion VARCHAR(30) NOT NULL,

    CONSTRAINT CHK_Camion_Capacidad
        CHECK (capacidad_maxima > 0 AND capacidad_maxima <= 75),

    CONSTRAINT CHK_Camion_Estado
        CHECK (estado_camion IN ('Disponible', 'En viaje', 'Fuera de servicio'))
);


-- CHOFERES

CREATE TABLE Chofer (
    id_chofer INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    dni VARCHAR(20) UNIQUE,
    telefono VARCHAR(30)
);


-- VIAJES

CREATE TABLE Viaje (
    id_viaje INT IDENTITY(1,1) PRIMARY KEY,
    tipo_viaje VARCHAR(20) NOT NULL,
    fecha_viaje DATE NOT NULL,
    hora_salida TIME,
    hora_llegada TIME,
    origen VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    estado_viaje VARCHAR(30) NOT NULL,
    id_camion INT NOT NULL,
    id_chofer INT NOT NULL,

    CONSTRAINT FK_Viaje_Camion 
        FOREIGN KEY (id_camion) REFERENCES Camion(id_camion),

    CONSTRAINT FK_Viaje_Chofer 
        FOREIGN KEY (id_chofer) REFERENCES Chofer(id_chofer),

    CONSTRAINT CHK_Viaje_Tipo
        CHECK (tipo_viaje IN ('Interno', 'Externo')),

    CONSTRAINT CHK_Viaje_Estado
        CHECK (estado_viaje IN ('Pendiente', 'En curso', 'Finalizado'))
);


-- DETALLE VIAJE ANIMAL

CREATE TABLE DetalleViajeAnimal (
    id_detalle_viaje INT IDENTITY(1,1) PRIMARY KEY,
    id_viaje INT NOT NULL,
    id_animal INT NOT NULL,
    estado_carga VARCHAR(30),
    observaciones VARCHAR(255),

    CONSTRAINT FK_DetalleViaje_Viaje 
        FOREIGN KEY (id_viaje) REFERENCES Viaje(id_viaje),

    CONSTRAINT FK_DetalleViaje_Animal 
        FOREIGN KEY (id_animal) REFERENCES Animal(id_animal),

    CONSTRAINT UQ_DetalleViaje_Animal 
        UNIQUE (id_viaje, id_animal)
);


-- PESAJES

CREATE TABLE Pesaje (
    id_pesaje INT IDENTITY(1,1) PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    fecha_pesaje DATE NOT NULL,
    peso_total DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(255),

    CONSTRAINT FK_Pesaje_Viaje 
        FOREIGN KEY (id_viaje) REFERENCES Viaje(id_viaje),

    CONSTRAINT CHK_Pesaje_Peso
        CHECK (peso_total > 0)
);


-- CONSIGNATARIOS

CREATE TABLE Consignatario (
    id_consignatario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    direccion VARCHAR(150),
    porcentaje_comision DECIMAL(5,2),

    CONSTRAINT CHK_Consignatario_Comision
        CHECK (porcentaje_comision IS NULL OR porcentaje_comision >= 0)
);


-- FERIAS GANADERAS

CREATE TABLE FeriaGanadera (
    id_feria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    localidad VARCHAR(100),
    provincia VARCHAR(100),
    direccion VARCHAR(150) NOT NULL
);


-- CLIENTES

CREATE TABLE Cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    direccion VARCHAR(150)
);


-- VENTAS

CREATE TABLE Venta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    cantidad_animales INT NOT NULL,
    peso_total DECIMAL(10,2) NOT NULL,
    precio_por_kilo DECIMAL(10,2) NOT NULL,
    monto_total AS (peso_total * precio_por_kilo) PERSISTED,
    estado_venta VARCHAR(30) NOT NULL,
    id_consignatario INT NOT NULL,
    id_feria INT NOT NULL,
    id_cliente INT NOT NULL,

    CONSTRAINT FK_Venta_Consignatario 
        FOREIGN KEY (id_consignatario) REFERENCES Consignatario(id_consignatario),

    CONSTRAINT FK_Venta_Feria 
        FOREIGN KEY (id_feria) REFERENCES FeriaGanadera(id_feria),

    CONSTRAINT FK_Venta_Cliente 
        FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),

    CONSTRAINT CHK_Venta_Estado
        CHECK (estado_venta IN ('Pendiente', 'Finalizada', 'Cancelada')),

    CONSTRAINT CHK_Venta_Cantidad
        CHECK (cantidad_animales > 0),

    CONSTRAINT CHK_Venta_Peso
        CHECK (peso_total > 0),

    CONSTRAINT CHK_Venta_Precio
        CHECK (precio_por_kilo > 0)
);


-- DETALLE VENTA ANIMAL

CREATE TABLE DetalleVentaAnimal (
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_animal INT NOT NULL,

    CONSTRAINT FK_DetalleVenta_Venta 
        FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),

    CONSTRAINT FK_DetalleVenta_Animal 
        FOREIGN KEY (id_animal) REFERENCES Animal(id_animal),

    CONSTRAINT UQ_DetalleVenta_Animal
        UNIQUE (id_animal)
);