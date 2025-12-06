--primero las tablas sin dependencias. .... ........................ 
-- Insertamos 5 Especies (Requisito: 5 especies distintas)
INSERT INTO Especie (nombre_comun, nombre_cientifico) VALUES
('Jacarandá', 'Jacaranda mimosifolia'),
('Lapacho Rosado', 'Handroanthus impetiginosus'),
('Ceibo', 'Erythrina crista-galli'),
('Fresno Americano', 'Fraxinus pennsylvanica'),
('Palo Borracho', 'Ceiba speciosa');
GO

SELECT * FROM especie;

-- Insertamos 10 Ubicaciones (Requisito: 10 ubicaciones distintas)
-- Nota: Dejamos altura_calle en NULL para Parques y Plazas
INSERT INTO Ubicacion (tipo_ubicacion, nombre, altura_calle, descripcion, coordenadas) VALUES
('Parque', 'Parque Independencia', NULL, 'Sector Rosedal', '-32.9558, -60.6601'),
('Plaza', 'Plaza San Martín', NULL, 'Frente a Gobernación', '-32.9461, -60.6439'),
('Vereda', 'Av. Pellegrini', 1500, 'Vereda par', '-32.9530, -60.6500'),
('Vereda', 'Bv. Oroño', 800, 'Cantero central', '-32.9515, -60.6521'),
('Parque', 'Parque Urquiza', NULL, 'Barranca', '-32.9575, -60.6235'),
('Vereda', 'Calle Córdoba', 1100, 'Peatonal', '-32.9476, -60.6378'),
('Plaza', 'Plaza Pringles', NULL, 'Centro', '-32.9479, -60.6390'),
('Vereda', 'Av. Alberdi', 500, 'Zona comercial', '-32.9245, -60.6610'),
('Parque', 'Parque España', NULL, 'Costa del río', '-32.9300, -60.6750'),
('Vereda', 'Calle Mendoza', 3500, 'Barrio Echesortu', '-32.9521, -60.6700');
GO

SELECT * FROM Ubicacion;
GO

-- Insertamos Estados de Salud (Requisito: distintos estados)
INSERT INTO Estado_Salud (estado, observaciones) VALUES
('Sano', 'Sin problemas visibles'),
('Enfermo', 'Presenta hongos o plagas'),
('Seco', 'Ejemplar muerto en pie'),
('Riesgoso', 'Peligro de caída inminente');
GO

SELECT * FROM estado_salud;

-- Insertamos motivos de reclamo. 
INSERT INTO Motivo_Reclamo (nombre) VALUES 
('Rama caída'), 
('Raíces levantando vereda'), 
('Árbol seco'), 
('Obstrucción visual');
GO

SELECT * FROM Motivo_reclamo;
GO

-- Insertamos tipos de tarea.
INSERT INTO Tipo_Tarea (nombre, descripcion) VALUES
('Poda', 'Corte de ramas'), 
('Extracción', 'Retiro del árbol'), 
('Plantado', 'Colocación de nuevo ejemplar');
GO

SELECT * FROM tipo_tarea;

-- 2. REQUISITO A: 3 Cuadrillas y 10 Empleados... .................. 
-- Insertamos las 3 Cuadrillas. 
INSERT INTO Cuadrilla (codigo, nombre) VALUES
('C-NTE', 'Cuadrilla Norte - Los Pinos'),
('C-SUR', 'Cuadrilla Sur - Los Ceibos'),
('C-CEN', 'Cuadrilla Centro - Rápida');
GO

SELECT * FROM cuadrilla;
GO

