USE SistemaFinanciero;
GO


-- =========================================================================
-- 1. INSERTAR EN LA TABLA CLIENTE

-- =========================================================================
INSERT INTO Cliente (CI, Nombre_Completo, Direccion, Telefono_Contacto) VALUES 
('4.512.345', 'Carlos Alberto Giménez López', 'Avda. Mariscal López 1420, Asunción', '0981123456'),
('3.899.122', 'María Elena Fleitas Benítez', 'Calle Palma 455, San Lorenzo', '0971987654'),
('5.122.900', 'Juan José Ortíz Maidana', 'Ruta PY02 Km 10, Ciudad del Este', '0961555444'),
('4.850.123', 'Alejandro Daniel Benítez Gómez', 'Avda. Eusebio Ayala 3510, Asunción', '0982111222'),
('5.012.456', 'Laura Beatriz Martínez Recalde', 'Calle Iturbe 845, Luque', '0972333444'),
('3.654.789', 'Gustavo Adolfo Cáceres Ríos', 'Avda. Carlos Antonio López, Mariano Roque Alonso', '0961555666'),
('6.102.304', 'Camila Belén Zarza Ortíz', 'Ruta PY01 Km 15, San Lorenzo', '0983777888'),
('4.111.222', 'Rodrigo Manuel Fernández Insfrán', 'Calle Boquerón 412, Lambaré', '0991999000'),
('5.444.333', 'Milagros Araceli Vera Duarte', 'Avda. Gaspar Rodríguez de Francia, Capiatá', '0975123456'),
('3.999.888', 'Diego Armando Mendoza Galeano', 'Calle Cerro Corá 1250, Fernando de la Mora', '0984654321'),
('8.001.234', 'Distribuidora Paranaense S.A.', 'Avda. Aviadores del Chaco 2050, Asunción', '021610200'),
('9.455.600', 'Fundación San Roque (ONG)', 'Coronel Oviedo 789, Villarrica', '0541443322'),
('8.002.555', 'Comercial El Hito S.A.', 'Avda. San Martín 450, Asunción', '021600700'),
('9.101.202', 'Tecnología Avanzada Paraguay S.R.L.', 'Avda. Santa Teresa 2210, Asunción', '021300400'),
('8.555.444', 'Supermercados del Sur S.A.', 'Ruta PY01 Km 20, J. Augusto Saldívar', '0293240500');

-- =========================================================================
-- 2. INSERTAR EN PERSONA_FISICA (10 REGISTROS - SUBTIPO)

-- =========================================================================
INSERT INTO Persona_Fisica (Codigo_Cliente, RUC, Fecha_Nacimiento, Sexo) VALUES 
(1, '4512345-1', '1985-05-14', 'M'),
(2, '3899122-2', '1990-11-23', 'F'),
(3, '5122900-0', '1998-02-02', 'M'),
(4, '4850123-1', '1988-04-12', 'M'),
(5, '5012456-2', '1993-09-25', 'F'),
(6, '3654789-0', '1982-01-15', 'M'),
(7, '6102304-3', '2001-07-30', 'F'),
(8, '4111222-4', '1987-11-05', 'M'),
(9, '5444333-5', '1996-03-22', 'F'),
(10, '3999888-6', '1984-08-18', 'M');

-- =========================================================================
-- 3. INSERTAR EN PERSONA_JURIDICA 

-- =========================================================================
INSERT INTO Persona_Juridica (Codigo_Cliente, RUC, Tipo_Organizacion, Cantidad_Empleados, Nombre_Representante) VALUES 
(11, '80012345-6', 'Comercial', 45, 'Ing. Ricardo Torres'),
(12, '94556001-3', 'Sin fines de lucro', 12, 'Lic. Beatriz Cáceres'),
(13, '80025550-1', 'Comercial', 85, 'Lic. Marcos Ayala'),
(14, '91012020-2', 'Servicios', 30, 'Ing. Elena Rodríguez'),
(15, '85554440-3', 'Comercial', 150, 'Sr. Javier Bareiro');

-- =========================================================================
-- 4. INSERTAR EN CUENTA_CORRIENTE 

-- =========================================================================
INSERT INTO Cuenta_Corriente (Numero_Cuenta, Saldo_Actual, Codigo_Cliente) VALUES 
('CC-1001-A', 5450000.00, 1),
('CC-1002-B', 12500000.50, 1),
('CC-2001-A', 850000.00, 2),
('CC-4001-A', 45000000.00, 11), 
('CC-5001-A', 3200000.00, 12),  
('CC-1003-C', 1500000.00, 3),
('CC-1004-D', 8900000.25, 4),
('CC-1005-E', 450000.00, 5),
('CC-1006-F', 12350000.00, 6),
('CC-1007-G', 2700000.00, 7),
('CC-1008-H', 6200000.00, 8),
('CC-1009-I', 350000.00, 9),
('CC-1010-J', 18400000.75, 10),
('CC-6001-A', 145000000.00, 13), 
('CC-6002-B', 48200000.00, 14);  

-- =========================================================================
-- 5. INSERTAR EN CUENTA_AHORRO (15 REGISTROS)

-- =========================================================================
INSERT INTO Cuenta_Ahorro (Numero_Cuenta, Saldo_Actual) VALUES 
('CA-8001-X', 1500000.00),
('CA-8002-Y', 7800000.00),
('CA-8003-Z', 22350000.00),
('CA-8004-W', 450000.00),
('CA-8005-V', 115000000.00),
('CA-8006-U', 3500000.00),
('CA-8007-T', 12800000.00),
('CA-8008-S', 750000.00),
('CA-8009-R', 42000000.00),
('CA-8010-Q', 1950000.00),
('CA-8011-P', 6500000.00),
('CA-8012-O', 28300000.60),
('CA-8013-N', 500000.00),
('CA-8014-M', 15700000.00),
('CA-8015-L', 94000000.00);

-- =========================================================================
-- 6. INSERTAR EN CLIENTE_CUENTA_AHORRO (15 REGISTROS - TABLA PUENTE M:N)

-- =========================================================================
INSERT INTO Cliente_Cuenta_Ahorro (Codigo_Cliente, Numero_Cuenta) VALUES 
(1, 'CA-8001-X'),
(2, 'CA-8001-X'), 
(3, 'CA-8002-Y'),
(3, 'CA-8003-Z'),
(4, 'CA-8004-W'),
(5, 'CA-8005-V'),
(6, 'CA-8006-U'),
(7, 'CA-8007-T'),
(8, 'CA-8008-S'),
(9, 'CA-8009-R'),
(10, 'CA-8010-Q'),
(11, 'CA-8011-P'),
(12, 'CA-8012-O'),
(13, 'CA-8013-N'),
(14, 'CA-8014-M');
GO
