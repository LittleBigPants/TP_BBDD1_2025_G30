USE TP_BBDD1_2025_G30
---a. Mostrar la cuadrilla que m�s tareas realiz� en el mes 
---de Octubre 10, y 
--la cantidad de tareas realizadas.

SELECT TOP 1 cu.nombre as nombre, count(ta.id_tarea) AS cantidad_tareas FROM tarea ta
JOIN cuadrilla cu ON cu.id_cuadrilla = ta.id_cuadrilla
WHERE ta.fecha_realizacion >= '2025-10-01' and  ta.fecha_realizacion < '2025-11-01'
GROUP BY nombre
ORDER BY cantidad_tareas DESC

---- b Mostrar los Motivos de Reclamos que tengan m�s de 3 reclamos en estado 
----no asignado (sin tarea). 

SELECT mt.nombre AS razon_reclamo, count(r.id_reclamo) AS cant_reclamos FROM Reclamo r
LEFT JOIN Motivo_Reclamo mt
ON mt.id_motivo = r.id_motivo
LEFT JOIN Reclamo_Tarea rt on rt.id_tarea = r.id_reclamo
WHERE rt.id_reclamo is null
GROUP BY mt.nombre
HAVING count(r.id_reclamo) > 3

--- c Mostrar los �rboles (c�digo, especie y ubicaci�n) que no tengan ning�n 
--- reclamo.
SELECT A.id_arbol AS Codigo_Arbol, Es.nombre_comun AS Especie, U.nombre AS Ubicacion
FROM Arbol A
INNER JOIN Especie Es ON A.id_especie = Es.id_especie
INNER JOIN Ubicacion U ON A.id_ubicacion = U.id_ubicacion
LEFT JOIN Reclamo R ON A.id_arbol = R.id_arbol
WHERE R.id_reclamo IS NULL;

----- d. Mostrar los tres �rboles (c�digo y altura) m�s altos de cada especie. Mostrar 
--los resultados ordenados por especie y luego altura decreciente. 

WITH Arboles_Clasificados AS (
    SELECT
        E.nombre_comun AS Nombre_especie,
        A.id_arbol AS Codigo_arbol,
        AM.altura_m AS Altura,
        ROW_NUMBER() OVER (
            PARTITION BY E.id_especie
            ORDER BY AM.altura_m DESC, E.nombre_comun ASC 
        ) AS RangoAltura
    FROM
        Especie E
    INNER JOIN
        Arbol A ON E.id_especie = A.id_especie
    INNER JOIN
        Altura_medicion AM ON A.id_arbol = AM.id_arbol
    WHERE
        AM.id_altura_medicion = (
            SELECT TOP 1 id_altura_medicion
            FROM Altura_medicion
            WHERE id_arbol = A.id_arbol
            ORDER BY fecha_medicion DESC, id_altura_medicion DESC
        )
)
SELECT
    Nombre_especie,
    Codigo_arbol,
    Altura
FROM
    Arboles_Clasificados
WHERE
    RangoAltura <= 3
ORDER BY
    Nombre_especie ASC,
    Altura DESC;      

-----5. Escriba las siguientes vistas. Proporcione dos ejemplos de ejecuci�n usando cada una de ellas: 

----a. Mostrar informaci�n de los reclamos. Se desea saber la fecha de cada uno, 
----el c�digo del �rbol asociado al reclamo, la cantidad de d�as que se tard� en 
----asignar la tarea y la cantidad de d�as que se tard� en resolver el mismo. Si 
----no tiene tarea asignada o no fue resuelto calcular los d�as hasta la fecha actual. 

DROP VIEW info_reclamos
GO

CREATE VIEW	info_reclamos AS
SELECT r.fecha_reclamo, r.id_arbol, DATEDIFF(day, r.fecha_reclamo, isnull(rt.fecha_asignacion, GETDATE())) as Dias_antes_asignar,
DATEDIFF(day, rt.fecha_asignacion, isnull(r.fecha_resuelto, GETDATE())) as Dias_para_resolver
FROM Reclamo r
LEFT JOIN Reclamo_Tarea rt ON r.id_reclamo = rt.id_reclamo
GO

SELECT * FROM info_reclamos;
GO

----b. Resumen de tareas ya realizadas seg�n su tipo. Se desea saber la fecha de 
----la primer y �ltima tarea de cada tipo y la cantidad de tareas realizadas