-- a. 2.  Insertamos 10 Empleados distribuidos en las cuadrillas
-- Nota: La PK es el CUIL (varchar)
INSERT INTO Empleado (CUIL, id_cuadrilla, nombre, telefono, fecha_ingreso) VALUES
('20-11111111-1', 1, 'Juan Perez', '341-111111', '2020-01-15'),
('27-22222222-2', 1, 'Maria Gomez', '341-222222', '2021-03-20'),
('20-33333333-3', 1, 'Carlos Lopez', '341-333333', '2022-05-10'),
('27-44444444-4', 2, 'Ana Diaz', '341-444444', '2019-11-01'),
('20-55555555-5', 2, 'Pedro Sanchez', '341-555555', '2020-08-15'),
('27-66666666-6', 2, 'Laura Martinez', '341-666666', '2023-02-28'),
('20-77777777-7', 3, 'Miguel Torres', '341-777777', '2018-06-05'),
('27-88888888-8', 3, 'Sofia Ruiz', '341-888888', '2021-09-12'),
('20-99999999-9', 3, 'Diego Castro', '341-999999', '2022-12-01'),
('23-10101010-9', 3, 'Elena Blanco', '341-000000', '2023-07-20');
GO

SELECT * FROM empleado;
GO

-- 3. REQUISITO B: 50 Árboles con códigos alfanuméricos
-- Estrategia para cumplir las condiciones:
-- Distintos estados de salud: Usamos id_salud 1, 2, 3, 4. 
-- Con y sin fecha de plantado: Usamos NULL en algunos. 
-- 5 especies y 10 ubicaciones mezcladas. 

-- Insertamos los 50 Árboles (ARB001 al ARB050)
INSERT INTO Arbol (id_arbol, id_especie, id_ubicacion, id_salud, latitud, longitud, fecha_plantado) VALUES
-- Lote 1: Sanos, con fecha (10 árboles)
('ARB001', 1, 1, 1, -32.95, -60.66, '2015-05-20'), 
('ARB002', 2, 2, 1, -32.94, -60.64, '2018-08-15'),
('ARB003', 3, 3, 1, -32.95, -60.65, '2020-09-10'), 
('ARB004', 4, 4, 1, -32.95, -60.65, '2010-03-25'),
('ARB005', 5, 5, 1, -32.95, -60.62, '2012-11-30'), 
('ARB006', 1, 6, 1, -32.94, -60.63, '2019-07-04'),
('ARB007', 2, 7, 1, -32.94, -60.63, '2021-01-20'), 
('ARB008', 3, 8, 1, -32.92, -60.66, '2016-10-12'),
('ARB009', 4, 9, 1, -32.93, -60.67, '2014-02-28'), 
('ARB010', 5, 10, 1, -32.95, -60.67, '2017-06-15'),

-- Lote 2: Enfermos o Débiles, con fecha (10 árboles)
('ARB011', 1, 2, 2, -32.94, -60.64, '2015-05-21'), 
('ARB012', 2, 3, 2, -32.95, -60.65, '2018-08-16'),
('ARB013', 3, 4, 2, -32.95, -60.65, '2020-09-11'), 
('ARB014', 4, 5, 2, -32.95, -60.62, '2010-03-26'),
('ARB015', 5, 6, 2, -32.94, -60.63, '2012-12-01'), 
('ARB016', 1, 7, 2, -32.94, -60.63, '2019-07-05'),
('ARB017', 2, 8, 2, -32.92, -60.66, '2021-01-21'), 
('ARB018', 3, 9, 2, -32.93, -60.67, '2016-10-13'),
('ARB019', 4, 10, 2, -32.95, -60.67, '2014-03-01'), 
('ARB020', 5, 1, 2, -32.95, -60.66, '2017-06-16'),

-- Lote 3: SIN fecha de plantado (NULL) (10 árboles).  Cumple "Con y sin fecha"
('ARB021', 1, 3, 1, -32.95, -60.65, NULL),
('ARB022', 2, 4, 1, -32.95, -60.65, NULL),
('ARB023', 3, 5, 1, -32.95, -60.62, NULL), 
('ARB024', 4, 6, 1, -32.94, -60.63, NULL),
('ARB025', 5, 7, 1, -32.94, -60.63, NULL), 
('ARB026', 1, 8, 3, -32.92, -60.66, NULL), -- Estado 3: Seco
('ARB027', 2, 9, 3, -32.93, -60.67, NULL), 
('ARB028', 3, 10, 3, -32.95, -60.67, NULL),
('ARB029', 4, 1, 3, -32.95, -60.66, NULL), 
('ARB030', 5, 2, 3, -32.94, -60.64, NULL),

