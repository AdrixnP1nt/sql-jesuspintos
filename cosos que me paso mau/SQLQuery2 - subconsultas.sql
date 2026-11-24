-- EJERCICIO 1 - SUBCONSULTAS
select Y.IdOrden, Y.FechaIngreso, Y.ManoObra 
from ORDEN_TRABAJO Y
where ManoObra > (SELECT AVG(ManoObra) FROM ORDEN_TRABAJO);

-- EJERCICIO 2

SELECT V.Modelo, V.Matricula, V.Anho
FROM VEHICULO V
WHERE V.Anho = (SELECT MIN(Anho) FROM VEHICULO);

-- EJERCICIO 3

SELECT R.IdRepuesto, R.Nombre, R.PrecioCosto
FROM REPUESTOS R
WHERE R.PrecioCosto <= (SELECT AVG(PrecioCosto) 
						FROM REPUESTOS B
						WHERE R.IdProveedor = B.IdProveedor)
AND R.IdProveedor = 1
ORDER BY 3 ASC;

-- EJERCICIO 4
SELECT  R.Nombre, R.StockDisponible -- DISTINCT PARA ELIMINAR LAS COINCIDENCIAS
FROM REPUESTOS R
WHERE StockDisponible > (SELECT StockDisponible FROM REPUESTOS WHERE IdRepuesto = 5)
--order by partition (IdRepuesto ASC)

/*INSERT INTO REPUESTOS_BKP
SELECT * FROM REPUESTOS

DELETE FROM REPUESTO

INSERT INTO REPUESTO
SELECT DISTINCT B.* FROM REPUESTOS_BKP B*/

-- EJERCICIO 5

SELECT IdOrden, IdTaller, ManoObra, Estado
FROM ORDEN_TRABAJO
WHERE ManoObra >= (SELECT MAX(ManoObra) FROM ORDEN_TRABAJO);

-- EJERCICIO DE PROCESO SUBCONSULTAS
-- EJERCICIO 1

SELECT 
A.RazonSocial,
(SELECT StockDisponible FROM REPUESTOS B WHERE B.IdProveedor = A.IdProveedor) StockDisponible
FROM PROVEEDOR A
WHERE A.IdProveedor IN(
	SELECT IdProveedor 
	FROM REPUESTOS 
	WHERE StockDisponible < 5
);

-- EJERCICIO 2

SELECT A.Nombre
FROM CLIENTE A
WHERE A.IdCliente IN(
	SELECT IdCliente 
	FROM VEHICULO 
	WHERE Modelo Like 'Toyota%'
);

-- EJERCICIO 3

SELECT A.Nombre
FROM CLIENTE A
WHERE IdCliente NOT IN(
	SELECT IdCliente 
	FROM VEHICULO 
	WHERE Anho < 2015
);

-- EJERCICIO 4

SELECT A.Nombre
FROM REPUESTOS A
WHERE A.IdProveedor NOT IN(
	SELECT IdProveedor
	FROM PROVEEDOR
	WHERE TELEFONO IS NULL 
);

-- EJERCICIO 5

SELECT V.Modelo, V.Matricula
FROM VEHICULO V
WHERE V.IdVehiculo IN(
	SELECT IdVehiculo
	FROM ORDEN_TRABAJO
	WHERE Estado LIKE 'Pendiente%'
);

-- EJERCICIO 6
SELECT T.Nombre, T.Direccion, T.Especialidad
FROM TALLER T
WHERE IdTaller IN(
	SELECT IdTaller
	FROM ORDEN_TRABAJO
	WHERE IdVehiculo IN(
		SELECT IdVehiculo
		FROM VEHICULO
		WHERE Anho = 2019
	)
);

-- EJERCICIO 7
SELECT O.IdOrden, O.Estado, O.ManoObra
FROM ORDEN_TRABAJO O
WHERE IdTaller IN(
	SELECT IdTaller
	FROM TALLER
	WHERE Especialidad = 'Chapa y Pintura'
)AND IdOrden IN(
	SELECT IdOrden
	FROM ORDEN_REPUESTO
	WHERE IdRepuesto IN(
		SELECT IdRepuesto
		FROM REPUESTOS
		WHERE IdProveedor = 3
	)
);

-- EJERCICIO 8