SELECT * FROM Tarea
GO
SELECT * FROM Tipo_Tarea
GO
DROP VIEW resumen_tareas
GO
CREATE VIEW resumen_tareas AS
SELECT tt.nombre AS tipo_tarea, COUNT(tt.nombre) AS cantidad, MIN(t.fecha_realizacion) AS primera_tarea, MAX(t.fecha_realizacion) AS ultima_tarea
FROM Tarea t
JOIN Tipo_Tarea tt ON t.id_tipo_tarea = tt.id_tipo_tarea
WHERE t.estado = 'Finalizada'
GROUP BY tt.nombre
GO
SELECT * FROM resumen_tareas;
GO



-----6. Escriba un procedimiento almacenado para identificar si existen tareas no realizadas
-----dado un �rbol en particular y un tipo de tareas. El procedimiento debe devolver:

----a. Como par�metro de salida, la fecha de la pr�xima tarea del tipo indicado a
----realizarse sobre el �rbol, si existiera.

SELECT * FROM Tarea
GO



DROP PROCEDURE verificar_tareas;
GO

CREATE PROCEDURE verificar_tareas
	@arbol_id VARCHAR(50),
	@tipo_tarea_id INT,
	@proxima_tarea DATE OUTPUT
AS
BEGIN
	DECLARE @cant_tareas_pendientes INT;

	SElECT @cant_tareas_pendientes = COUNT(*)
	FROM Tarea t
	JOIN Tarea_Arbol ta ON ta.id_tarea = t.id_tarea
	WHERE t.estado = 'Pendiente' AND  ta.id_arbol = @arbol_id AND t.id_tipo_tarea = @tipo_tarea_id
	SELECT TOP 1 @proxima_tarea = t.fecha_planificada
	FROM Tarea t
	JOIN Tarea_Arbol ta ON ta.id_tarea = t.id_tarea
	WHERE t.estado = 'Pendiente' AND  ta.id_arbol = @arbol_id AND t.id_tipo_tarea = @tipo_tarea_id
	ORDER BY t.fecha_planificada ASC
	RETURN @cant_tareas_pendientes
END
GO


SELECT * FROM Tarea_Arbol
GO


DECLARE @mi_fecha DATE;
DECLARE @mi_cantidad INT;

EXEC @mi_cantidad = verificar_tareas 
    @arbol_id = 'ARB042',   
    @tipo_tarea_id = 2,
    @proxima_tarea = @mi_fecha OUTPUT;
SELECT 
    @mi_cantidad AS 'Tareas Pendientes',
    @mi_fecha AS 'Fecha Pr�xima Tarea';


DECLARE @mi_fecha2 DATE;
DECLARE @mi_cantidad2 INT;

EXEC @mi_cantidad2 = verificar_tareas 
    @arbol_id = 'ARB001',   
    @tipo_tarea_id = 1,
    @proxima_tarea = @mi_fecha2 OUTPUT;

SELECT 
    @mi_cantidad2 AS 'Tareas Pendientes',
    @mi_fecha2 AS 'Fecha Pr�xima Tarea';



--7. Punto Bonus (no obligatorio). Identifique aquellos campos que se utilicen en
--b�squedas o cl�usulas WHERE y JOIN en las consultas, vistas o procedimientos de
--los puntos 4, 5 y 6 y proceda a crear al menos cinco �ndices que permitan mejorar la
--eficiencia de estas consultas, mencionando que consultas y cl�usulas (JOIN /
--WHERE) podr�a mejorar cada uno (podr�a ser que uno de ellos mejore m�s de una
--consulta).

CREATE NONCLUSTERED INDEX Index_Tarea_Fecha_realizacion
ON Tarea(fecha_realizacion)
INCLUDE (id_cuadrilla, estado);
-- Ordena por: fecha_realizacion


CREATE NONCLUSTERED INDEX Idex_ReclamoTarea_IdReclamo
ON Reclamo_Tarea(id_reclamo)
INCLUDE (id_tarea, fecha_asignacion);
GO
-- Ordena por: id_reclamo menor a mayor

CREATE NONCLUSTERED INDEX Index_Tarea_Estado
ON Tarea(estado)
INCLUDE (id_tipo_tarea, fecha_realizacion, fecha_planificada);
GO
-- Ordena por: estado, alfabeticamente

CREATE NONCLUSTERED INDEX Index_Tarea_Arbol_Id_Arbol
ON Tarea_Arbol(id_arbol)
INCLUDE (id_tarea);
GO
-- Ordena por: id_arbol alfabeticamente

CREATE NONCLUSTERED INDEX Index_Tarea_Estado_Tipo_Fecha
ON Tarea(estado, id_tipo_tarea, fecha_planificada)
INCLUDE (id_tarea);
GO
-- Ordena por: estado, despues por id_tipo_tarea y por ultimo por fecha_planificada