-- Lote 4: Mezclamos árboles null y no null (20 árboles más)
('ARB031', 1, 9, 1, -32.93, -60.67, '2022-01-01'), 
('ARB032', 2, 10, 1, -32.95, -60.67, '2023-01-01'),
('ARB033', 3, 1, 2, -32.95, -60.66, '2005-01-01'), 
('ARB034', 4, 2, 2, -32.94, -60.64, NULL),
('ARB035', 5, 3, 3, -32.95, -60.65, NULL), 
('ARB036', 1, 5, 1, -32.95, -60.62, '2011-11-11'),
('ARB037', 2, 6, 1, -32.94, -60.63, '2008-08-08'), 
('ARB038', 3, 7, 2, -32.94, -60.63, NULL),
('ARB039', 4, 8, 4, -32.92, -60.66, '1999-09-09'), 
('ARB040', 5, 9, 1, -32.93, -60.67, '2001-01-01'),
('ARB041', 1, 10, 2, -32.95, -60.67, NULL), 
('ARB042', 2, 1, 3, -32.95, -60.66, NULL),
('ARB043', 3, 2, 1, -32.94, -60.64, '2020-02-20'), 
('ARB044', 4, 3, 1, -32.95, -60.65, '2021-03-30'),
('ARB045', 5, 4, 1, -32.95, -60.65, '2019-12-25'),
('ARB046', 1, 1, 1, -32.9559, -60.6602, '2024-03-01'),
('ARB047', 2, 2, 2, -32.9462, -60.6440, '2023-05-15'),
('ARB048', 3, 3, 1, -32.9531, -60.6501, NULL),
('ARB049', 4, 4, 3, -32.9516, -60.6522, '2010-09-21'),
('ARB050', 5, 5, 1, -32.9576, -60.6236, '2022-11-11');
GO

SELECT * FROM Arbol;
GO

-- INSERTAMOS LAS TAREAS
INSERT INTO Tarea (id_cuadrilla, id_tipo_tarea, fecha_planificada, fecha_realizacion, estado, creada_por, comentario_final)
VALUES
--- AGOSTO (tareas pasadas y finalizadas) 
(1, 1, '2025-08-01', '2025-08-01', 'Finalizada', 'Supervisor A', 'Poda exitosa de ramas bajas'),
(2, 1, '2025-08-05', '2025-08-05', 'Finalizada', 'Supervisor B', 'Despeje de luminaria completado'),
(3, 2, '2025-08-10', '2025-08-11', 'Finalizada', 'Supervisor C', 'Extracción de ejemplar seco'),
(1, 3, '2025-08-15', '2025-08-15', 'Finalizada', 'Supervisor A', 'Plantado de nuevo ejemplar'),
(2, 1, '2025-08-20', '2025-08-20', 'Finalizada', 'Supervisor B', 'Poda correctiva'),

-- SEPTIEMBRE (tareas recientes)
(3, 2, '2025-09-02', '2025-09-02', 'Finalizada', 'Supervisor C', 'Retiro de árbol caído por tormenta'),
(1, 1, '2025-09-05', '2025-09-06', 'Finalizada', 'Supervisor A', 'Poda en altura'),
(2, 3, '2025-09-12', '2025-09-12', 'Finalizada', 'Supervisor B', 'Reposición de árbol vandalizado'),
(3, 1, '2025-09-18', '2025-09-18', 'Finalizada', 'Supervisor C', 'Limpieza de raíces'),
(1, 2, '2025-09-25', '2025-09-26', 'Finalizada', 'Supervisor A', NULL),

