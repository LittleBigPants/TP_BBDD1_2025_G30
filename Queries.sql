USE TP_BBDD1_2025_G30
---a. Mostrar la cuadrilla que más tareas realizó en el mes 
---de Octubre 10, y 
--la cantidad de tareas realizadas.

SELECT TOP 1 cu.nombre as nombre, count(ta.id_tarea) AS cantidad_tareas FROM tarea ta
JOIN cuadrilla cu ON cu.id_cuadrilla = ta.id_cuadrilla
WHERE ta.fecha_realizacion >= '2025-10-01' and  ta.fecha_realizacion < '2025-11-01'
GROUP BY nombre
ORDER BY cantidad_tareas DESC

---- Mostrar los Motivos de Reclamos que tengan más de 3 reclamos en estado 
----no asignado (sin tarea). 

SELECT * FROM Motivo_Reclamo 
SELECT * FROM Reclamo
SELECT * FROM Reclamo_Tarea


SELECT mt.nombre AS razon_reclamo, count(r.id_reclamo) AS cant_reclamos FROM Reclamo r
LEFT JOIN Motivo_Reclamo mt
ON mt.id_motivo = r.id_motivo
LEFT JOIN Reclamo_Tarea rt on rt.id_tarea = r.id_reclamo
WHERE rt.id_reclamo is null
GROUP BY mt.nombre
HAVING count(r.id_reclamo) > 3

-----5. Escriba las siguientes vistas. Proporcione dos ejemplos de ejecución usando cada una de ellas: 
----a. Mostrar información de los reclamos. Se desea saber la fecha de cada uno, 
----el código del árbol asociado al reclamo, la cantidad de días que se tardó en 
----asignar la tarea y la cantidad de días que se tardó en resolver el mismo. Si 
----no tiene tarea asignada o no fue resuelto calcular los días hasta la fecha actual. 

SELECT * FROM Reclamo_Tarea
SELECT * FROM Reclamo

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

----b. Resumen de tareas ya realizadas según su tipo. Se desea saber la fecha de 
----la primer y última tarea de cada tipo y la cantidad de tareas realizadas

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
-----dado un árbol en particular y un tipo de tareas. El procedimiento debe devolver:
----a. Como parámetro de salida, la fecha de la próxima tarea del tipo indicado a
----realizarse sobre el árbol, si existiera.SELECT * FROM TareaGO


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
    @mi_fecha AS 'Fecha Próxima Tarea';




--7. Punto Bonus (no obligatorio). Identifique aquellos campos que se utilicen en
--búsquedas o cláusulas WHERE y JOIN en las consultas, vistas o procedimientos de
--los puntos 4, 5 y 6 y proceda a crear al menos cinco índices que permitan mejorar la
--eficiencia de estas consultas, mencionando que consultas y cláusulas (JOIN /
--WHERE) podría mejorar cada uno (podría ser que uno de ellos mejore más de una
--consulta).