DROP DATABASE TP_BBDD1_2025_G30
CREATE DATABASE TP_BBDD1_2025_G30
USE TP_BBDD1_2025_G30
---se agregaron los nombres completos correspondientes a las pk 'id' de las tablas que se utilizan como clave foranea.

CREATE TABLE Motivo_Reclamo(
 id_motivo INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
 nombre nvarchar(150) UNIQUE NOT NULL
)

CREATE TABLE Estado_Salud(
id_salud INT IDENTITY(1,1) PRIMARY KEY not null,
estado varchar(30) UNIQUE,
observaciones nvarchar(255)
)

CREATE TABLE Especie(
id_especie INT IDENTITY(1,1) PRIMARY KEY, --cambio de 'id' a 'id_especie'
nombre_comun nvarchar(100) NOT NULL UNIQUE,
nombre_cientifico nvarchar(150) UNIQUE
)



CREATE TABLE Ubicacion(
id_ubicacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
tipo_ubicacion varchar(30),
nombre nvarchar(150) NOT NULL,
altura_calle INT,
descripcion nvarchar(255),
coordenadas varchar(30)
)

CREATE TABLE Cuadrilla(
id_cuadrilla INT PRIMARY KEY IDENTITY(1,1),
codigo varchar(20) NOT NULL UNIQUE,
nombre nvarchar(100) NOT NULL UNIQUE, --NOT NULL agregado
)

CREATE TABLE Tipo_Tarea(
id_tipo_tarea INT IDENTITY(1,1) PRIMARY KEY not null,--se le agrego 'not null'
nombre varchar(50) NOT NULL,
descripcion nvarchar(255),
)

CREATE TABLE Empleado(
    CUIL varchar(30) PRIMARY KEY NOT NULL, --CUIL como PK.
    id_cuadrilla INT NOT NULL,
    nombre nvarchar(150) NOT NULL,
    telefono varchar(30),
    fecha_ingreso DATE NOT NULL,

    FOREIGN KEY (id_cuadrilla)
        REFERENCES Cuadrilla(id_cuadrilla)
)

CREATE TABLE Tarea(
id_tarea INT IDENTITY(1,1) PRIMARY KEY not null,--Cambie nombre 'id' a 'id_tarea'
id_cuadrilla INT NOT NULL,
id_tipo_tarea INT NOT NULL,
fecha_planificada DATE NOT NULL,
fecha_realizacion DATE,
comentario_final NVARCHAR(MAX),
estado varchar(30),
creada_por nvarchar(150) NOT NULL, --NOT NULL agregado
FOREIGN KEY (id_cuadrilla)
	REFERENCES Cuadrilla(id_cuadrilla),
FOREIGN KEY (id_tipo_tarea)
	REFERENCES Tipo_tarea(id_tipo_tarea)
)

CREATE TABLE Arbol(
id_arbol varchar(50) PRIMARY KEY NOT NULL, ---cambio de codigo_arbol a id, posdata: el codigo lo introducimos nosotros? no seria mejor que aumente solo?
id_especie INT NOT NULL,
id_ubicacion INT NOT NULL,
id_salud INT NOT NULL,
latitud decimal(9,6),
longitud decimal(9,6),
fecha_plantado DATE NULL, --ESTE PUEDE SER NULO.   -- se lo cambi'o a null
FOREIGN KEY (id_especie)
	REFERENCES Especie (id_especie),
FOREIGN KEY (id_ubicacion)
	REFERENCES Ubicacion (id_ubicacion),
FOREIGN KEY (id_salud)
	REFERENCES Estado_Salud(id_salud),
)


CREATE TABLE Reclamo(
id_reclamo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
id_motivo INT NOT NULL,
id_arbol varchar(50) not null, 
fecha_reclamo DATETIME2 NOT NULL,
email_reportante varchar(255) NOT NULL,
descripcion nvarchar(MAX),
fecha_resuelto DATE,
estado varchar(30) NOT NULL,
FOREIGN KEY(id_motivo)
	REFERENCES Motivo_Reclamo(id_motivo),
FOREIGN KEY(id_arbol)
	REFERENCES Arbol(id_arbol)
)

CREATE TABLE Tarea_Arbol(
id_tarea INT NOT NULL,
id_arbol varchar(50) NOT NULL, --- cambio a int
FOREIGN KEY (id_tarea)
	REFERENCES Tarea (id_tarea),
FOREIGN KEY (id_arbol)
	REFERENCES Arbol (id_arbol),
PRIMARY KEY (id_tarea, id_arbol)
)

CREATE TABLE Altura_medicion(
id_altura_medicion INT IDENTITY(1,1) NOT NULL PRIMARY KEY, ---cambio de "id_medicion" a "id_altura_medicion"
id_arbol varchar(50) NOT NULL, --- nuevo, ahora nuevamente es 'id_arbol' int.
altura_m decimal(5,2) NOT NULL,
fecha_medicion DATE NOT NULL,
FOREIGN KEY (id_arbol)
	REFERENCES Arbol(id_arbol),
)

CREATE TABLE Reclamo_Tarea(
id_reclamo INT NOT NULL,
id_tarea INT NOT NULL,
fecha_asignacion DATETIME2 NOT NULL,
FOREIGN KEY (id_reclamo)
	REFERENCES Reclamo(id_reclamo),
FOREIGN KEY (id_tarea)
	REFERENCES Tarea(id_tarea),
PRIMARY KEY(id_reclamo, id_tarea)
)

GO