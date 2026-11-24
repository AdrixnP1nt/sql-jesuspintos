-- DATETIME | DATETIME2

    DECLARE @dt DATETIME = GETDATE();
    DECLARE @dt2 DATETIME2 = GETDATE();

    SELECT
        @dt AS [Formato Datetime],
        @dt2 AS [Formato Datetime2],
        GETDATE() AS [GETDATE];

    DECLARE @Fecha DATE = '2026-10-06'

    SELECT 
        YEAR(@Fecha) AS Anho, 
        MONTH(@Fecha) AS Mes,
        DAY(@Fecha) AS Dia;


    DECLARE @F DATETIME = GETDATE();

    SELECT
        FORMAT(@F,'dd/MM/yyyy')
         AS [Formato corto],
        FORMAT(@F, 'dddd, d \de MMMM')
         AS [Formato Largo],
        FORMAT(@F, 'hh:mm tt')
         AS [Hora 12h],
        FORMAT(@F, 'HH:mm')
         AS [Hora 24h];
          
     DECLARE @Hoy DATETIME = GETDATE();

     SELECT CONVERT (VARCHAR(10), @Hoy, 103) AS Formato;

     SELECT CONVERT (VARCHAR(8), @Hoy, 112) AS FormatoISO;