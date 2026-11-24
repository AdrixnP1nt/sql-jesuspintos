-- ====================================================================
-- SCRIPT SQL INTEGRAL: MODELO DE DATOS TRANSPORTE
-- ====================================================================
-- Base de datos, tablas (con PK y FK sin restricciones estrictas de bloqueo, 
-- permitiendo eliminación fluida de registros), y población masiva (>80 registros).
-- ====================================================================

-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE TransporteDB;
GO

USE TransporteDB;
GO

-- ====================================================================
-- 2. CREACIÓN DE TABLAS (Ordenadas por dependencias)
-- ====================================================================

CREATE TABLE Pais (
    NroPais INT PRIMARY KEY,
    NombrePais VARCHAR(128) NOT NULL
);

CREATE TABLE Ciudad (
    NroCiudad INT PRIMARY KEY,
    NombreCiudad VARCHAR(128) NOT NULL,
    NroPais INT NOT NULL,
    NroEstacion INT NULL,
    DistanciaEstacion FLOAT NULL,
    FOREIGN KEY (NroPais) REFERENCES Pais(NroPais) ON DELETE CASCADE
);

CREATE TABLE MarcaOmnibus (
    NroMarcaOmnibus SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE ModeloOmnibus (
    NroModeloOmnibus SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE MarcaCarroceria (
    NroMarcaCarroceria SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE ModeloCarroceria (
    NroModeloCarroceria SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE TipoOmnibus (
    NroTipoOmnibus SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE TipoCombustible (
    NroTipoCombustible SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE Cargo (
    NroCargo SMALLINT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE Empleado (
    NroEmpleado INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(128) NOT NULL,
    Apellido VARCHAR(128) NOT NULL,
    Domicilio VARCHAR(255) NOT NULL,
    DocumentoIdentidad INT NOT NULL,
    PasaporteNumero INT NULL,
    FechaNacimiento DATETIME NULL,
    FechaEntrada DATETIME NULL,
    NroCargo SMALLINT NOT NULL,
    FOREIGN KEY (NroCargo) REFERENCES Cargo(NroCargo) ON DELETE CASCADE
);

CREATE TABLE Estacion (
    NroEstacion INT PRIMARY KEY,
    NroCiudad INT NOT NULL,
    NroEmpleado INT NOT NULL,
    Nombre VARCHAR(128) NOT NULL,
    Direccion VARCHAR(128) NOT NULL,
    Telefono VARCHAR(16) NOT NULL,
    FOREIGN KEY (NroCiudad) REFERENCES Ciudad(NroCiudad) ON DELETE CASCADE,
    FOREIGN KEY (NroEmpleado) REFERENCES Empleado(NroEmpleado) ON DELETE NO ACTION
);

CREATE TABLE Agencia (
    NroAgencia INT PRIMARY KEY,
    Nombre VARCHAR(128) NOT NULL,
    Direccion VARCHAR(128) NOT NULL,
    Telefono VARCHAR(16) NOT NULL,
    NroCiudad INT NOT NULL,
    NroEmpleado INT NOT NULL,
    FOREIGN KEY (NroCiudad) REFERENCES Ciudad(NroCiudad) ON DELETE CASCADE,
    FOREIGN KEY (NroEmpleado) REFERENCES Empleado(NroEmpleado) ON DELETE NO ACTION
);

CREATE TABLE Omnibus (
    NroOmnibus INT PRIMARY KEY,
    NroMarcaOmnibus SMALLINT NOT NULL,
    NroModeloOmnibus SMALLINT NOT NULL,
    AnioOmnibus INT NOT NULL,
    NroMarcaCarroceria SMALLINT NOT NULL,
    NroModeloCarroceria SMALLINT NOT NULL,
    AnioCarroceria INT NOT NULL,
    NroTipoOmnibus SMALLINT NOT NULL,
    NroTipoCombustible SMALLINT NOT NULL,
    NumeroPisos SMALLINT NOT NULL,
    ConsumoCombustible FLOAT NOT NULL,
    AutonomiaKms FLOAT NOT NULL,
    PesoTotal FLOAT NOT NULL,
    CantidadEjes SMALLINT NOT NULL,
    KmsRecorrido FLOAT NOT NULL,
    NroPais INT NOT NULL,
    CantidadAsientos INT NOT NULL,
    CapacidadBodega FLOAT NOT NULL,
    VolumenBodega FLOAT NOT NULL,
    FOREIGN KEY (NroMarcaOmnibus) REFERENCES MarcaOmnibus(NroMarcaOmnibus),
    FOREIGN KEY (NroModeloOmnibus) REFERENCES ModeloOmnibus(NroModeloOmnibus),
    FOREIGN KEY (NroMarcaCarroceria) REFERENCES MarcaCarroceria(NroMarcaCarroceria),
    FOREIGN KEY (NroModeloCarroceria) REFERENCES ModeloCarroceria(NroModeloCarroceria),
    FOREIGN KEY (NroTipoOmnibus) REFERENCES TipoOmnibus(NroTipoOmnibus),
    FOREIGN KEY (NroTipoCombustible) REFERENCES TipoCombustible(NroTipoCombustible),
    FOREIGN KEY (NroPais) REFERENCES Pais(NroPais)
);

CREATE TABLE Asiento (
    NroOmnibus INT NOT NULL,
    NroAsiento INT NOT NULL,
    NroPiso SMALLINT NOT NULL,
    PasillooVentanilla CHAR(1) NOT NULL,
    PRIMARY KEY (NroOmnibus, NroAsiento),
    FOREIGN KEY (NroOmnibus) REFERENCES Omnibus(NroOmnibus) ON DELETE CASCADE
);

CREATE TABLE Tramo (
    NroTramo INT PRIMARY KEY,
    EstacionOrigen INT NOT NULL,
    EstacionDestino INT NOT NULL,
    DistanciaKms FLOAT NOT NULL,
    DistanciaTiempo FLOAT NOT NULL,
    FOREIGN KEY (EstacionOrigen) REFERENCES Estacion(NroEstacion),
    FOREIGN KEY (EstacionDestino) REFERENCES Estacion(NroEstacion)
);

CREATE TABLE Servicio (
    NroServicio INT PRIMARY KEY,
    Descripcion VARCHAR(128) NOT NULL
);

CREATE TABLE TramoTipoOmnibus (
    NroTramo INT NOT NULL,
    NroTipoOmnibus SMALLINT NOT NULL,
    Precio MONEY NOT NULL,
    PorcentajeIVA FLOAT NOT NULL,
    PRIMARY KEY (NroTramo, NroTipoOmnibus),
    FOREIGN KEY (NroTramo) REFERENCES Tramo(NroTramo) ON DELETE CASCADE,
    FOREIGN KEY (NroTipoOmnibus) REFERENCES TipoOmnibus(NroTipoOmnibus) ON DELETE CASCADE
);

CREATE TABLE OmnibusServicio (
    NroOmnibus INT NOT NULL,
    NroServicio INT NOT NULL,
    PRIMARY KEY (NroOmnibus, NroServicio),
    FOREIGN KEY (NroOmnibus) REFERENCES Omnibus(NroOmnibus) ON DELETE CASCADE,
    FOREIGN KEY (NroServicio) REFERENCES Servicio(NroServicio) ON DELETE CASCADE
);

CREATE TABLE Pasajero (
    NroPasajero INT PRIMARY KEY,
    Nombre VARCHAR(128) NOT NULL,
    Apellido VARCHAR(128) NOT NULL,
    Domicilio VARCHAR(255) NOT NULL,
    DireccionLaboral VARCHAR(255) NULL,
    TelefonoParticular VARCHAR(16) NULL,
    TelefonoLaboral VARCHAR(16) NULL,
    DocumentoIdentidad INT NOT NULL,
    PasaporteNumero INT NULL,
    FechaNacimiento DATETIME NULL,
    NroPais INT NOT NULL,
    Observacion VARCHAR(255) NULL,
    FOREIGN KEY (NroPais) REFERENCES Pais(NroPais)
);

CREATE TABLE Viaje (
    NroViaje INT IDENTITY(1,1) PRIMARY KEY,
    NroOmnibus INT NOT NULL,
    NroCiudadOrigen INT NOT NULL,
    NroCiudadDestino INT NOT NULL,
    FechaHoraSalida DATETIME NOT NULL,
    FechaHoraPrevista DATETIME NOT NULL,
    NroAndenOrigen INT NULL,
    NroAndenDestino INT NULL,
    KilometrajeSalida FLOAT NULL,
    FechaHoraLlegada DATETIME NULL,
    KilometrajeLlegada FLOAT NULL,
    FOREIGN KEY (NroOmnibus) REFERENCES Omnibus(NroOmnibus),
    FOREIGN KEY (NroCiudadOrigen) REFERENCES Ciudad(NroCiudad),
    FOREIGN KEY (NroCiudadDestino) REFERENCES Ciudad(NroCiudad)
);

CREATE TABLE ViajeTramo (
    NroViaje INT NOT NULL,
    NroTramo INT NOT NULL,
    PRIMARY KEY (NroViaje, NroTramo),
    FOREIGN KEY (NroViaje) REFERENCES Viaje(NroViaje) ON DELETE CASCADE,
    FOREIGN KEY (NroTramo) REFERENCES Tramo(NroTramo) ON DELETE CASCADE
);

CREATE TABLE ViajeEmpleado (
    NroViaje INT NOT NULL,
    NroEmpleado INT NOT NULL,
    PRIMARY KEY (NroViaje, NroEmpleado),
    FOREIGN KEY (NroViaje) REFERENCES Viaje(NroViaje) ON DELETE CASCADE,
    FOREIGN KEY (NroEmpleado) REFERENCES Empleado(NroEmpleado) ON DELETE CASCADE
);

CREATE TABLE Pasaje (
    NroPasaje INT PRIMARY KEY IDENTITY(1,1),
    NroPasajero INT NOT NULL,
    FechaPasaje DATETIME NOT NULL,
    PrecioPasaje MONEY NOT NULL,
    ImporteIVA MONEY NOT NULL,
    NroViaje INT NOT NULL,
    NroTramo INT NOT NULL,
    NroOmnibus INT NOT NULL,
    NroAsiento INT NOT NULL,
    NroAgencia INT NOT NULL,
    FOREIGN KEY (NroPasajero) REFERENCES Pasajero(NroPasajero),
    FOREIGN KEY (NroViaje) REFERENCES Viaje(NroViaje),
    FOREIGN KEY (NroOmnibus) REFERENCES Omnibus(NroOmnibus),
    FOREIGN KEY (NroAgencia) REFERENCES Agencia(NroAgencia),
    FOREIGN KEY (NroOmnibus, NroAsiento) REFERENCES Asiento(NroOmnibus, NroAsiento)
);

CREATE TABLE Encomienda (
    NroEncomienda INT PRIMARY KEY IDENTITY(1,1),
    NroPasajero INT NOT NULL,
    FechaEncomienda DATETIME NOT NULL,
    PrecioEncomienda MONEY NOT NULL,
    ImporteIVA MONEY NOT NULL,
    NroViaje INT NOT NULL,
    NroTramo INT NOT NULL,
    PesoTotal FLOAT NOT NULL,
    VolumenTotal FLOAT NOT NULL,
    NroAgencia INT NOT NULL,
    FOREIGN KEY (NroPasajero) REFERENCES Pasajero(NroPasajero),
    FOREIGN KEY (NroViaje) REFERENCES Viaje(NroViaje),
    FOREIGN KEY (NroAgencia) REFERENCES Agencia(NroAgencia)
);

CREATE TABLE Bulto (
    NroBulto INT IDENTITY(1,1) PRIMARY KEY,
    NroPasaje INT NULL,
    NroEncomienda INT NOT NULL,
    PesoTotal FLOAT NOT NULL,
    VolumenTotal FLOAT NOT NULL,
    FOREIGN KEY (NroPasaje) REFERENCES Pasaje(NroPasaje) ON DELETE SET NULL,
    FOREIGN KEY (NroEncomienda) REFERENCES Encomienda(NroEncomienda) ON DELETE CASCADE
);
GO

-- ====================================================================
-- 3. POBLADO MASIVO DE DATOS (>80 REGISTROS EN TABLAS PRINCIPALES)
-- ====================================================================

-- 1. PAIS (5 registros)
INSERT INTO Pais (NroPais, NombrePais) VALUES 
(1, 'Argentina'), (2, 'Brasil'), (3, 'Chile'), (4, 'Uruguay'), (5, 'Paraguay');

-- 2. CIUDAD (10 registros)
INSERT INTO Ciudad (NroCiudad, NombreCiudad, NroPais, NroEstacion, DistanciaEstacion) VALUES 
(1, 'Buenos Aires', 1, 1, 5.5), (2, 'Cordoba', 1, 2, 3.2), (3, 'Rosario', 1, 3, 4.1),
(4, 'Santiago', 3, 4, 6.0), (5, 'Valparaiso', 3, 5, 2.5), (6, 'Montevideo', 4, 6, 3.0),
(7, 'Asuncion', 5, 7, 4.0), (8, 'Sao Paulo', 2, 8, 10.5), (9, 'Rio de Janeiro', 2, 9, 8.0), (10, 'Mendoza', 1, 10, 2.0);

-- 3. MARCA / MODELO / CARROCERIA / TIPO OMNIBUS / COMBUSTIBLE / CARGO / SERVICIO
INSERT INTO MarcaOmnibus VALUES (1, 'Mercedes-Benz'), (2, 'Scania'), (3, 'Volvo'), (4, 'Marcopolo');
INSERT INTO ModeloOmnibus VALUES (1, 'O500'), (2, 'K410'), (3, 'B440R');
INSERT INTO MarcaCarroceria VALUES (1, 'Marcopolo G8'), (2, 'Busscar Visioner'), (3, 'Comil Campione');
INSERT INTO ModeloCarroceria VALUES (1, 'Paradiso 1800'), (2, 'Jum Buss 400'), (3, 'Invictus DD');
INSERT INTO TipoOmnibus VALUES (1, 'Semicama'), (2, 'Cama Ejecutiva'), (3, 'Cama Suite');
INSERT INTO TipoCombustible VALUES (1, 'Diesel'), (2, 'Biodiesel'), (3, 'Gas Natural');
INSERT INTO Cargo VALUES (1, 'Conductor'), (2, 'Atencion al Cliente'), (3, 'Jefe de Estacion'), (4, 'Mecanico');
INSERT INTO Servicio VALUES (1, 'WiFi a bordo'), (2, 'Catering Ejecutivo'), (3, 'Pantallas Individuales'), (4, 'Bano Quimico');

-- 4. EMPLEADOS (85 registros)
DECLARE @i INT = 1;
WHILE @i <= 85
BEGIN
    INSERT INTO Empleado (Nombre, Apellido, Domicilio, DocumentoIdentidad, PasaporteNumero, FechaNacimiento, FechaEntrada, NroCargo)
    VALUES (
        'Nombre_' + CAST(@i AS VARCHAR),
        'Apellido_' + CAST(@i AS VARCHAR),
        'Calle Falsa ' + CAST(@i AS VARCHAR),
        30000000 + @i,
        9000000 + @i,
        DATEADD(day, -(@i * 180), '1985-01-01'),
        DATEADD(day, -(@i * 30), '2020-01-01'),
        ((@i % 4) + 1)
    );
    SET @i = @i + 1;
END

-- 5. ESTACION (10 registros)
SET @i = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO Estacion (NroEstacion, NroCiudad, NroEmpleado, Nombre, Direccion, Telefono)
    VALUES (@i, @i, (@i % 85) + 1, 'Terminal Central ' + CAST(@i AS VARCHAR), 'Av. Principal ' + CAST(@i AS VARCHAR), '555-010' + CAST(@i AS VARCHAR));
    SET @i = @i + 1;
END

-- 6. AGENCIA (15 registros)
SET @i = 1;
WHILE @i <= 15
BEGIN
    INSERT INTO Agencia (NroAgencia, Nombre, Direccion, Telefono, NroCiudad, NroEmpleado)
    VALUES (@i, 'Agencia Viajes ' + CAST(@i AS VARCHAR), 'Local ' + CAST(@i AS VARCHAR) + ' Centro', '444-200' + CAST(@i AS VARCHAR), ((@i % 10) + 1), (@i % 85) + 1);
    SET @i = @i + 1;
END

-- 7. OMNIBUS (20 registros)
SET @i = 1;
WHILE @i <= 20
BEGIN
    INSERT INTO Omnibus (NroOmnibus, NroMarcaOmnibus, NroModeloOmnibus, AnioOmnibus, NroMarcaCarroceria, NroModeloCarroceria, AnioCarroceria, NroTipoOmnibus, NroTipoCombustible, NumeroPisos, ConsumoCombustible, AutonomiaKms, PesoTotal, CantidadEjes, KmsRecorrido, NroPais, CantidadAsientos, CapacidadBodega, VolumenBodega)
    VALUES (@i, ((@i % 4) + 1), ((@i % 3) + 1), 2020 + (@i % 5), ((@i % 3) + 1), ((@i % 3) + 1), 2021, ((@i % 3) + 1), 1, 2, 25.5, 1200.0, 15000.5, 3, 50000.0 + (@i * 1000), ((@i % 5) + 1), 48, 15.0, 30.5);
    SET @i = @i + 1;
END

-- 8. ASIENTOS (Generar asientos para los 20 ómnibus, 48 asientos c/u = 960 registros)
DECLARE @bus INT = 1;
WHILE @bus <= 20
BEGIN
    DECLARE @seat INT = 1;
    WHILE @seat <= 48
    BEGIN
        INSERT INTO Asiento (NroOmnibus, NroAsiento, NroPiso, PasillooVentanilla)
        VALUES (@bus, @seat, CASE WHEN @seat > 24 THEN 2 ELSE 1 END, CASE WHEN @seat % 2 = 0 THEN 'V' ELSE 'P' END);
        SET @seat = @seat + 1;
    END
    SET @bus = @bus + 1;
END

-- 9. TRAMO (30 registros)
SET @i = 1;
WHILE @i <= 30
BEGIN
    INSERT INTO Tramo (NroTramo, EstacionOrigen, EstacionDestino, DistanciaKms, DistanciaTiempo)
    VALUES (@i, ((@i % 10) + 1), (((@i + 1) % 10) + 1), 150.0 + (@i * 15), 2.5 + (@i * 0.1));
    SET @i = @i + 1;
END

-- 10. TRAMO TIPO OMNIBUS (90 registros)
SET @i = 1;
WHILE @i <= 30
BEGIN
    DECLARE @tipo INT = 1;
    WHILE @tipo <= 3
    BEGIN
        INSERT INTO TramoTipoOmnibus (NroTramo, NroTipoOmnibus, Precio, PorcentajeIVA)
        VALUES (@i, @tipo, 50.00 + (@i * 5) + (@tipo * 10), 21.0);
        SET @tipo = @tipo + 1;
    END
    SET @i = @i + 1;
END

-- 11. OMNIBUS SERVICIO (40 registros)
SET @i = 1;
WHILE @i <= 20
BEGIN
    INSERT INTO OmnibusServicio (NroOmnibus, NroServicio) VALUES (@i, 1);
    INSERT INTO OmnibusServicio (NroOmnibus, NroServicio) VALUES (@i, 4);
    SET @i = @i + 1;
END

-- 12. PASAJERO (90 registros)
SET @i = 1;
WHILE @i <= 90
BEGIN
    INSERT INTO Pasajero (NroPasajero, Nombre, Apellido, Domicilio, DireccionLaboral, TelefonoParticular, TelefonoLaboral, DocumentoIdentidad, PasaporteNumero, FechaNacimiento, NroPais, Observacion)
    VALUES (
        @i,
        'PasajeroNombre_' + CAST(@i AS VARCHAR),
        'PasajeroApellido_' + CAST(@i AS VARCHAR),
        'Calle Pasajero ' + CAST(@i AS VARCHAR),
        'Oficina ' + CAST(@i AS VARCHAR),
        '999-100' + CAST(@i AS VARCHAR),
        '888-200' + CAST(@i AS VARCHAR),
        40000000 + @i,
        8000000 + @i,
        DATEADD(day, -(@i * 200), '1990-01-01'),
        ((@i % 5) + 1),
        'Cliente regular'
    );
    SET @i = @i + 1;
END

-- 13. VIAJE (50 registros)
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Viaje (NroOmnibus, NroCiudadOrigen, NroCiudadDestino, FechaHoraSalida, FechaHoraPrevista, NroAndenOrigen, NroAndenDestino, KilometrajeSalida, FechaHoraLlegada, KilometrajeLlegada)
    VALUES (
        ((@i % 20) + 1),
        ((@i % 10) + 1),
        (((@i + 2) % 10) + 1),
        DATEADD(day, @i, '2026-06-01 08:00:00'),
        DATEADD(day, @i, '2026-06-01 14:00:00'),
        1, 2,
        50000.0,
        DATEADD(day, @i, '2026-06-01 14:15:00'),
        50600.0
    );
    SET @i = @i + 1;
END

-- 14. VIAJE TRAMO (50 registros)
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO ViajeTramo (NroViaje, NroTramo) VALUES (@i, ((@i % 30) + 1));
    SET @i = @i + 1;
END

-- 15. VIAJE EMPLEADO (50 registros)
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO ViajeEmpleado (NroViaje, NroEmpleado) VALUES (@i, ((@i % 85) + 1));
    SET @i = @i + 1;
END

-- 16. PASAJE (95 registros)
SET @i = 1;
WHILE @i <= 95
BEGIN
    INSERT INTO Pasaje (NroPasajero, FechaPasaje, PrecioPasaje, ImporteIVA, NroViaje, NroTramo, NroOmnibus, NroAsiento, NroAgencia)
    VALUES (
        ((@i % 90) + 1),
        GETDATE(),
        120.00,
        25.20,
        ((@i % 50) + 1),
        ((@i % 30) + 1),
        ((@i % 20) + 1),
        ((@i % 48) + 1),
        ((@i % 15) + 1)
    );
    SET @i = @i + 1;
END

-- 17. ENCOMIENDA (90 registros)
SET @i = 1;
WHILE @i <= 90
BEGIN
    INSERT INTO Encomienda (NroPasajero, FechaEncomienda, PrecioEncomienda, ImporteIVA, NroViaje, NroTramo, PesoTotal, VolumenTotal, NroAgencia)
    VALUES (
        ((@i % 90) + 1),
        GETDATE(),
        45.00,
        9.45,
        ((@i % 50) + 1),
        ((@i % 30) + 1),
        5.5,
        0.12,
        ((@i % 15) + 1)
    );
    SET @i = @i + 1;
END

-- 18. BULTO (90 registros)
SET @i = 1;
WHILE @i <= 90
BEGIN
    INSERT INTO Bulto (NroPasaje, NroEncomienda, PesoTotal, VolumenTotal)
    VALUES (
        ((@i % 95) + 1),
        ((@i % 90) + 1),
        2.5,
        0.05
    );
    SET @i = @i + 1;
END

print 'Base de datos creada y poblada exitosamente con mas de 80 registros por tabla principal.';
