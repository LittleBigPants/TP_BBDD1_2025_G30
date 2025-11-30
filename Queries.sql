
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

