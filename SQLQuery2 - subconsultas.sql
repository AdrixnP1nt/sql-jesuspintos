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
	SELECT FORMAT(FechaIngreso, 'yyyy-MM')AnioMes, 
		   SUM(ManoObra)ManoObra
	FROM ORDEN_TRABAJO
	GROUP BY FORMAT(FechaIngreso, 'yyyy-MM')
) A 
WHERE A.AnioMes = '2026-02';
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

SELECT TOP 5 *
FROM ORDEN_TRABAJO O
WHERE IdOrden IN(SELECT)