DECLARE @CodigoRetorno INT;
BEGIN TRAN;
EXEC @CodigoRetorno = sp_AsignarAsientoPasajero
		@NroOmnibus = 2,
		@NroAsiento = 50,
		@NroPiso = 2,
		@PasillooVentanilla = 'V',
		@NroPasajero = 1,
		@NroViaje = 1;
IF @CodigoRetorno = 1
	ROLLBACK TRAN;
ELSE
	COMMIT TRAN
PRINT 'Valor de retorno ' + CAST(@CodigoRetorno AS VARCHAR(5));