SELECT *
FROM ORDEN_TRABAJO
WHERE IdVehiculo IN(
	SELECT IdVehiculo
	FROM VEHICULO
	WHERE IdCliente IN(
		SELECT IdCliente
		FROM CLIENTE
		WHERE NroTelefono LIKE '0981%'
	)
)

SELECT * 
FROM ORDEN_TRABAJO
-- EJERCICIO 1
SELECT FechaIngreso, SUM(ManoObra) ManoObra
FROM ORDEN_TRABAJO
GROUP BY FechaIngreso
ORDER BY 1
-- EJERICIO 2 - FORMATEO DE FECHA
SELECT FechaIngreso, 
	   FORMAT(FechaIngreso, 'yyyy-MM')AnioMes, 
       FORMAT(FechaIngreso, 'yyyy')Anio,
	   FORMAT(FechaIngreso, 'MM')Mes,
	   FORMAT(FechaIngreso, 'dd')Dia,
	   FORMAT(FechaIngreso, 'yyyyMMdd')AnioMes,
	   FORMAT(FechaIngreso, 'dd/MM/yyyy')AnioMes,
	   YEAR(FechaIngreso)Anio,
	   MONTH(FechaIngreso)Mes,
	   DAY(FechaIngreso)Dia,
	   SUM(ManoObra) ManoObra
FROM ORDEN_TRABAJO
GROUP BY FechaIngreso, FORMAT(FechaIngreso, 'yyyy-MM'),FORMAT(FechaIngreso, 'yyyy'),FORMAT(FechaIngreso, 'MM'),FORMAT(FechaIngreso, 'dd'),FORMAT(FechaIngreso, 'yyyyMMdd'),FORMAT(FechaIngreso, 'yyyyMMdd')
ORDER BY 1

-- EJERCICIO 3
SELECT * FROM ORDEN_TRABAJO

SELECT *
FROM(
	SELECT ManoObra, FORMAT(FechaIngreso, 'yyyy-MM')AnioMes, 
		   AVG(ManoObra)PromedioManoObra
	FROM ORDEN_TRABAJO
	GROUP BY ManoObra, FORMAT(FechaIngreso, 'yyyy-MM')
) A 
WHERE A.AnioMes = '2026-01'
AND ManoObra > A.PromedioManoObra;
-- EJERCICIO 2
SELECT *
FROM(
	SELECT Estado, SUM(ManoObra)ManoObra
	FROM ORDEN_TRABAJO
	GROUP BY Estado
)A
WHERE Estado IN(
	SELECT DISTINCT Estado
	FROM ORDEN_TRABAJO
	WHERE Estado = 'Completado' 
);
-- OPCION 2
SELECT *
FROM(
	SELECT Estado, SUM(ManoObra)ManoObra
	FROM ORDEN_TRABAJO
	GROUP BY Estado
)A
WHERE EXISTS(SELECT Estado
			FROM ORDEN_TRABAJO A
			WHERE A.Estado = 'Completado'
	
);


-- EJERCICIOS DE CLASE
SELECT T.Nombre, T.Direccion, O.FechaIngreso
FROM TALLER T
	 JOIN ORDEN_TRABAJO O ON T.IdTaller = O.IdTaller
WHERE MONTH(O.FechaIngreso) NOT IN(2) -- <> (2)

SELECT T.Nombre, T.Direccion, O.FechaIngreso
FROM TALLER T
	 JOIN ORDEN_TRABAJO O ON T.IdTaller = O.IdTaller
WHERE FORMAT(O.FechaIngreso, 'MM') <> ('02')
/*
SELECT Nombre, Direccion
FROM TALLER
WHERE IdTaller IN(SELECT )
*/
-- EJERCICIO 2
SELECT * FROM ORDEN_REPUESTO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM TALLER

SELECT B.IdOrden,
	(SELECT IdRepuesto FROM  ORDEN_REPUESTO C WHERE B.IdOrden = C.IdOrden) IdRepuesto,
	(SELECT Nombre FROM TALLER A WHERE B.IdTaller = A.IdTaller)NombreTaller,
	(SELECT Cantidad FROM ORDEN_REPUESTO O WHERE O.IdOrden = B.IdOrden)Cantidad,
	B.Estado
FROM ORDEN_TRABAJO B
WHERE  B.Estado = 'Pendiente'

SELECT B.IdOrden,C.IdRepuesto,A.Nombre, C.Cantidad, B.Estado
FROM ORDEN_TRABAJO B
	JOIN TALLER A ON B.IdTaller = A.IdTaller
	JOIN ORDEN_REPUESTO C ON C.IdOrden = B.IdOrden