--- OCTUBRE (tareas actuales)
(2, 1, '2025-10-01', '2025-10-01', 'En Proceso', 'Supervisor B', NULL),
(3, 1, '2025-10-05', '2025-10-10', 'Asignada', 'Supervisor C', NULL),
(1, 3, '2025-10-10', '2025-10-20', 'Asignada', 'Supervisor A', NULL),
(2, 2, '2025-10-15', '2025-10-20', 'Pendiente', 'Supervisor B', NULL),
(3, 1, '2025-10-20', NULL, 'Pendiente', 'Supervisor C', NULL),
(2, 2, '2025-10-12', '2025-10-20', 'Pendiente', 'Supervisor B', NULL),

-- NOVIEMBRE (tareas futuras / planificadas)
(1, 1, '2025-11-01', NULL, 'Planificada', 'Director', NULL),
(2, 3, '2025-11-05', NULL, 'Planificada', 'Director', NULL),
(3, 1, '2025-11-10', NULL, 'Planificada', 'Director', NULL),
(1, 2, '2025-11-15', NULL, 'Planificada', 'Director', NULL),
(2, 1, '2025-11-20', NULL, 'Planificada', 'Director', NULL);
GO

SELECT * FROM tarea;
GO

-- INSERTAMOS Tarea_Arbol con códigos alfanuméricos
INSERT INTO Tarea_Arbol (id_tarea, id_arbol) VALUES
(1, 'ARB001'), (2, 'ARB002'),
(3, 'ARB005'), (4, 'ARB010'),
(5, 'ARB011'), (5, 'ARB012'), 
(5, 'ARB013'), 
(6, 'ARB015'), (7, 'ARB020'), 
(8, 'ARB025'), (9, 'ARB030'),
(10, 'ARB031'), (10, 'ARB032'),
(11, 'ARB035'), (12, 'ARB040'), 
(13, 'ARB041'), (14, 'ARB042'), 
(14, 'ARB043'), (15, 'ARB045'),
(16, 'ARB046'), (17, 'ARB047'), 
(18, 'ARB048'), (19, 'ARB049'), 
(20, 'ARB050');
GO

SELECT * FROM tarea_arbol;
GO

-- INSERTAMOS Reclamos con códigos alfanuméricos
INSERT INTO Reclamo (id_motivo, id_arbol, fecha_reclamo, email_reportante, descripcion, fecha_resuelto, estado)
VALUES
-- LOTE 1: RESUELTOS (IDs 1 al 8) 
(1, 'ARB001', '2025-07-28 10:00:00', 'vecino1@mail.com', 'Rama grande colgando', '2025-08-01', 'Resuelto'),
(4, 'ARB002', '2025-08-02 14:30:00', 'vecino2@mail.com', 'Tapa la luz', '2025-08-05', 'Resuelto'),
(3, 'ARB005', '2025-08-08 09:15:00', 'vecino3@mail.com', 'Arbol seco', '2025-08-11', 'Resuelto'),
(2, 'ARB011', '2025-08-18 16:20:00', 'comercio@mail.com', 'Levantó baldosas', '2025-08-20', 'Resuelto'),
(2, 'ARB015', '2025-08-30 11:00:00', 'vecino4@mail.com', 'Ramas techo', '2025-09-02', 'Resuelto'),
(3, 'ARB020', '2025-09-10 08:45:00', 'vecino5@mail.com', 'Vandalizado', '2025-09-12', 'Resuelto'),
(2, 'ARB025', '2025-09-15 12:30:00', 'escuela@mail.com', 'Ramas bajas', '2025-09-18', 'Resuelto'),
(2, 'ARB030', '2025-09-20 15:10:00', 'vecino6@mail.com', 'Raíces cañería', '2025-09-26', 'Resuelto'),

