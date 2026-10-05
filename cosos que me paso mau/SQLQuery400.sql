SELECT TOP (1000) [Numero_Cuenta]
				 ,[Saldo_Actual]
				 ,[Codigo_Cliente]
		  	 FROM [SistemaFinanciero]. [dbo]. [Cuenta_Corriente]
----
--SUM
SELECT SUM(Saldo_Actual) AS Saldo_Actual
  FROM Cuenta_Corriente;

  ---SUM por codigo de Cliente
  SELECT * FROM Cuenta_Corriente
	SELECT Codigo_Cliente, SUM(Saldo_Actual) AS Saldo_Actual
  FROM Cuenta_Corriente
  GROUP BY Codigo_Cliente;

  ----Codigo Cliente
  SELECT Codigo_Cliente, SUM(Saldo_Actual) AS Saldo_Actual
  FROM Cuenta_Corriente
  WHERE Codigo_Cliente = 1
  GROUP BY Codigo_Cliente;

  ---MAXIMO SALDO ACTUAL
  SELECT MAX(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente

  ---MINIMO SALDO ACTUAL
    SELECT MIN(Saldo_Actual) MINIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente

  SELECT Codigo_Cliente,MAX(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente
  GROUP BY Codigo_Cliente
  ORDER BY 2 DESC;

  ---
   SELECT Codigo_Cliente,MAX(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente
  WHERE Codigo_Cliente = 1
  GROUP BY Codigo_Cliente
  ORDER BY 2 DESC;

    SELECT Codigo_Cliente,SUM(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente
  WHERE Codigo_Cliente = 1
  GROUP BY Codigo_Cliente
  ORDER BY 2 DESC;
  ----
     SELECT Codigo_Cliente,MAX(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente
  GROUP BY Codigo_Cliente
  ORDER BY 2 ASC;

    SELECT Codigo_Cliente,SUM(Saldo_Actual) MAXIMO_SALDO_ACTUAL
  FROM Cuenta_Corriente
  GROUP BY Codigo_Cliente
  ORDER BY 2 ASC;
  
  ----SUM, MAX, MIN
  SELECT Codigo_Cliente, AVG (Saldo_Actual)PROMEDIO
  FROM Cuenta_Corriente
  GROUP BY Codigo_Cliente

  ----SUM, MAX, MIN, PROMEDIO, COUNT
  SELECT Codigo_Cliente, COUNT (Codigo_Cliente) O_CANT
    FROM Cuenta_Corriente
    GROUP BY Codigo_Cliente;

      SELECT Codigo_Cliente, SUM(Saldo_Actual) Saldo_Actual
    FROM Cuenta_Corriente
    GROUP BY Codigo_Cliente
    HAVING SUM(Saldo_Actual) > '3200000.00'
    ORDER BY 2 ASC; 

    ---
    SELECT cli.Codigo_Cliente, cli.Nombre_Completo as Nombre, SUM(Saldo_Actual) SALDO_ACTUAL
    FROM Cuenta_Corriente cta, Cliente cli
    ---WHERE cta.Codigo_Cliente = cli.Codigo_Cliente
    GROUP BY cli.Codigo_Cliente, cli.Nombre_Completo
    ---HAVING SUM(Saldo_Actual) > '3200000.00'
    ---JOIN Codigo_Cliente.A ON Nombre_Cliente.B = Nombre_Cliente
    ORDER BY 2 ASC;
