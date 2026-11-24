CREATE DATABASE COMERCIAL_JD
ON PRIMARY 

(

	NAME = COMERCIAL_JD_Data,
	FILENAME = 'C:\BDI\COMERCIAL_JD.mdf',
	SIZE = 20MB,
	MAXSIZE = 70MB,
	FILEGROWTH = 10MB

)

LOG ON

(

	NAME = COMERCIAL_JD_Log,
	FILENAME = 'C:\BDI\COMERCIAL_JD.ldf',
	SIZE = 10MB,
	MAXSIZE = 40MB,
	FILEGROWTH = 5MB

);

----------------------------------------------

DROP DATABASE COMERCIAL_JD;
GO

----------------------------------------------

CREATE DATABASE PERSONAL;
DROP DATABASE PERSONAL;
GO

----------------------------------------------