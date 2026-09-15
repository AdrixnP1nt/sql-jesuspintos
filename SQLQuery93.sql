CREATE DATABASE Proyecto
ON PRIMARY
(
	NAME = Proyecto_Data_1,
	FILENAME = 'C:\DBI\Proyecto_Data_1.mdf',
	SIZE = 20MB,
	MAXSIZE = unlimited, --MAXSIZE = 70MB,
	FILEGROWTH = 10%
),
(
	NAME = Proyecto_Data_2,
	FILENAME = 'C:\DBI\Proyecto_Data_2.mdf',
	SIZE = 20MB,
	MAXSIZE = 70MB,
	FILEGROWTH = 10%
),
(
	NAME = Proyecto_Data_3,
	FILENAME = 'C:\DBI\Proyecto_Data_3.mdf',
	SIZE = 30MB,
	MAXSIZE = 60MB,
	FILEGROWTH = 20%
),
FILEGROUP TABLES
(
	NAME = Proyecto_Data_4,
	FILENAME = 'C:\DBI\Proyecto_Data_4.mdf',
	SIZE = 30MB,
	MAXSIZE = unlimited,
	FILEGROWTH = 20%
),
FILEGROUP IMAGENES
(
	NAME = Proyecto_Data_5,
	FILENAME = 'C:\DBI\Proyecto_Data_5.mdf',
	SIZE = 30MB,
	MAXSIZE = unlimited,
	FILEGROWTH = 20%
)
LOG ON
(
	NAME = Proyecto_Log_1,
	FILENAME = 'C:\DBI\Proyecto_Log_1.ldf',
	SIZE = 10MB,
	MAXSIZE = 40MB,
	FILEGROWTH = 5MB
),
(
	NAME = Proyecto_Log_2,
	FILENAME = 'C:\DBI\Proyecto_Log_2.ldf',
	SIZE = 10MB,
	MAXSIZE = 40MB,
	FILEGROWTH = 5MB
)

ALTER DATABASE Proyecto
ADD FILEGROUP INDEXES;

ALTER DATABASE Proyecto
ADD FILE 
(
	NAME = Proyecto_Data_6,
	FILENAME = 'C:\DBI\Proyecto_Data_6.mdf',
	SIZE = 30MB,
	MAXSIZE = unlimited,
	FILEGROWTH = 20%
),
(
	NAME = Proyecto_Data_7,
	FILENAME = 'C:\DBI\Proyecto_Data_7.mdf',
	SIZE = 30MB,
	MAXSIZE = unlimited,
	FILEGROWTH = 20%
)
TO FILEGROUP INDEXES;

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Log_2;

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Data_5;

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Data_4;

-- CREAR UNA BASE DE DATOS DENOMINADA PROYECTO202609 COMO SNAPSHOT DE PROYECTO. LOS NOMBRES FISICOS Y UBICACIONES DE LA DATA FILE QUEDAN SU CRITERIO

CREATE DATABASE Proyecto202609
ON 
(
	NAME = Proyecto_Data_1,
	FILENAME = 'C:\DBI\Proyecto_Data_1.ssn'

),
(
	NAME = Proyecto_Data_2,
	FILENAME = 'C:\DBI\Proyecto_Data_2.ssn'

),
(
	NAME = Proyecto_Data_3,
	FILENAME = 'C:\DBI\Proyecto_Data_3.ssn'
)

AS SNAPSHOT OF Proyecto;
 --SNAPSHOT Proyecto202609

 --4. Eliminar la base de datos sin destruir sus archivos fiscos y reconstruirla. sobre la base de los archivos 
DROP DATABASE Proyecto202609;
EXECUTE sp_detach_db 'Proyecto';

CREATE DATABASE PROYECTO_NEW
ON 
(
	NAME = Proyecto_Data_1,
	FILENAME = 'C:\DBI\Proyecto_Data_1.mdf'

),
(
	NAME = Proyecto_Data_2,
	FILENAME = 'C:\DBI\Proyecto_Data_2.mdf'

),
(
	NAME = Proyecto_Log_1,
	FILENAME = 'C:\DBI\Proyecto_Log_1.ldf'
)
FOR ATTACH_REBUILD_LOG

CREATE TYPE ProyectadaID