--1 Asiento no se encuentra ya registrado(Ocupado)
--2 El pasajero exista en la tabla de Pasajero
--3 El omnibus realice el viaje

--SELECT * FROM Asiento

ALTER PROCEDURE sp_AsignarAsientoPasajero
	@NroOmnibus INT, 
	@NroAsiento INT,
	@NroPiso SMALLINT,
	@PasillooVentanilla CHAR(1),
	@NroPasajero INT,
	@NroViaje INT
AS
BEGIN
	SET NOCOUNT 0;
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
			VALUES (@NroOmnibus, @NroAsiento, @NroPiso, @PasillooVentanilla)
			PRINT 'Asiento asignado y registrado con exito';
			RETURN 0; --RETORNA 0 SI TODO SALIO BIEN

	END TRY

	BEGIN CATCH

		PRINT 'Codigo del error ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensaje de error ' + ERROR_MESSAGE();
		RETURN 1;
	END CATCH
	
END;