WHERE B.Estado = 'Pendiente'

SELECT A.IdOrden, A.IdRepuesto, B.NombreTaller,A.Cantidad, B.Estado
FROM ORDEN_REPUESTO A,
	(SELECT B.IdOrden,B.Estado, V.Nombre AS NombreTaller
	 FROM ORDEN_TRABAJO B, TALLER V
		WHERE B.IdTaller = V.IdTaller
		AND Estado = 'Pendiente'
	) B
WHERE A.IdOrden = B.IdOrden

-- EJERCICIO 3
SELECT O.IdOrden, O.Estado, O.ManoObra
FROM ORDEN_TRABAJO O
WHERE IdTaller IN(
	SELECT IdTaller
	FROM TALLER
	WHERE Especialidad = 'Chapa y Pintura'
)AND IdOrden IN(
	SELECT IdOrden 
	FROM ORDEN_REPUESTO
	WHERE IdRepuesto IN(
		SELECT IdRepuesto
		FROM REPUESTOS
		WHERE IdProveedor = 3
	)
);


SELECT O.IdOrden, O.Estado, O.ManoObra, T.Especialidad
FROM ORDEN_TRABAJO O
	JOIN ORDEN_REPUESTO B ON O.IdOrden = B.IdOrden 
	JOIN REPUESTOS C ON B.IdRepuesto = C.IdRepuesto
	JOIN TALLER T ON O.IdTaller = T.IdTaller
WHERE C.IdProveedor = 3
AND T.Especialidad = 'Chapa y Pintura'

/*==============================================================
			PROCESO DE BASE DE DATOS - SUBCONSULTAS
===============================================================*/
-- EJERCICIO 1
SELECT IdOrden, FechaIngreso, DescripcionDiagnostico
FROM ORDEN_TRABAJO,
(
	SELECT AVG(ManoObra)PromedioGral FROM ORDEN_TRABAJO
) B
WHERE FechaIngreso LIKE '2026-01%'
AND ManoObra > B.PromedioGral;
--EJERCICIO 2
SELECT * FROM VEHICULO
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM CLIENTE

SELECT V.Modelo, V.Matricula
FROM VEHICULO V
	JOIN ORDEN_TRABAJO O ON O.IdVehiculo = V.IdVehiculo
WHERE FORMAT(O.FechaIngreso, 'dd/MM/yyyy') LIKE '%03/2026'
AND V.IdCliente IN(
	SELECT IdCliente
	FROM VEHICULO V2
		JOIN ORDEN_TRABAJO O2 ON O2.IdVehiculo = V2.IdVehiculo
	GROUP BY V2.IdCliente
	HAVING 
		COUNT(O2.IdOrden) > 1
)

-- EJERCICIO 3
SELECT * FROM ORDEN_REPUESTO
SELECT * FROM ORDEN_TRABAJO

SELECT
	OT.IdOrden,
	OT.FechaIngreso,
	OT.DescripcionDiagnostico,
	SUM(O.Cantidad * O.PrecioVenta)TotalVentas
FROM ORDEN_TRABAJO OT
	JOIN ORDEN_REPUESTO O ON O.IdOrden = OT.IdOrden
WHERE DATEDIFF(DAY, OT.FechaIngreso, '2026-03-15') > 45
AND OT.FechaIngreso <= '2026-03-15'
GROUP BY OT.IdOrden,OT.FechaIngreso, OT.DescripcionDiagnostico
HAVING SUM(O.Cantidad * O.PrecioVenta) > (SELECT AVG(PrecioCosto) FROM REPUESTOS)

-- EJERCICIO 4

SELECT Nombre, Especialidad
FROM TALLER
WHERE IdTaller NOT IN(
	SELECT IdTaller
	FROM ORDEN_TRABAJO	
	WHERE FechaIngreso BETWEEN '2026-02-15' AND '2026-02-28'
)

-- EJERCICIO 5

SELECT Nombre, StockDisponible
FROM REPUESTOS R
	JOIN ORDEN_REPUESTO O ON O.IdRepuesto = R.IdRepuesto
	JOIN ORDEN_TRABAJO OT ON OT.IdOrden = O.IdOrden
