-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE SistemaFinanciero;
GO
USE SistemaFinanciero;
GO

-- =========================================================================
-- 2. TABLAS DEL SUPERTIPO Y SUBTIPOS (JERARQUÍA DE CLIENTES)
-- =========================================================================

-- Tabla Supertipo: Datos comunes para todos los clientes
CREATE TABLE Cliente (
    Codigo_Cliente INT IDENTITY(1,1),
    CI VARCHAR(20) NOT NULL,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Direccion VARCHAR(250) NOT NULL,
    Telefono_Contacto VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (Codigo_Cliente),
    CONSTRAINT UQ_Cliente_CI UNIQUE (CI)
);

-- Tabla Subtipo: Clientes Humanos (Herencia 1:1)
CREATE TABLE Persona_Fisica (
    Codigo_Cliente INT,
    RUC VARCHAR(20) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Sexo CHAR(1) NOT NULL,
    CONSTRAINT PK_Persona_Fisica PRIMARY KEY (Codigo_Cliente),
    CONSTRAINT FK_Fisica_Cliente FOREIGN KEY (Codigo_Cliente) 
        REFERENCES Cliente (Codigo_Cliente) ON DELETE CASCADE,
    CONSTRAINT CK_Fisica_Sexo CHECK (Sexo IN ('M', 'F', 'O')) -- Masculino, Femenino, Otro
);

-- Tabla Subtipo: Clientes Institucionales (Herencia 1:1)
CREATE TABLE Persona_Juridica (
    Codigo_Cliente INT,
    RUC VARCHAR(20) NOT NULL,
    Tipo_Organizacion VARCHAR(50) NOT NULL, -- Comercial, Religiosa, Gubernamental, etc.
    Cantidad_Empleados INT NOT NULL,
    Nombre_Representante VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Persona_Juridica PRIMARY KEY (Codigo_Cliente),
    CONSTRAINT FK_Juridica_Cliente FOREIGN KEY (Codigo_Cliente) 
        REFERENCES Cliente (Codigo_Cliente) ON DELETE CASCADE,
    CONSTRAINT CK_Juridica_Empleados CHECK (Cantidad_Empleados >= 0)
);

-- =========================================================================
-- 3. TABLAS DE CUENTAS BANCARIAS
-- =========================================================================

-- Cuenta Corriente: Restricción de TITULAR ÚNICO (Relación 1:N)
CREATE TABLE Cuenta_Corriente (
    Numero_Cuenta VARCHAR(20),
    Saldo_Actual DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    Codigo_Cliente INT NOT NULL, -- FK directa obliga a tener un único titular
    CONSTRAINT PK_Cuenta_Corriente PRIMARY KEY (Numero_Cuenta),
    CONSTRAINT FK_Corriente_Cliente FOREIGN KEY (Codigo_Cliente) 
        REFERENCES Cliente (Codigo_Cliente)
);

-- Cuenta de Ahorro: Base para relación de COTITULARIDAD
CREATE TABLE Cuenta_Ahorro (
    Numero_Cuenta VARCHAR(20),
    Saldo_Actual DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT PK_Cuenta_Ahorro PRIMARY KEY (Numero_Cuenta)
);

-- =========================================================================
-- 4. TABLA INTERMEDIA (RELACIÓN MUCHOS A MUCHOS)
-- =========================================================================

-- Tabla Asociativa: Resuelve la cotitularidad de las Cuentas de Ahorro (M:N)
CREATE TABLE Cliente_Cuenta_Ahorro (
    Codigo_Cliente INT,
    Numero_Cuenta VARCHAR(20),
    CONSTRAINT PK_Cliente_Cuenta_Ahorro PRIMARY KEY (Codigo_Cliente, Numero_Cuenta),
    CONSTRAINT FK_Puente_Cliente FOREIGN KEY (Codigo_Cliente) 
        REFERENCES Cliente (Codigo_Cliente),
    CONSTRAINT FK_Puente_CuentaAhorro FOREIGN KEY (Numero_Cuenta) 
        REFERENCES Cuenta_Ahorro (Numero_Cuenta) ON DELETE CASCADE
);