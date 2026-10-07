-- ==========================================================================
-- BASE DE DATOS: SistemaGestionTallerIntegral
-- ==========================================================================

-- 1. CONTROL DE INSTANCIAS PREVIAS

 CREATE DATABASE SistemaGestionTallerIntegral
 GO

USE SistemaGestionTallerIntegral;
GO

-- ==========================================================================
-- 2. ESTRUCTURA DE TABLAS 
-- ==========================================================================

-- Tabla: CLIENTE (Datos maestros de los titulares)
CREATE TABLE CLIENTE (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    CI NVARCHAR(20) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    NroTelefono NVARCHAR(30) NULL,
    Direccion NVARCHAR(200) NULL
);

-- Tabla: VEHICULO 
CREATE TABLE VEHICULO (
    IdVehiculo INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    Modelo NVARCHAR(100) NOT NULL,
    Matricula NVARCHAR(20) NOT NULL UNIQUE,
    Anho INT NOT NULL,
    CONSTRAINT FK_Vehiculo_Cliente FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

-- Tabla: TALLER 
CREATE TABLE TALLER (
    IdTaller INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(200) NOT NULL,
    Telefono NVARCHAR(30) NULL,
    Especialidad NVARCHAR(100) NULL
);

-- Tabla: PROVEEDOR 
CREATE TABLE PROVEEDOR (
    IdProveedor INT IDENTITY(1,1) PRIMARY KEY,
    RUC NVARCHAR(20) NOT NULL UNIQUE,
    RazonSocial NVARCHAR(150) NOT NULL,
    Telefono NVARCHAR(30) NULL,
    Email NVARCHAR(100) NULL
);

-- Tabla: REPUESTOS 
CREATE TABLE REPUESTOS (
    IdRepuesto INT IDENTITY(1,1) PRIMARY KEY,
    IdProveedor INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    PrecioCosto INT NOT NULL, -- Valores enteros
    StockDisponible INT NOT NULL CONSTRAINT DF_Repuestos_Stock DEFAULT 0,
    CONSTRAINT FK_Repuestos_Proveedor FOREIGN KEY (IdProveedor) REFERENCES PROVEEDOR(IdProveedor),
    CONSTRAINT CHK_PrecioCosto CHECK (PrecioCosto >= 0)
);

-- Tabla: ORDEN_TRABAJO 
CREATE TABLE ORDEN_TRABAJO (
    IdOrden INT IDENTITY(1,1) PRIMARY KEY,
    IdVehiculo INT NOT NULL,
    IdTaller INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    DescripcionDiagnostico NVARCHAR(MAX) NOT NULL,
    ManoObra INT NOT NULL,
    Estado NVARCHAR(50) NOT NULL CONSTRAINT DF_Orden_Estado DEFAULT 'Pendiente', -- Pendiente, En Proceso, Completado
    CONSTRAINT FK_Orden_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES VEHICULO(IdVehiculo),
    CONSTRAINT FK_Orden_Taller FOREIGN KEY (IdTaller) REFERENCES TALLER(IdTaller),
    CONSTRAINT CHK_ManoObra CHECK (ManoObra >= 0)
);

-- Tabla Asociativa: ORDEN_REPUESTO 
CREATE TABLE ORDEN_REPUESTO (
    IdOrden INT NOT NULL,
    IdRepuesto INT NOT NULL,
    Cantidad INT NOT NULL CONSTRAINT DF_OrdenRepuesto_Cantidad DEFAULT 1,
    PrecioVenta INT NOT NULL,
    CONSTRAINT PK_ORDEN_REPUESTO PRIMARY KEY (IdOrden, IdRepuesto),
    CONSTRAINT FK_OrdenRepuesto_Orden FOREIGN KEY (IdOrden) REFERENCES ORDEN_TRABAJO(IdOrden),
    CONSTRAINT FK_OrdenRepuesto_Repuesto FOREIGN KEY (IdRepuesto) REFERENCES REPUESTOS(IdRepuesto),
    CONSTRAINT CHK_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CHK_PrecioVenta CHECK (PrecioVenta >= 0)
);
GO

-- ==========================================================================
-- 3. POBLADO MASIVO DE DATOS 
-- ==========================================================================

-- Tabla: CLIENTE 

INSERT INTO CLIENTE (CI, Nombre, Apellido, NroTelefono, Direccion) VALUES
('1000001', 'Juan', 'Pérez', '0981111111', 'Asunción, Barrio Sajonia'),
('1000002', 'María', 'Gómez', '0981222222', 'San Lorenzo, Calle Palma'),
('1000003', 'Carlos', 'Rodríguez', '0981333333', 'Luque, Av. Corrales'),
('1000004', 'Ana', 'Martínez', '0981444444', 'Fernando de la Mora, Zona Norte'),
('1000005', 'Luis', 'López', '0981555555', 'Lambaré, Av. Cacique Lambaré'),
('1000006', 'Laura', 'González', '0981666666', 'Capiatá, Ruta 2 KM 20'),
('1000007', 'Diego', 'Sánchez', '0981777777', 'Mariano Roque Alonso'),
('1000008', 'Elena', 'Fernández', '0981888888', 'Asunción, Villa Morra'),
('1000009', 'Pedro', 'Ramírez', '0981999999', 'Ñemby, Centro'),
('1000010', 'Sofía', 'Torres', '0982111222', 'San Lorenzo, Reducto'),
('1000011', 'Jorge', 'Díaz', '0982333444', 'Luque, Maka''i'),
('1000012', 'Lucía', 'Vázquez', '0982555666', 'Asunción, Barrio Obrero'),
('1000013', 'Andrés', 'Castro', '0982777888', 'Lambaré, Cerro Corá'),
('1000014', 'Marta', 'Morales', '0982999000', 'Villa Elisa, Von Poleski'),
('1000015', 'Raúl', 'Herrera', '0983111333', 'Asunción, Trinidad'),
('1000016', 'Clara', 'Flores', '0983444666', 'Limpio, Centro'),
('1000017', 'Martín', 'Espínola', '0983777999', 'San Antonio, Torremolinos'),
('1000018', 'Isabel', 'Benítez', '0984111222', 'Luque, Campo Grande'),
('1000019', 'Gabriel', 'Medina', '0984333555', 'Ypané, Centro'),
('1000020', 'Paula', 'Silva', '0984777111', 'Asunción, Terminal'),
('1000021', 'Fernando', 'Rojas', '0985111444', 'Mariano Roque Alonso, Centro'),
('1000022', 'Rosa', 'Acuña', '0985555777', 'Capiatá, Ruta 1 KM 18'),
('1000023', 'Ricardo', 'Giménez', '0985888222', 'Itauguá, Centro'),
('1000024', 'Alicia', 'Cardozo', '0986111999', 'Villeta, Zona Puerto'),
('1000025', 'Hugo', 'Mendoza', '0986444333', 'Guarambaré, Centro'),
('1000026', 'Beatriz', 'Duarte', '0986777555', 'Areguá, Casco Histórico'),
('1000027', 'Oscar', 'Cáceres', '0987111888', 'Asunción, Recoleta'),
('1000028', 'Gabriela', 'Ortiz', '0987444111', 'San Lorenzo, Barrio San Pedro'),
('1000029', 'Santiago', 'Núñez', '0987777444', 'Luque, Laurelty'),
('1000030', 'Carmen', 'Galeano', '0987999888', 'Lambaré, Valle Ybate');

-- Tabla: VEHICULO 
INSERT INTO VEHICULO (IdCliente, Modelo, Matricula, Anho) VALUES
(1, 'Toyota Corolla', 'AAA001', 2015), (2, 'Hyundai Accent', 'AAA002', 2017),
(3, 'Chevrolet Onix', 'AAA003', 2019), (4, 'Kia Picanto', 'AAA004', 2016),
(5, 'Volkswagen Gol', 'AAA005', 2014), (6, 'Fiat Palio', 'AAA006', 2012),
(7, 'Renault Clio', 'AAA007', 2015), (8, 'Ford Fiesta', 'AAA008', 2013),
(9, 'Nissan Versa', 'AAA009', 2018), (10, 'Honda Civic', 'AAA010', 2016),
(11, 'Suzuki Swift', 'AAA011', 2017), (12, 'Mazda 3', 'AAA012', 2015),
(13, 'Peugeot 208', 'AAA013', 2018), (14, 'Citroen C3', 'AAA014', 2014),
(15, 'Chevrolet S10', 'AAA015', 2016), (16, 'Toyota Hilux', 'AAA016', 2018),
(17, 'Mitsubishi L200', 'AAA017', 2015), (18, 'Ford Ranger', 'AAA018', 2017),
(19, 'Nissan Frontier', 'AAA019', 2019), (20, 'Volkswagen Amarok', 'AAA020', 2016),
(21, 'Jeep Renegade', 'AAA021', 2018), (22, 'Hyundai Tucson', 'AAA022', 2017),
(23, 'Kia Sportage', 'AAA023', 2015), (24, 'Toyota RAV4', 'AAA024', 2016),
(25, 'Chevrolet Tracker', 'AAA025', 2019), (26, 'Nissan Kicks', 'AAA026', 2018),
(27, 'Renault Duster', 'AAA027', 2015), (28, 'Honda HR-V', 'AAA028', 2017),
(29, 'Fiat Toro', 'AAA029', 2018), (30, 'Suzuki Vitara', 'AAA030', 2016);

-- Tabla: TALLER 
INSERT INTO TALLER (Nombre, Direccion, Telefono, Especialidad) VALUES
('Taller Mecánico Central', 'Asunción, Av. Artigas 1500', '021200101', 'Mecánica General'),
('Taller ElectroAuto', 'San Lorenzo, Mcal. López 450', '021500202', 'Electricidad e Inyección'),
('Taller Chapa y Pintura Express', 'Luque, Av. Aviadores', '021640303', 'Chapa y Pintura'),
('Taller Frenos Paraguay', 'Fernando de la Mora, Mcal. Estigarribia', '021510404', 'Frenos y Suspensión'),
('Taller Motores del Sur', 'Lambaré, Av. Perón', '021900505', 'Ajuste de Motores'),
('Taller ClimaAuto', 'Asunción, Eusebio Ayala', '021220606', 'Aire Acondicionado'),
('Taller Transmisiones Luque', 'Luque, Las Residentas', '021645707', 'Cajas Automáticas'),
('Taller Dirección Asistida', 'Capiatá, Ruta 2', '022810808', 'Cremalleras y Dirección'),
('Taller Inyección Diésel', 'Ñemby, Acceso Sur', '021940909', 'Sistemas Diésel'),
('Taller Diagnóstico Computarizado', 'San Lorenzo, Centro', '021520101', 'Escáner Avanzado'),
('Taller Suspensión Pro', 'Mariano Roque Alonso, Ruta Transchaco', '021750202', 'Amortiguadores'),
('Taller Parabrisas y Vidrios', 'Asunción, Av. Fernando de la Mora', '021550303', 'Vidrios y Cerrajería'),
('Taller Embragues Asunción', 'Asunción, Félix Bogado', '021300404', 'Embragues Kit'),
('Taller Fast Service', 'Villa Elisa, Av. Américo Picco', '021930505', 'Mantenimiento Rápido'),
('Taller Radiadores El Sol', 'Limpio, Av. San José', '021780606', 'Radiadores y Enfriamiento'),
('Taller Escapes Paraguay', 'San Antonio, Av. San Antonio', '021970707', 'Caños de Escape'),
('Taller Gomería y Alineación Centro', 'Asunción, Av. España', '021210808', 'Alineación y Balanceo'),
('Taller Performance Tuning', 'Lambaré, Calle Primero de Marzo', '021905909', 'Potenciación'),
('Taller Detailing Premium', 'Asunción, Villa Morra', '021600111', 'Estética Automotriz'),
('Taller Hidráulica Avanzada', 'Luque, Barrio Molino', '021650222', 'Sistemas Hidráulicos'),
('Taller Car Audio & Alarmas', 'San Lorenzo, Av. del Agrónomo', '021580333', 'Alarmas y Sonido'),
('Taller Multimarca San Rafael', 'Capiatá, Ruta 1', '021570444', 'Mecánica General'),
('Taller Lubricentro Central', 'Ñemby, Manuel Ortiz Guerrero', '021960555', 'Cambio de Aceite'),
('Taller Frenos San Lorenzo', 'San Lorenzo, Calle Manuel Ortiz', '021505666', 'Sistema de Frenos'),
('Taller Amortiguadores Luque', 'Luque, Centro', '021640777', 'Suspensión'),
('Taller Inyección Electrónica Norte', 'Mariano Roque Alonso', '021755888', 'Inyección Naftera'),
('Taller Especializado Toyota', 'Asunción, Av. República Argentina', '021610999', 'Marcas Japonesas'),
('Taller Especializado Hyundai', 'San Lorenzo, Av. Pastora Céspedes', '021590111', 'Marcas Coreanas'),
('Taller Especializado Ford', 'Lambaré, Av. Médicos del Chaco', '021920222', 'Marcas Americanas'),
('Taller EuroService', 'Asunción, Av. Mcal. López', '021660333', 'Vehículos Europeos');

-- Tabla: PROVEEDOR 
INSERT INTO PROVEEDOR (RUC, RazonSocial, Telefono, Email) VALUES
('80000001-0', 'Autopartes del Este S.A.', '021601001', 'ventas@autoparteseste.com.py'),
('80000002-0', 'Distribuidora Repuestos Asia', '021502002', 'info@repuestosasia.com.py'),
('80000003-0', 'Importadora Warnes Paraguay', '021403003', 'warnes@warnes.com.py'),
('80000004-0', 'Bosch Representaciones', '021204004', 'bosch@representaciones.com.py'),
('80000005-0', 'Diesa Repuestos S.A.', '021505005', 'diesa@diesa.com.py'),
('80000006-0', 'Toyotoshi Autopartes', '021619006', 'repuestos@toyotoshi.com.py'),
('80000007-0', 'Chaco Repuestos S.R.L.', '021940707', 'chaco@chacorepuestos.com.py'),
('80000008-0', 'Brasil Autopartes', '021300808', 'ventas@brasilautopartes.com'),
('80000009-0', 'EuroParts Paraguay', '021660909', 'contacto@europarts.com.py'),
('80000010-0', 'Global Spares Import', '021550101', 'global@globalspares.com'),
('80000011-0', 'Frenos y Embragues Continental', '021210202', 'continental@frenos.com'),
('80000012-0', 'Baterías Willard Paraguay', '021520303', 'willard@baterias.com.py'),
('80000013-0', 'Amortiguadores Fric-Rot Central', '021640404', 'fricrot@amortiguadores.com'),
('80000014-0', 'Filtros Mann Importaciones', '021930505', 'mann@filtros.com.py'),
('80000015-0', 'Radiadores Paraguay S.A.', '021780606', 'radiadores@paraguay.com'),
('80000016-0', 'Correas Gates Distribuidora', '021970707', 'gates@correas.com.py'),
('80000017-0', 'Koreana Repuestos S.R.L.', '021590808', 'ventas@koreana.com.py'),
('80000018-0', 'American Parts S.A.', '021220909', 'american@parts.com.py'),
('80000019-0', 'LuzAuto Faros e Iluminación', '021301010', 'luzauto@iluminacion.com'),
('80000020-0', 'Metalúrgica Inyeccion S.R.L.', '021901111', 'metalurgica@inyeccion.com'),
('80000021-0', 'Suspensiones del Mercosur', '021551212', 'mercosur@suspensiones.com'),
('80000022-0', 'Lubricantes Mobil Paraguay', '021601313', 'mobil@lubricantes.com.py'),
('80000023-0', 'Cajas Automáticas Avanzadas', '021651414', 'cajas@automaticas.com.py'),
('80000024-0', 'Sensores y Electrónica Auto', '021581515', 'sensores@electronica.com'),
('80000025-0', 'Juntas y Motores San Blas', '021571616', 'sanblas@motores.com.py'),
('80000026-0', 'Climatización Automotriz S.A.', '021961717', 'clima@automotriz.com.py'),
('80000027-0', 'Frenos Cerámicos S.R.L.', '021501818', 'ceramicos@frenos.com'),
('80000028-0', 'Direcciones Hidráulicas Asunción', '021641919', 'hidraulicas@asuncion.com'),
('80000029-0', 'Autochapa Repuestos', '021752020', 'chapas@autochapa.com.py'),
('80000030-0', 'Nippon Parts Import', '021612121', 'nippon@parts.com.py');

-- Tabla: REPUESTOS 
INSERT INTO REPUESTOS (IdProveedor, Nombre, PrecioCosto, StockDisponible) VALUES
(1, 'Pastillas de Fnero Delanteras', 120000, 50), (2, 'Filtro de Aceite Sintético', 45000, 120),
(3, 'Bujías de Iridio (Kit 4)', 180000, 40), (4, 'Amortiguador Delantero Izq', 350000, 20),
(5, 'Filtro de Aire Motor', 55000, 80), (6, 'Correa de Distribución Dentada', 110000, 35),
(7, 'Batería 12V 75Ah Libre Mantenimiento', 480000, 15), (8, 'Disco de Freno Ventilado', 220000, 30),
(9, 'Radiador de Agua de Motor', 420000, 10), (10, 'Bomba de Agua Interna', 260000, 25),
(11, 'Alternador de Corriente 90A', 650000, 8), (12, 'Motor de Arranque Eléctrico', 550000, 12),
(13, 'Embrague Kit Completo Prensa y Disco', 850000, 7), (14, 'Faro Delantero Izquierdo LED', 720000, 6),
(15, 'Espejo Retrovisor Lateral Eléctrico', 310000, 14), (16, 'Termostato de Refrigeración', 850000, 45),
(17, 'Sonda Lambda Sensor Oxígeno', 290000, 18), (18, 'Compresor de Aire Acondicionado', 1250000, 5),
(19, 'Soporte de Motor Delantero', 140000, 22), (20, 'Rótula de Suspensión Inferior', 750000, 60),
(21, 'Cremallera de Dirección Hidráulica', 1100000, 4), (22, 'Bobina de Encendido Individual', 1950000, 30),
(23, 'Inyector de Combustible Multipunto', 320000, 16), (24, 'Sensor del Sistema ABS de Rueda', 150000, 25),
(25, 'Junta de Culata Amianto Motor', 180000, 40), (26, 'Líquido de Frenos Grado DOT4 1L', 40000, 100),
(27, 'Zapata de Freno para Tambor Trasero', 130000, 35), (28, 'Condensador del Sistema de A/C', 380000, 12),
(29, 'Filtro de Combustible Diésel Rápido', 950000, 55), (30, 'Aceite de Motor Sintético 5W30 4L', 260000, 90);

-- Tabla: ORDEN_TRABAJO 
INSERT INTO ORDEN_TRABAJO (IdVehiculo, IdTaller, FechaIngreso, DescripcionDiagnostico, ManoObra, Estado) VALUES
(1, 1, '2026-01-10', 'Cambio de pastillas de freno por desgaste', 150000, 'Completado'),
(2, 2, '2026-01-12', 'Mantenimiento de kilometraje y cambio de aceite', 80000, 'Completado'),
(3, 3, '2026-01-15', 'Reemplazo de bujías dañadas y tirones de motor', 120000, 'Completado'),
(4, 4, '2026-01-18', 'Falla en arranque eléctrico en frío', 200000, 'Completado'),
(5, 5, '2026-01-20', 'Golpeteo en suspensión delantera al andar', 250000, 'Completado'),
(6, 6, '2026-01-22', 'Mantenimiento preventivo de correa de distribución', 300000, 'Completado'),
(7, 7, '2026-01-25', 'El vehículo se quedó sin carga eléctrica general', 60000, 'Completado'),
(8, 8, '2026-01-28', 'Rectificación de discos y cambio de pastillas traseras', 180000, 'Completado'),
(9, 9, '2026-02-02', 'Temperatura elevada en tráfico pesado', 90000, 'Completado'),
(10, 10, '2026-02-05', 'Pérdida notable de líquido refrigerante por bomba', 220000, 'Completado'),
(11, 11, '2026-02-08', 'Alerta en tablero por batería floja o alternador', 140000, 'Completado'),
(12, 12, '2026-02-10', 'Falla mecánica interna en motor de arranque', 160000, 'Completado'),
(13, 13, '2026-02-12', 'Pedal de embrague excesivamente duro al embragar', 400000, 'Completado'),
(14, 14, '2026-02-15', 'Óptica rota por impacto menor en estacionamiento', 70000, 'Completado'),
(15, 15, '2026-02-18', 'Espejo retrovisor izquierdo desprendido de base', 50000, 'Completado'),
(16, 16, '2026-02-20', 'Termostato trancado en posición cerrada', 110000, 'Completado'),
(17, 17, '2026-02-22', 'Lectura errática de sensor de oxígeno en escáner', 130000, 'En Proceso'),
(18, 18, '2026-02-25', 'Compresor ruidoso no acopla al encender aire', 350000, 'En Proceso'),
(19, 19, '2026-02-28', 'Vibraciones fuertes en cabina al regular motor', 190000, 'En Proceso'),
(20, 20, '2026-03-02', 'Juego excesivo en rótulas de suspensión inferiores', 100000, 'En Proceso'),
(21, 21, '2026-03-05', 'Fuga de aceite hidráulico por retenes de cremallera', 450000, 'En Proceso'),
(22, 22, '2026-03-08', 'Falla de encendido cilindro 2 bobina abierta', 80000, 'En Proceso'),
(23, 23, '2026-03-10', 'Limpieza y calibración de inyectores tapados', 260000, 'En Proceso'),
(24, 24, '2026-03-12', 'Luz testigo de ABS encendida fija en tablero', 150000, 'Pendiente'),
(25, 25, '2026-03-14', 'Soplado de junta de tapa de cilindro mezcla agua', 800000, 'Pendiente'),
(26, 26, '2026-03-16', 'Falta de presión en pedal de freno pérdida fluida', 160000, 'Pendiente'),
(27, 27, '2026-03-18', 'Ruidos metálicos en frenos de tambor trasero', 90000, 'Pendiente'),
(28, 28, '2026-03-20', 'Aire acondicionado no enfría fuga en condensador', 70000, 'Pendiente'),
(29, 29, '2026-03-22', 'Filtro de combustible saturado motor pierde fuerza', 120000, 'Pendiente'),
(30, 30, '2026-03-25', 'Cambio de aceite de motor y filtros generales', 280000, 'Pendiente');

-- Tabla Asociativa: ORDEN_REPUESTO 
INSERT INTO ORDEN_REPUESTO (IdOrden, IdRepuesto, Cantidad, PrecioVenta) VALUES
(1, 1, 1, 150000), (2, 2, 1, 60000), (3, 3, 1, 220000), (4, 4, 1, 420000), (5, 5, 2, 70000),
(6, 6, 1, 140000), (7, 7, 1, 550000), (8, 8, 2, 260000), (9, 9, 1, 490000), (10, 10, 1, 310000),
(11, 11, 1, 750000), (12, 12, 1, 620000), (13, 13, 1, 980000), (14, 14, 1, 850000), (15, 15, 1, 380000),
(16, 16, 1, 105000), (17, 17, 1, 350000), (18, 18, 1, 1450000), (19, 19, 2, 180000), (20, 20, 2, 95000),
(21, 21, 1, 1300000), (22, 22, 1, 240000), (23, 23, 4, 380000), (24, 24, 1, 190000), (25, 25, 1, 220000),
(26, 26, 2, 55000), (27, 27, 1, 160000), (28, 28, 1, 450000), (29, 29, 1, 120000), (30, 30, 1, 310000);
GO

-- EJERCICIOS DE CLASE
-- EJERCICIO 1
SELECT CI, Nombre, Direccion
FROM CLIENTE

-- EJERCICIO 2
SELECT Nombre, Especialidad
FROM TALLER

-- EJERCICIO 3
SELECT Nombre, PrecioCosto, StockDisponible
FROM REPUESTOS
WHERE StockDisponible > 0;

-- EJERCICIO 4
SELECT *
FROM ORDEN_TRABAJO
--WHERE Estado = 'Completado'
WHERE Estado LIKE '%Completado'

-- EJERCICIO 5

SELECT RazonSocial, RUC, Telefono
FROM PROVEEDOR
ORDER BY RazonSocial ASC;

-- EJERCICIO 6
SELECT *
FROM ORDEN_TRABAJO
ORDER BY ManoObra DESC;

-- EJERCICIO 7  
SELECT *
FROM VEHICULO
ORDER BY Anho DESC;

-- EJERCICIO 8
SELECT A.Nombre,A.Apellido,A.CI, B.Modelo
FROM CLIENTE A
    INNER JOIN VEHICULO B ON A.IdCliente = B.IdCliente;

-- EJERCICIO 9
SELECT B.RazonSocial, A.Nombre, A.StockDisponible
FROM REPUESTOS A
    INNER JOIN PROVEEDOR B ON A.IdProveedor = B.IdProveedor

-- EJERCICIO 10
SELECT C.Modelo, C.Matricula, B.Nombre AS [Nombre Taller]
FROM ORDEN_TRABAJO A
    INNER JOIN TALLER B ON A.IdTaller = B.IdTaller
    INNER JOIN VEHICULO C ON A.IdVehiculo = C.IdVehiculo

-- EJERCICIO 11
SELECT B.IdOrden, A.Nombre, B.Cantidad
FROM REPUESTOS A
 INNER JOIN ORDEN_REPUESTO B ON A.IdRepuesto = B.IdRepuesto

-- EJERCICIO 12
SELECT A.Nombre, C.Estado
FROM CLIENTE A
    JOIN VEHICULO B ON A.IdCliente = B.IdCliente
    JOIN ORDEN_TRABAJO C ON B.IdVehiculo = C.IdVehiculo
WHERE C.Estado = 'En Proceso'

-- EJERCICIO 13
SELECT A.Nombre, B.Modelo, D.Nombre AS [Nombre Taller]
FROM CLIENTE A
  JOIN VEHICULO B ON A.IdCliente = B.IdCliente
  JOIN ORDEN_TRABAJO C ON B.IdVehiculo = C.IdVehiculo
  LEFT JOIN TALLER D ON C.IdTaller = D.IdTaller