-- LOTE 2: ASIGNADOS (IDs 9 al 14)
(2, 'ARB035', '2025-09-28 09:00:00', 'vecino7@mail.com', 'Rama caer', NULL, 'En Proceso'),
(4, 'ARB040', '2025-10-02 18:00:00', 'vecino8@mail.com', 'Muy oscuro', NULL, 'Asignado'),
(3, 'ARB041', '2025-10-08 10:30:00', 'club@mail.com', 'Extracción', NULL, 'Asignado'),
(2, 'ARB042', '2025-10-12 14:00:00', 'vecino9@mail.com', 'Vereda rota', NULL, 'En Proceso'),
(1, 'ARB045', '2025-10-18 11:45:00', 'admin@consorcio.com', 'Ramas ventanas', NULL, 'Asignado'),
(4, 'ARB031', '2025-10-19 13:20:00', 'vecino10@mail.com', 'Tapa semáforo', NULL, 'Asignado'),

-- LOTE 3: PENDIENTES (IDs 15 al 20) 
(2, 'ARB010', '2025-11-01 08:00:00', 'vecino11@mail.com', 'Rama tormenta', NULL, 'Pendiente'),
(3, 'ARB012', '2025-11-02 09:30:00', 'vecino12@mail.com', 'Plaga', NULL, 'Pendiente'),
(2, 'ARB013', '2025-11-05 17:00:00', 'vecino13@mail.com', 'Raíces cochera', NULL, 'Pendiente'),
(4, 'ARB014', '2025-11-10 10:15:00', 'vecino14@mail.com', 'Poda despeje', NULL, 'Pendiente'),
(1, 'ARB049', '2025-11-12 15:40:00', 'vecino15@mail.com', 'Rama quebrada', NULL, 'Pendiente'),
(2, 'ARB048', '2025-11-14 12:00:00', 'kiosco@mail.com', 'Baldosas flojas', NULL, 'Pendiente');
GO

SELECT * FROM reclamo;
GO

---Altura_medicion

INSERT INTO Altura_medicion (id_arbol, altura_m, fecha_medicion) VALUES
('ARB001', 12.50, '2025-01-10'), 
('ARB003', 8.20, '2025-02-15'),
('ARB005', 15.00, '2025-03-01'), 
('ARB010', 9.80, '2025-04-22'), 
('ARB015', 7.10, '2025-05-05'), 
('ARB020', 11.30, '2025-06-18'),
('ARB025', 10.50, '2025-07-25'),
('ARB031', 6.90, '2025-08-01'),
('ARB035', 13.70, '2025-09-11'),
('ARB040', 8.50, '2025-10-03'),
('ARB002', 9.10, '2024-11-01'),
('ARB002', 9.50, '2025-11-01'), 
('ARB011', 5.50, '2024-10-01'),
('ARB011', 5.75, '2025-10-01'),
('ARB022', 14.00, '2025-01-20'),
('ARB022', 14.15, '2025-09-20'),
('ARB033', 10.00, '2024-05-15'),
('ARB033', 10.30, '2025-05-15'),
('ARB045', 6.20, '2025-03-05'),
('ARB045', 6.50, '2025-08-05');
GO

SELECT * FROM Altura_medicion;

-- 4. INSERTAR VINCULACIONES en Reclamo_Tarea
INSERT INTO Reclamo_Tarea (id_reclamo, id_tarea, fecha_asignacion) VALUES
(1, 1, '2025-07-30 08:00:00'),
(2, 2, '2025-08-03 08:00:00'),
(3, 3, '2025-08-09 08:00:00'),
(4, 5, '2025-08-19 08:00:00'),
(5, 6, '2025-09-01 08:00:00'),
(6, 7, '2025-09-11 08:00:00'),
(7, 8, '2025-09-16 08:00:00'),
(8, 9, '2025-09-22 08:00:00'),
(9, 10, '2025-09-30 08:00:00'),
(10, 11, '2025-10-04 08:00:00'),
(11, 12, '2025-10-09 08:00:00'),
(12, 13, '2025-10-14 08:00:00'),
(13, 14, '2025-10-19 08:00:00'),
(14, 15, '2025-10-20 08:00:00');
GO