--EJERCICIOS UNION/UNION ALL

SELECT * FROM Estacion;
SELECT * FROM Agencia;

--1
SELECT Nombre,Telefono, 'Estación' Origen
FROM Estacion
UNION ALL
SELECT Nombre,Telefono, 'Agencia' Origen
FROM Agencia

--2
SELECT * FROM Pasaje
SELECT * FROM Encomienda

SELECT FORMAT(FechaPasaje, 'yyyy-MM-dd') FechaPasaje, PrecioPasaje Importe, 'VentaPasaje' Tipo
FROM Pasaje
UNION 
SELECT FORMAT(FechaEncomienda, 'yyyy-MM-dd') FechaEncomienda, PrecioEncomienda Importe, 'EnvioEncomienda' Tipo
FROM Encomienda

--USO DE CAST EN FECHA/HORA
SELECT CAST(FechaEncomienda AS DATE) Fecha, --ORIGINAL
	   CAST(FechaEncomienda AS DATETIME)Fecha2, --PRUEBA 1
	   CAST(FechaEncomienda AS VARCHAR) Fecha3, --PRUEBA 2
	   CAST(FechaEncomienda AS CHAR) Fecha4, --PRUEBA 3
	   PrecioEncomienda Importe,
	   'EnvioEncomienda' Tipo
FROM Encomienda;

--1 Asiento no se encuentra ya registrado(Ocupado)
--2 El pasajero exista en la tabla de Pasajero
--3 El omnibus realice el viaje

--SELECT * FROM Asiento

CREATE PROCEDURE sp_AsignarAsientoPasajero
	@NroOmnibus INT, 
	@NroAsiento INT,
	@NroPiso SMALLINT,
	@PasillooVentanilla CHAR(1),
	@NroPasajero INT,
	@NroViaje INT
AS
BEGIN
	BEGIN TRY
		--CONTROLAR EL ASIENTO
		IF EXISTS( SELECT 1 FROM Asiento --CONDICION DE EXISTENCIA ASIENTO RETURN 1
				   WHERE NroAsiento = @NroAsiento
				   AND NroOmnibus = @NroOmnibus)
		BEGIN
			RAISERROR('El número de asiento ya se encuentra registrado', 16,1);
		END
		--CONTROLAR EL PASAJERO
		IF NOT EXISTS( SELECT 1 FROM Pasajero --CONDICION DE EXISTENCIA PASAJERO RETURN 1
				   WHERE NroPasajero = @NroPasajero)
		BEGIN
			RAISERROR('El pasajero no existe', 16,1);
		END
		--CONTROL DEL DESTINO
		IF NOT EXISTS( SELECT 1 FROM Viaje --CONDICION DE REGISTRO RETURN 1
				   WHERE NroViaje = @NroViaje
				   AND NroOmnibus = @NroOmnibus)
		BEGIN
			RAISERROR('El omnibus no corresponde o no esta disponible para el viaje', 16,1);
		END

		INSERT INTO Asiento (NroOmnibus, NroAsiento, NroPiso, PasillooVentanilla)
			VALUE(@NroOmnibus, @NroAsiento, @NroPiso, @PasillooVentanilla)
			PRINT 'Asiento asignado y registrado con exito';
			RETURN 0; --RETORNA 0 SI TODO SALIO BIEN

	END TRY

	BEGIN CATCH

		PRINT 'Codigo del error' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensaje de error' + ERROR_MESSAGE();
		RETURN 1;
	END CATCH
	
END;