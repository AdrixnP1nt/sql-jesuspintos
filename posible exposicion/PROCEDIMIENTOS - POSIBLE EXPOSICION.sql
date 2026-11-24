--PROCEDIMIENTOS - EJERCICIO 1
USE TransporteDB;
GO

CREATE OR ALTER PROCEDURE sp_ReasignarAgenciaEncomienda
    @NroEncomienda INT,
    @NroNuevaAgencia INT
AS
BEGIN
    SET NOCOUNT ON;

    -- a. Verificar que la encomienda exista
    IF NOT EXISTS (SELECT 1 FROM Encomienda WHERE NroEncomienda = @NroEncomienda)
    BEGIN
        RAISERROR('La encomienda especificada no existe.', 16, 1);
        RETURN;
    END;

    -- b. Verificar que la nueva agencia exista
    IF NOT EXISTS (SELECT 1 FROM Agencia WHERE NroAgencia = @NroNuevaAgencia)
    BEGIN
        RAISERROR('La nueva agencia especificada no existe.', 16, 1);
        RETURN;
    END;

    -- b. Verificar que la nueva agencia sea diferente a la actual
    IF EXISTS (
        SELECT 1 
        FROM Encomienda 
        WHERE NroEncomienda = @NroEncomienda 
          AND NroAgencia = @NroNuevaAgencia
    )
    BEGIN
        RAISERROR('La nueva agencia debe ser diferente a la agencia actual de la encomienda.', 16, 1);
        RETURN;
    END;

    -- c. Verificar que el viaje asociado no haya llegado a destino
    IF EXISTS (
        SELECT 1
        FROM Encomienda e
        INNER JOIN Viaje v ON e.NroViaje = v.NroViaje
        WHERE e.NroEncomienda = @NroEncomienda
          AND v.FechaHoraLlegada IS NOT NULL
    )
    BEGIN
        RAISERROR('No se puede reasignar la agencia porque el viaje ya llegó a destino.', 16, 1);
        RETURN;
    END;

    -- d. Verificar que el pasajero resida en el mismo país que la nueva agencia
    IF NOT EXISTS (
        SELECT 1
        FROM Encomienda e
        INNER JOIN Pasajero p ON e.NroPasajero = p.NroPasajero
        CROSS JOIN Agencia a_nueva
        INNER JOIN Ciudad c_nueva ON a_nueva.NroCiudad = c_nueva.NroCiudad
        WHERE e.NroEncomienda = @NroEncomienda
          AND a_nueva.NroAgencia = @NroNuevaAgencia
          AND p.NroPais = c_nueva.NroPais
    )
    BEGIN
        RAISERROR('El pasajero no reside en el mismo país que la nueva agencia.', 16, 1);
        RETURN;
    END;

    -- Operación: Actualizar NroAgencia validando integridad mediante JOINs
    UPDATE e
    SET e.NroAgencia = a_nueva.NroAgencia
    FROM Encomienda e
    INNER JOIN Viaje v ON e.NroViaje = v.NroViaje
    INNER JOIN Pasajero p ON e.NroPasajero = p.NroPasajero
    CROSS JOIN Agencia a_nueva
    INNER JOIN Ciudad c_nueva ON a_nueva.NroCiudad = c_nueva.NroCiudad
    WHERE e.NroEncomienda = @NroEncomienda
      AND a_nueva.NroAgencia = @NroNuevaAgencia
      AND e.NroAgencia <> a_nueva.NroAgencia
      AND v.FechaHoraLlegada IS NULL
      AND p.NroPais = c_nueva.NroPais;

    IF @@ROWCOUNT = 0
        RAISERROR('No se pudo actualizar la encomienda por incumplimiento de validaciones.', 16, 1);
    ELSE
        PRINT 'Agencia de la encomienda reasignada correctamente.';
END;
GO
-- EJERCICIO 2 --
USE TransporteDB;
GO

CREATE OR ALTER PROCEDURE sp_EliminarBultoPendiente
    @NroBulto INT,
    @NroPasajero INT
AS
BEGIN
    SET NOCOUNT ON;

    -- a. El bulto debe existir en la tabla Bulto
    IF NOT EXISTS (SELECT 1 FROM Bulto WHERE NroBulto = @NroBulto)
    BEGIN
        RAISERROR('El bulto especificado no existe.', 16, 1);
        RETURN;
    END;

    -- b. El bulto debe pertenecer al pasajero indicado (a través de su pasaje)
    IF NOT EXISTS (
        SELECT 1
        FROM Bulto b
        INNER JOIN Pasaje pa ON b.NroPasaje = pa.NroPasaje
        WHERE b.NroBulto = @NroBulto
          AND pa.NroPasajero = @NroPasajero
    )
    BEGIN
        RAISERROR('El bulto no existe o no pertenece al pasajero indicado a través de un pasaje.', 16, 1);
        RETURN;
    END;

    -- c. El viaje correspondiente al pasaje aún no debe haber partido
    IF EXISTS (
        SELECT 1
        FROM Bulto b
        INNER JOIN Pasaje pa ON b.NroPasaje = pa.NroPasaje
        INNER JOIN Viaje v ON pa.NroViaje = v.NroViaje
        WHERE b.NroBulto = @NroBulto
          AND pa.NroPasajero = @NroPasajero
          AND NOT (v.FechaHoraSalida > GETDATE() AND v.FechaHoraLlegada IS NULL)
    )
    BEGIN
        RAISERROR('El bulto no puede eliminarse porque el viaje ya partió o finalizó.', 16, 1);
        RETURN;
    END;

    -- d. El bulto no debe superar los 50 kg de peso
    IF EXISTS (
        SELECT 1
        FROM Bulto
        WHERE NroBulto = @NroBulto
          AND PesoTotal > 50
    )
    BEGIN
        RAISERROR('El bulto supera los 50 kg y requiere autorización administrativa.', 16, 1);
        RETURN;
    END;

    -- Operación: Eliminar el registro de Bulto utilizando JOIN con las tablas relacionadas
    DELETE b
    FROM Bulto b
    INNER JOIN Pasaje pa ON b.NroPasaje = pa.NroPasaje
    INNER JOIN Viaje v ON pa.NroViaje = v.NroViaje
    WHERE b.NroBulto = @NroBulto
      AND pa.NroPasajero = @NroPasajero
      AND v.FechaHoraSalida > GETDATE()
      AND v.FechaHoraLlegada IS NULL
      AND b.PesoTotal <= 50;

    IF @@ROWCOUNT = 0
        RAISERROR('No se eliminó ningún bulto; verifique las condiciones.', 16, 1);
    ELSE
        PRINT 'Bulto eliminado correctamente.';