WHERE OT.FechaIngreso <= DATEADD(MONTH, -1, (SELECT MAX(FechaIngreso) FROM ORDEN_TRABAJO))
 
 -- EJERCICIO 6
 
 SELECT DISTINCT Nombre,Apellido,NroTelefono
 FROM CLIENTE
 WHERE idCliente IN(
	SELECT IdCliente 
	FROM VEHICULO
	WHERE Anho > 2016 
	AND IdVehiculo IN(
		SELECT idVehiculo
		FROM ORDEN_TRABAJO
		WHERE DATEPART(QUARTER, FechaIngreso) = 1
	)
 )

 -- EJERCICIO 7

SELECT 
	OT.IdOrden,
	SUM(ORep.Cantidad * ORep.PrecioVenta) AS TotalVentas
FROM ORDEN_TRABAJO OT
	JOIN ORDEN_REPUESTO ORep ON ORep.IdOrden = OT.IdOrden
WHERE YEAR(OT.FechaIngreso) = 2026
AND MONTH(OT.FechaIngreso) = 2
GROUP BY OT.IdOrden, OT.ManoObra
HAVING SUM(ORep.Cantidad * ORep.PrecioVenta) > OT.ManoObra

-- EJERCICIO 8
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM ORDEN_REPUESTO
SELECT * FROM REPUESTOS

SELECT DISTINCT RazonSocial, Email
FROM PROVEEDOR
WHERE IdProveedor IN(
	SELECT IdProveedor
	FROM REPUESTOS
	WHERE StockDisponible > 0
	AND IdRepuesto IN(
		SELECT IdRepuesto
		FROM ORDEN_REPUESTO
		WHERE IdOrden IN(
			SELECT IdOrden
			FROM ORDEN_TRABAJO
			WHERE Estado = 'Completado'
			AND MONTH(FechaIngreso) = 1
			AND DAY(FechaIngreso) BETWEEN 1 AND 31
		)
	)
)
SELECT * FROM ORDEN_TRABAJO
SELECT * FROM VEHICULO
-- EJERCICIO 9
UPDATE ORDEN_TRABAJO
SET Estado = 'En Proceso'
WHERE Estado = 'Pendiente'
AND FechaIngreso < '2026-03-01'
AND IdVehiculo IN(
	SELECT IdVehiculo
	FROM VEHICULO
	WHERE Modelo LIKE 'Toyota%'
)

-- EJERCICIO 10
UPDATE ORDEN_TRABAJO
SET ManoObra = CAST(ManoObra * 1.10 AS INT)
WHERE YEAR(FechaIngreso) = 2026
AND MONTH(FechaIngreso) = 3
AND IdTaller IN(
	SELECT TOP 1 IdTaller
	FROM ORDEN_TRABAJO
	GROUP BY IdTaller
	ORDER BY COUNT(IdVehiculo) DESC
)

-- EJERCICIO 11
SELECT COUNT(FechaIngreso)CantidadDeOrdenes
FROM ORDEN_TRABAJO
WHERE (DescripcionDiagnostico LIKE '%Falla%' OR DescripcionDiagnostico LIKE '%Pérdida%')
AND YEAR(FechaIngreso) = 2026
AND MONTH(FechaIngreso) = 1
AND IdOrden IN(
	SELECT IdOrden
	FROM ORDEN_REPUESTO
	GROUP BY IdOrden
	HAVING SUM(Cantidad) > 1
)

--EJERCICIO 12
UPDATE ORDEN_TRABAJO
SET ManoObra = ManoObra - 50000
WHERE FechaIngreso > '2026-03-01'
AND ManoObra >= 50000
AND IdVehiculo IN(
	SELECT IdVehiculo
	FROM VEHICULO
	WHERE Anho < 2015
)

-- EJERCICIO 13
UPDATE ORDEN_TRABAJO
SET Estado = 'Completado'
WHERE FechaIngreso BETWEEN '2026-01-1' AND '2026-03-31'
AND IdTaller IN(
	SELECT OT.Idtaller
	FROM ORDEN_TRABAJO OT
		JOIN ORDEN_REPUESTO O ON OT.IdOrden = O.IdOrden
		JOIN REPUESTOS R ON O.IdRepuesto = R.IdRepuesto
		JOIN PROVEEDOR P ON R.IdProveedor = P.IdProveedor
	GROUP BY OT.IdTaller
	HAVING COUNT(DISTINCT P.IdProveedor) = 1
	AND MAX(P.RUC) = '80000001-0'
)



