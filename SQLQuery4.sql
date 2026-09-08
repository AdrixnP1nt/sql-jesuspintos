CREATE DATABASE Proyecto
ON PRIMARY
(
	NAME = Proyecto_Data,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data.mdf',
	SIZE = 20MB,
	MAXSIZE = 50GB, --MAXSIZE = 70MB,
	FILEGROWTH = 10%
),
(
	NAME = Proyecto_Data2,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data2.mdf',
	SIZE = 40MB,
	MAXSIZE = 50GB, --MAXSIZE = 70MB,
	FILEGROWTH = 10%
),
(
	NAME = Proyecto_Data3,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data3.mdf',
	SIZE = 80MB,
	MAXSIZE = 50GB, --MAXSIZE = 70MB,
	FILEGROWTH = 10%
),
FILEGROUP TABLAS
(
	NAME = Proyecto_Data4,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data4.mdf',
	SIZE = 30MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 20%
),
FILEGROUP IMAGES
(
	NAME = Proyecto_Data5,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data5.mdf',
	SIZE = 20MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = Proyecto_Log,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Log.ldf',
	SIZE = 10MB,
	MAXSIZE = 400MB,
	FILEGROWTH = 5%
),
(
	NAME = Proyecto_Log2,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Log2.ldf',
	SIZE = 20MB,
	MAXSIZE = 400MB,
	FILEGROWTH = 5%
);

ALTER DATABASE Proyecto
ADD FILEGROUP INDEXES;


ALTER DATABASE Proyecto
ADD FILE 
(
	NAME = Proyecto_Data6,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data6.mdf',
	SIZE = 30MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 20%
),
(
	NAME = Proyecto_Data7,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data7.mdf',
	SIZE = 30MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 20%
)
TO FILEGROUP INDEXES

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Data6

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Data7

ALTER DATABASE Proyecto
REMOVE FILE Proyecto_Log2

-- Crear una base de datos dominada Proyecto202609 como snapshot de "Proyecto". Los nombres fisicos y ubicaciones de los data files quedan a su criterio

CREATE DATABASE Proyecto2026todo
ON
(
	NAME = Proyecto_Data,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data.ssn'
),
(
	NAME = Proyecto_Data2,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data2.ssn'
),
(
	NAME = Proyecto_Data3,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data3.ssn'
),
(
	NAME = Proyecto_Data4,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data4.ssn'
),
(
	NAME = Proyecto_Data5,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data5.ssn'
),
(
	NAME = Proyecto_Data6,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data3.ssn'
),
(
	NAME = Proyecto_Data7,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data7.ssn'
)
AS SNAPSHOT OF Proyecto;

ALTER DATABASE Proyecto
ADD FILE
(
	NAME = Proyecto_Data4,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data4.mdf',
	SIZE = 30MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 20%
)
TO FILEGROUP TABLAS

ALTER DATABASE Proyecto
ADD FILE
(
	NAME = Proyecto_Data5,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data5.mdf',
	SIZE = 20MB,
	MAXSIZE = 10GB,
	FILEGROWTH = 10%
)
TO FILEGROUP IMAGES


-- Eliminar la base de datos sin destruir los archivos fisicos y reconstruirla, sobre la base de los archivos fisicos restantes, con el nombre de Proyecto_NW
-- reconstruyendo la transaction log.
USE master;
GO
DROP DATABASE Proyecto202609

EXECUTE sp_detach_db 'PersonalesDBI';



CREATE DATABASE Proyecto_NW
ON
(
	NAME = Proyecto_Data,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data.mdf'
),
(
	NAME = Proyecto_Data2,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data2.mdf'
),
(
	NAME = Proyecto_Data3,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data3.mdf'
),
(
	NAME = Proyecto_Data4,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data4.mdf'
),
(
	NAME = Proyecto_Data5,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data5.mdf'
),
(
	NAME = Proyecto_Data6,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data6.mdf'
),
(
	NAME = Proyecto_Data7,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Data7.mdf'
),
(
	NAME = Proyecto_Log,
	FILENAME = 'C:\DBI\DB - PROYECTO\Proyecto_Log.ldf'
)
FOR ATTACH_REBUILD_LOG;