END;
GO
-- EJERCICIO 3 --
USE TransporteDB;
GO

CREATE OR ALTER VIEW vw_ResumenCargaPorViaje
AS
SELECT
    v.NroViaje,
    v.FechaHoraSalida,
    v.FechaHoraLlegada,
    o.NroOmnibus,
    t.Descripcion AS TipoOmnibus,
    co.NombreCiudad AS CiudadOrigen,
    cd.NombreCiudad AS CiudadDestino,
    COUNT(b.NroBulto) AS CantidadTotalBultos,
    ISNULL(SUM(b.PesoTotal), 0) AS PesoAcumuladoKg
FROM Viaje v
INNER JOIN Omnibus o ON v.NroOmnibus = o.NroOmnibus
INNER JOIN TipoOmnibus t ON o.NroTipoOmnibus = t.NroTipoOmnibus
INNER JOIN Ciudad co ON v.NroCiudadOrigen = co.NroCiudad
INNER JOIN Ciudad cd ON v.NroCiudadDestino = cd.NroCiudad
LEFT JOIN Pasaje pa ON pa.NroViaje = v.NroViaje
LEFT JOIN Encomienda en ON en.NroViaje = v.NroViaje
LEFT JOIN Bulto b
    ON b.NroPasaje = pa.NroPasaje
    OR b.NroEncomienda = en.NroEncomienda
GROUP BY
    v.NroViaje,
    v.FechaHoraSalida,
    v.FechaHoraLlegada,
    o.NroOmnibus,
    t.Descripcion,
    co.NombreCiudad,
    cd.NombreCiudad;
GO
/*
1. sp_ReasignarAgenciaEncomienda (Cambiar la agencia de una encomienda)Es un procedimiento almacenado que mueve una encomienda de su agencia actual a otra nueva, 
pero antes revisa que todo sea válido:  

Revisa que existan: Comprueba que el número de encomienda y el número de la nueva agencia existan en la base de datos.   
Evita repetir agencia: Verifica que la nueva agencia no sea la misma que ya tiene asignada la encomienda.   
Revisa el estado del viaje: Mira si el viaje ya terminó (FechaHoraLlegada IS NOT NULL). Si ya llegó a destino, no permite el cambio.   
Valida el país: Compara el país donde vive el pasajero (Pasajero.NroPais) con el país donde está ubicada la nueva agencia (Ciudad.NroPais) para asegurarse de que coincidan.   
Actualiza: Si pasa todas las pruebas, cambia NroAgencia en la tabla Encomienda usando JOIN entre las tablas relacionadas.

2. sp_EliminarBultoPendiente (Borrar un bulto antes de que salga el viaje)Es un procedimiento almacenado para eliminar un bulto de la tabla Bulto, 
siempre y cuando cumpla ciertas condiciones de seguridad y operación:   
Revisa existencia y dueño: Confirma que el bulto exista y que esté vinculado a un pasaje que pertenezca al pasajero indicado.   
Revisa que el viaje no haya empezado: Comprueba que la hora de salida del viaje sea futura (FechaHoraSalida > GETDATE()) y que aún no haya llegado (FechaHoraLlegada IS NULL).   
Revisa el peso: Impide borrarlo si pesa más de 50 kg (PesoTotal > 50), ya que los bultos pesados requieren autorización administrativa.   
Elimina: Si todo está en orden, borra el registro de Bulto conectando Bulto, Pasaje y Viaje con JOIN.   

3. vw_ResumenCargaPorViaje (Reporte resumen de carga por viaje)Es una vista (una consulta guardada que actúa como una tabla virtual) que junta información de varios viajes para mostrar
un resumen fácil de leer:   
Datos del viaje y vehículo: Muestra el número de viaje, fechas de salida/llegada, número de ómnibus, tipo de ómnibus (ej. Semicama, Cama Ejecutiva) y ciudades de origen y destino.   
Conteo y peso de bultos: Cuenta cuántos bultos tiene cada viaje (COUNT) y suma su peso total (SUM), poniendo 0 si no tiene ninguno (ISNULL).   
Uso de LEFT JOIN: Se usa LEFT JOIN para no perder los viajes que todavía no tienen bultos cargados, y se conecta con Pasaje y Encomienda porque un bulto puede relacionarse con el viaje por cualquiera de esas vías.
Agrupación (GROUP BY): Agrupa los resultados por viaje para que aparezca una fila consolidada por cada viaje.

*/