--SELECT *
--	FROM Cliente;

SELECT Codigo_Cliente AS ID, CI, Nombre_Completo
FROM Cliente;

SELECT Codigo_Cliente AS ID, CI, Nombre_Completo
FROM Cliente
ORDER BY Nombre_Completo ASC; --DESC


SELECT Codigo_Cliente AS ID, CI, Nombre_Completo
FROM Cliente
ORDER BY 2 DESC;

SELECT * FROM Cuenta_Corriente ORDER BY 2 ASC

SELECT Numero_Cuenta AS NroCuenta, Saldo_Actual
	FROM Cuenta_Corriente --Saldo >= 5M
	WHERE Saldo_Actual >= 5000000 
ORDER BY 2 ASC;

SELECT Numero_Cuenta AS NroCuenta, Saldo_Actual
	FROM Cuenta_Corriente --Saldo entre 5M y 7M
	WHERE Saldo_Actual between 5000000 and 7000000
ORDER BY 2 ASC;

SELECT CI,Nombre_Completo,Direccion
 FROM Cliente
 WHERE Direccion LIKE '%San Lorenzo%'

 SELECT *
  FROM Persona_Fisica
  WHERE SEXO = 'F';
--=========================================================================================================
SELECT * FROM Cliente A;
SELECT * FROM Persona_Fisica B;
SELECT * FROM Persona_Juridica C;

SELECT B.Codigo_Cliente, A.Nombre_Completo, B.RUC
 FROM Cliente A 
 INNER JOIN Persona_Fisica B ON A.Codigo_Cliente = B.Codigo_Cliente;

SELECT C.Codigo_Cliente, A.Nombre_Completo, C.Nombre_Representante
 FROM Cliente A 
 INNER JOIN Persona_Juridica C ON A.Codigo_Cliente = C.Codigo_Cliente;

SELECT *  FROM Cliente;
SELECT *  FROM Cuenta_Corriente;
--INNER JOIN
SELECT A.Nombre_Completo, B.Saldo_Actual
	FROM Cliente A
	INNER JOIN Cuenta_Corriente B ON A.Codigo_Cliente = B.Codigo_Cliente
	ORDER BY Saldo_Actual ASC;


--RELACIONES MULTIPLES

SELECT TOP 5 *  FROM Cliente;
SELECT *  FROM Cliente_Cuenta_Ahorro
SELECT *  FROM Cuenta_Ahorro;

SELECT A.Nombre_Completo, C.Saldo_Actual
FROM Cliente A
 JOIN Cliente_Cuenta_Ahorro B ON A.Codigo_Cliente = B.Codigo_Cliente
 JOIN Cuenta_Ahorro C ON B.Numero_Cuenta = C.Numero_Cuenta

--LEFT JOIN
SELECT * FROM Cliente A;
SELECT * FROM Cuenta_Corriente B ORDER BY 3 ASC;



SELECT A.Codigo_Cliente,A.Nombre_Completo, B.Codigo_cliente,B.Saldo_Actual
	FROM Cliente A
	LEFT JOIN Cuenta_Corriente B ON A.Codigo_Cliente = B.Codigo_Cliente
	ORDER BY 3 ASC;

SELECT A.Codigo_Cliente,A.Nombre_Completo
	FROM Cliente A
	LEFT JOIN Cuenta_Corriente B ON A.Codigo_Cliente = B.Codigo_Cliente
	WHERE B.Codigo_Cliente IS NULL

--RIGHT JOIN
SELECT * FROM Cliente A;
SELECT * FROM Cuenta_Corriente B;


SELECT A.Codigo_Cliente,A.Nombre_Completo, B.Codigo_cliente,B.Saldo_Actual
	FROM Cliente A
	RIGHT JOIN Cuenta_Corriente B ON A.Codigo_Cliente = B.Codigo_Cliente
	ORDER BY 3 ASC;


SELECT TOP 5 *  FROM Cliente;
SELECT *  FROM Cliente_Cuenta_Ahorro
SELECT *  FROM Cuenta_Ahorro;

SELECT A.Codigo_Cliente, B.Numero_Cuenta, B.Saldo_Actual
	FROM Cliente_Cuenta_Ahorro A
	RIGHT JOIN Cuenta_Ahorro B ON A.Numero_Cuenta = B.Numero_Cuenta
	WHERE A.Codigo_Cliente IS NULL
	
SELECT * 
 FROM Cuenta_Ahorro
 WHERE Numero_Cuenta = 'CA-8015-L';


-- APDEIT
UPDATE Cuenta_Ahorro
 SET Saldo_Actual =0
 WHERE Numero_Cuenta = 'CA-8015-L';

--DILIT
DELETE FROM Cuenta_Ahorro WHERE Numero_Cuenta = 'CA-8015-L';