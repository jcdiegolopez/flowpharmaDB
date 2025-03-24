-- INSERTs para todas las tablas (mínimo 10 por tabla)

-- 1. Departamento
INSERT INTO Departamento (nombre) VALUES
('Ventas'),
('Marketing'),
('Finanzas'),
('Recursos Humanos'),
('IT'),
('Operaciones'),
('Legal'),
('Compras'),
('Calidad'),
('Investigación y Desarrollo');

-- 2. Rol
INSERT INTO Rol (nombre) VALUES
('Administrador'),
('Gerente'),
('Supervisor'),
('Empleado'),
('Analista'),
('Técnico'),
('Consultor'),
('Auditor'),
('Coordinador'),
('Director');

-- 3. Inputs
INSERT INTO Inputs (tipo_input) VALUES
('textocorto'),
('textolargo'),
('combobox'),
('multiplecheckbox'),
('date'),
('number'),
('archivo'),
('textocorto'),
('textolargo'),
('combobox');

-- 4. GrupoAprobacion
INSERT INTO GrupoAprobacion (nombre, fecha, es_global) VALUES
('Grupo A', '2023-01-01', TRUE),
('Grupo B', '2023-02-01', FALSE),
('Grupo C', '2023-03-01', TRUE),
('Grupo D', '2023-04-01', FALSE),
('Grupo E', '2023-05-01', TRUE),
('Grupo F', '2023-06-01', FALSE),
('Grupo G', '2023-07-01', TRUE),
('Grupo H', '2023-08-01', FALSE),
('Grupo I', '2023-09-01', TRUE),
('Grupo J', '2023-10-01', FALSE);

-- 5. Usuario (depende de Departamento y Rol)
INSERT INTO Usuario (nombre, email, departamento_id, rol_id) VALUES
('Juan Perez', 'juan.perez@example.com', 1, 1),
('Maria Gomez', 'maria.gomez@example.com', 2, 2),
('Carlos Sanchez', 'carlos.sanchez@example.com', 3, 3),
('Ana Martinez', 'ana.martinez@example.com', 4, 4),
('Luis Rodriguez', 'luis.rodriguez@example.com', 5, 5),
('Elena Fernandez', 'elena.fernandez@example.com', 6, 6),
('Pedro Ramirez', 'pedro.ramirez@example.com', 7, 7),
('Sofia Torres', 'sofia.torres@example.com', 8, 8),
('Miguel Angel', 'miguel.angel@example.com', 9, 9),
('Laura Rivera', 'laura.rivera@example.com', 10, 10);

-- 6. FlujoAprobacion (depende de Usuario)
INSERT INTO FlujoAprobacion (nombre, descripcion, version_actual, es_plantilla, creado_por) VALUES
('Flujo 1', 'Flujo de aprobación de ventas', 1, TRUE, 1),
('Flujo 2', 'Flujo de revisión de marketing', 1, FALSE, 2),
('Flujo 3', 'Flujo financiero', 1, TRUE, 3),
('Flujo 4', 'Flujo de RRHH', 1, FALSE, 4),
('Flujo 5', 'Flujo de TI', 1, TRUE, 5),
('Flujo 6', 'Flujo de operaciones', 1, FALSE, 6),
('Flujo 7', 'Flujo legal', 1, TRUE, 7),
('Flujo 8', 'Flujo de compras', 1, FALSE, 8),
('Flujo 9', 'Flujo de calidad', 1, TRUE, 9),
('Flujo 10', 'Flujo de I+D', 1, FALSE, 10);

-- 7. PasoFlujo (depende de FlujoAprobacion)
INSERT INTO PasoFlujo (flujo_id, nombre, tipo_flujo, tipo_paso, regla_aprobacion) VALUES
(1, 'Revisión inicial', 'normal', 'ejecucion', 'individual'),
(1, 'Aprobación gerente', 'bifurcacion', 'aprobacion', 'unanime'),
(1, 'Consolidación', 'union', 'ejecucion', 'individual'),
(1, 'Revisión final', 'normal', 'aprobacion', 'ancla'),
(1, 'Preparación', 'bifurcacion', 'ejecucion', 'individual'),
(1, 'Validación', 'union', 'aprobacion', 'unanime'),
(1, 'Ejecución', 'normal', 'ejecucion', 'individual'),
(1, 'Aprobación técnica', 'bifurcacion', 'aprobacion', 'ancla'),
(1, 'Cierre', 'union', 'ejecucion', 'individual'),
(1, 'Confirmación', 'normal', 'aprobacion', 'unanime');

-- 8. CaminoParalelo (depende de PasoFlujo)
INSERT INTO CaminoParalelo (paso_origen_id, paso_destino_id, es_excepcion) VALUES
(1, 2, FALSE),
(2, 3, FALSE),
(3, 4, FALSE),
(4, 5, FALSE),
(5, 6, FALSE),
(6, 7, FALSE),
(7, 8, FALSE),
(8, 9, FALSE),
(9, 10, FALSE),
(2, 4, TRUE); -- Camino de excepción

-- 9. Solicitud (depende de FlujoAprobacion y Usuario)
INSERT INTO Solicitud (flujo_base_id, solicitante_id, estado) VALUES
(1, 1, 'aprobado'),
(1, 2, 'rechazado'),
(1, 3, 'aprobado'),
(1, 4, 'rechazado'),
(1, 5, 'aprobado'),
(1, 6, 'rechazado'),
(1, 7, 'aprobado'),
(1, 8, 'rechazado'),
(1, 9, 'aprobado'),
(1, 10, 'rechazado');

-- 10. FlujoActivo (depende de Solicitud y FlujoAprobacion)
INSERT INTO FlujoActivo (solicitud_id, flujo_ejecucion_id, estado, fecha_finalizacion) VALUES
(1, 1, 'encurso', NULL),
(2, 1, 'finalizado', '2023-02-01'),
(3, 1, 'cancelado', NULL),
(4, 1, 'encurso', NULL),
(5, 1, 'finalizado', '2023-05-01'),
(6, 1, 'cancelado', NULL),
(7, 1, 'encurso', NULL),
(8, 1, 'finalizado', '2023-08-01'),
(9, 1, 'cancelado', NULL),
(10, 1, 'encurso', NULL);

-- 11. RelacionVisualizador (depende de FlujoActivo y Usuario)
INSERT INTO RelacionVisualizador (flujo_activo_id, usuario_id) VALUES
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(2, 1);

-- 12. PasoSolicitud (depende de FlujoActivo, PasoFlujo, CaminoParalelo y Usuario)
INSERT INTO PasoSolicitud (flujo_activo_id, paso_id, camino_id, responsable_id, tipo_paso, estado, nombre, tipo_flujo, regla_aprobacion, fecha_fin) VALUES
(1, 1, 1, 1, 'ejecucion', 'aprobado', 'Paso Solicitud 1', 'normal', 'individual', '2023-01-02'),
(1, 2, 2, 2, 'aprobacion', 'rechazado', 'Paso Solicitud 2', 'bifurcacion', 'unanime', '2023-01-03'),
(1, 3, 3, 3, 'ejecucion', 'aprobado', 'Paso Solicitud 3', 'union', 'individual', '2023-01-04'),
(1, 4, 4, 4, 'aprobacion', 'excepcion', 'Paso Solicitud 4', 'normal', 'ancla', '2023-01-05'),
(1, 5, 5, 5, 'ejecucion', 'aprobado', 'Paso Solicitud 5', 'bifurcacion', 'individual', '2023-01-06'),
(1, 6, 6, 6, 'aprobacion', 'rechazado', 'Paso Solicitud 6', 'union', 'unanime', '2023-01-07'),
(1, 7, 7, 7, 'ejecucion', 'aprobado', 'Paso Solicitud 7', 'normal', 'individual', '2023-01-08'),
(1, 8, 8, 8, 'aprobacion', 'excepcion', 'Paso Solicitud 8', 'bifurcacion', 'ancla', '2023-01-09'),
(1, 9, 9, 9, 'ejecucion', 'aprobado', 'Paso Solicitud 9', 'union', 'individual', '2023-01-10'),
(1, 10, 10, 10, 'aprobacion', 'rechazado', 'Paso Solicitud 10', 'normal', 'unanime', '2023-01-11');

-- 13. RelacionInput (depende de Inputs, PasoSolicitud y Solicitud)
INSERT INTO RelacionInput (input_id, valor, requerido, paso_solicitud_id, solicitud_id) VALUES
(1, 'Dato 1', TRUE, NULL, 1),
(2, 'Dato 2', FALSE, NULL, 2),
(3, 'Dato 3', TRUE, 1, NULL),
(4, 'Dato 4', FALSE, 2, NULL),
(5, 'Dato 5', TRUE, 3, NULL),
(6, 'Dato 6', FALSE, 4, NULL),
(7, 'Dato 7', TRUE, 5, NULL),
(8, 'Dato 8', FALSE, 6, NULL),
(9, 'Dato 9', TRUE, 7, NULL),
(10, 'Dato 10', FALSE, 8, NULL);

-- 14. RelacionGrupoAprobacion (depende de GrupoAprobacion, PasoSolicitud y Solicitud)
INSERT INTO RelacionGrupoAprobacion (grupo_aprobacion_id, paso_solicitud_id, solicitud_id) VALUES
(1, NULL, 1),
(2, 1, NULL),
(3, 2, NULL),
(4, 3, NULL),
(5, 4, NULL),
(6, 5, NULL),
(7, 6, NULL),
(8, 7, NULL),
(9, 8, NULL),
(10, 9, NULL);

-- 15. RelacionDecisionUsuario (depende de Usuario y RelacionGrupoAprobacion)
INSERT INTO RelacionDecisionUsuario (id_usuario, relacion_grupo_aprobacion_id, decision) VALUES
(1, 1, TRUE),
(2, 2, FALSE),
(3, 3, TRUE),
(4, 4, FALSE),
(5, 5, TRUE),
(6, 6, FALSE),
(7, 7, TRUE),
(8, 8, FALSE),
(9, 9, TRUE),
(10, 10, FALSE);

-- 16. Delegacion (depende de Usuario y GrupoAprobacion)
INSERT INTO Delegacion (delegado_id, superior_id, grupo_aprobacion_id, fecha_inicio, fecha_fin) VALUES
(2, 1, 1, '2023-01-01', '2023-12-31'),
(3, 2, 2, '2023-02-01', '2023-11-30'),
(4, 3, 3, '2023-03-01', '2023-10-31'),
(5, 4, 4, '2023-04-01', '2023-09-30'),
(6, 5, 5, '2023-05-01', '2023-08-31'),
(7, 6, 6, '2023-06-01', '2023-07-31'),
(8, 7, 7, '2023-07-01', '2023-08-31'),
(9, 8, 8, '2023-08-01', '2023-09-30'),
(10, 9, 9, '2023-09-01', '2023-10-31'),
(1, 10, 10, '2023-10-01', '2023-11-30');

-- 17. RelacionUsuarioGrupo (depende de GrupoAprobacion y Usuario)
INSERT INTO RelacionUsuarioGrupo (grupo_aprobacion_id, usuario_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

-- 18. Comentario (depende de PasoSolicitud, FlujoActivo y Usuario)
INSERT INTO Comentario (paso_solicitud_id, flujo_activo_id, usuario_id, contenido, fecha) VALUES
(1, NULL, 1, 'Revisión completada', '2023-01-01'),
(NULL, 1, 2, 'Flujo en curso', '2023-01-02'),
(2, NULL, 3, 'Aprobación pendiente', '2023-01-03'),
(NULL, 2, 4, 'Flujo finalizado', '2023-01-04'),
(3, NULL, 5, 'Ejecución exitosa', '2023-01-05'),
(NULL, 3, 6, 'Flujo cancelado', '2023-01-06'),
(4, NULL, 7, 'Excepción registrada', '2023-01-07'),
(NULL, 4, 8, 'Flujo activo', '2023-01-08'),
(5, NULL, 9, 'Preparación lista', '2023-01-09'),
(NULL, 5, 10, 'Flujo terminado', '2023-01-10');

-- 19. Notificacion (depende de Usuario)
INSERT INTO Notificacion (usuario_id, mensaje, prioridad, leida) VALUES
(1, 'Revisar solicitud 1', 'baja', FALSE),
(2, 'Aprobar paso 2', 'media', TRUE),
(3, 'Urgente: flujo 3', 'alta', FALSE),
(4, 'Error crítico', 'critica', TRUE),
(5, 'Validar datos', 'baja', FALSE),
(6, 'Revisión técnica', 'media', TRUE),
(7, 'Aprobación requerida', 'alta', FALSE),
(8, 'Sistema caído', 'critica', TRUE),
(9, 'Actualizar estado', 'baja', FALSE),
(10, 'Confirmar cierre', 'media', TRUE);

-- 20. Propuesta (depende de Usuario y FlujoAprobacion)
INSERT INTO Propuesta (titulo, descripcion, usuario_creador_id, flujo_id) VALUES
('Propuesta 1', 'Mejorar ventas', 1, 1),
('Propuesta 2', 'Campaña marketing', 2, 2),
('Propuesta 3', 'Revisión financiera', 3, 3),
('Propuesta 4', 'Política RRHH', 4, 4),
('Propuesta 5', 'Actualización TI', 5, 5),
('Propuesta 6', 'Optimización operativa', 6, 6),
('Propuesta 7', 'Contrato legal', 7, 7),
('Propuesta 8', 'Orden de compra', 8, 8),
('Propuesta 9', 'Control de calidad', 9, 9),
('Propuesta 10', 'Proyecto I+D', 10, 10);

-- 21. Votacion (depende de Propuesta)
INSERT INTO Votacion (propuesta_id, resultado, fecha_cierre) VALUES
(1, 'aprobado', '2023-12-31'),
(2, 'rechazado', '2023-11-30'),
(3, 'aprobado', '2023-10-31'),
(4, 'rechazado', '2023-09-30'),
(5, 'aprobado', '2023-08-31'),
(6, 'rechazado', '2023-07-31'),
(7, 'aprobado', '2023-06-30'),
(8, 'rechazado', '2023-05-31'),
(9, 'aprobado', '2023-04-30'),
(10, 'rechazado', '2023-03-31');

-- 22. Voto (depende de Votacion y Usuario)
INSERT INTO Voto (votacion_id, usuario_id, valor, fecha) VALUES
(1, 1, 'aprobado', '2023-01-01'),
(1, 2, 'rechazado', '2023-01-02'),
(2, 3, 'aprobado', '2023-01-03'),
(2, 4, 'rechazado', '2023-01-04'),
(3, 5, 'aprobado', '2023-01-05'),
(3, 6, 'rechazado', '2023-01-06'),
(4, 7, 'aprobado', '2023-01-07'),
(4, 8, 'rechazado', '2023-01-08'),
(5, 9, 'aprobado', '2023-01-09'),
(5, 10, 'rechazado', '2023-01-10');

-- 23. Backup (depende de Usuario)
INSERT INTO Backup (fecha, tipo, ubicacion, tipo_contenido, referencia_contenido, usuario_id) VALUES
('2023-01-01', 'completo', 's3://bucket1', 'archivo', 'backup1.zip', 1),
('2023-02-01', 'incremental', 's3://bucket2', 'enlace', 'https://backup2.com', 2),
('2023-03-01', 'diferencial', 's3://bucket3', 'archivo', 'backup3.zip', 3),
('2023-04-01', 'espejo', 's3://bucket4', 'enlace', 'https://backup4.com', 4),
('2023-05-01', 'completo', 's3://bucket5', 'archivo', 'backup5.zip', 5),
('2023-06-01', 'incremental', 's3://bucket6', 'enlace', 'https://backup6.com', 6),
('2023-07-01', 'diferencial', 's3://bucket7', 'archivo', 'backup7.zip', 7),
('2023-08-01', 'espejo', 's3://bucket8', 'enlace', 'https://backup8.com', 8),
('2023-09-01', 'completo', 's3://bucket9', 'archivo', 'backup9.zip', 9),
('2023-10-01', 'incremental', 's3://bucket10', 'enlace', 'https://backup10.com', 10);

-- 24. Incidente (depende de Usuario)
INSERT INTO Incidente (descripcion, severidad, estado, usuario_reporta_id, fecha_reporte) VALUES
('Fallo en servidor', 'baja', 'enrevision', 1, '2023-01-01'),
('Error de red', 'media', 'resuelto', 2, '2023-02-01'),
('Pérdida de datos', 'alta', 'cerrado', 3, '2023-03-01'),
('Sistema caído', 'crítica', 'enrevision', 4, '2023-04-01'),
('Bug en aplicación', 'baja', 'resuelto', 5, '2023-05-01'),
('Retraso en flujo', 'media', 'cerrado', 6, '2023-06-01'),
('Fallo de seguridad', 'alta', 'enrevision', 7, '2023-07-01'),
('Error crítico', 'crítica', 'resuelto', 8, '2023-08-01'),
('Interrupción menor', 'baja', 'cerrado', 9, '2023-09-01'),
('Problema de acceso', 'media', 'enrevision', 10, '2023-10-01');

-- 25. Metrica (depende de FlujoAprobacion)
INSERT INTO Metrica (nombre, valor, flujo_id, fecha_calculo, descripcion, unidad, meta, tipo_metrica) VALUES
('Tiempo de aprobación', 10.5, 1, '2023-01-01', 'Tiempo promedio', 'segundos', 20.0, 'productividad'),
('Errores detectados', 20.0, 2, '2023-02-01', 'Errores por flujo', 'número', 30.0, 'calidad'),
('Eficiencia operativa', 30.0, 3, '2023-03-01', 'Eficiencia en horas', 'horas', 40.0, 'eficiencia'),
('Tasa de aprobación', 40.0, 4, '2023-04-01', 'Porcentaje aprobado', 'porcentaje', 50.0, 'productividad'),
('Incidentes reportados', 50.0, 5, '2023-05-01', 'Incidentes totales', 'número', 60.0, 'calidad'),
('Tiempo de ejecución', 60.0, 6, '2023-06-01', 'Tiempo en segundos', 'segundos', 70.0, 'eficiencia'),
('Revisión técnica', 70.0, 7, '2023-07-01', 'Minutos revisados', 'minutos', 80.0, 'productividad'),
('Calidad del flujo', 80.0, 8, '2023-08-01', 'Horas de calidad', 'horas', 90.0, 'calidad'),
('Eficiencia técnica', 90.0, 9, '2023-09-01', 'Porcentaje eficiente', 'porcentaje', 100.0, 'eficiencia'),
('Productividad diaria', 100.0, 10, '2023-10-01', 'Tareas completadas', 'número', 110.0, 'productividad');

-- 26. Informe (depende de Usuario)
INSERT INTO Informe (nombre, tipo, fecha_generacion, usuario_generador_id, contenido) VALUES
('Informe ventas', 'resumen', '2023-01-01', 1, 'Resumen de ventas'),
('Informe marketing', 'detallado', '2023-02-01', 2, 'Detalles de campaña'),
('Informe financiero', 'comparativo', '2023-03-01', 3, 'Comparación anual'),
('Informe RRHH', 'auditoría', '2023-04-01', 4, 'Auditoría de personal'),
('Informe TI', 'resumen', '2023-05-01', 5, 'Resumen técnico'),
('Informe operaciones', 'detallado', '2023-06-01', 6, 'Detalles operativos'),
('Informe legal', 'comparativo', '2023-07-01', 7, 'Comparación legal'),
('Informe compras', 'auditoría', '2023-08-01', 8, 'Auditoría de compras'),
('Informe calidad', 'resumen', '2023-09-01', 9, 'Resumen de calidad'),
('Informe I+D', 'detallado', '2023-10-01', 10, 'Detalles de I+D');

-- 27. Excepcion (depende de PasoSolicitud y Usuario)
INSERT INTO Excepcion (paso_solicitud_id, motivo, fecha_registro, usuario_id) VALUES
(1, 'Fallo técnico', '2023-01-01', 1),
(2, 'Rechazo manual', '2023-02-01', 2),
(3, 'Error de datos', '2023-03-01', 3),
(4, 'Excepción crítica', '2023-04-01', 4),
(5, 'Retraso', '2023-05-01', 5),
(6, 'Fallo de sistema', '2023-06-01', 6),
(7, 'Validación pendiente', '2023-07-01', 7),
(8, 'Error humano', '2023-08-01', 8),
(9, 'Datos incompletos', '2023-09-01', 9),
(10, 'Problema externo', '2023-10-01', 10);

-- 28. InformeMetrica (depende de Informe y Metrica)
INSERT INTO InformeMetrica (informe_id, metrica_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- 29. InformeFlujo (depende de Informe y FlujoAprobacion)
INSERT INTO InformeFlujo (informe_id, flujo_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- UPDATEs (ejemplos de modificaciones)
UPDATE Departamento 
SET nombre = 'Ventas Actualizado' 
WHERE id_departamento = 1;

UPDATE Solicitud 
SET estado = 'rechazado' 
WHERE id_solicitud = 1;

UPDATE RelacionDecisionUsuario 
SET decision = FALSE 
WHERE id_relacion = 1;

UPDATE FlujoActivo 
SET estado = 'finalizado', fecha_finalizacion = '2023-11-01' 
WHERE id_flujo_activo = 1;

UPDATE Notificacion 
SET leida = TRUE 
WHERE id_notificacion = 1;

-- DELETEs (eliminaciones respetando dependencias)
DELETE FROM Comentario 
WHERE id_comentario = 1;

DELETE FROM Notificacion 
WHERE id_notificacion = 2;

DELETE FROM RelacionVisualizador 
WHERE id_relacion = 3;

DELETE FROM Voto 
WHERE id_voto = 4;

DELETE FROM Backup 
WHERE id_backup = 5;

-- SELECTs (consultas útiles)
-- 1. Usuarios con su departamento y rol
SELECT u.nombre, d.nombre AS departamento, r.nombre AS rol
FROM Usuario u
JOIN Departamento d ON u.departamento_id = d.id_departamento
JOIN Rol r ON u.rol_id = r.id_rol;

-- 2. Solicitudes con estado y nombre del solicitante
SELECT s.id_solicitud, s.estado, u.nombre AS solicitante
FROM Solicitud s
JOIN Usuario u ON s.solicitante_id = u.id_usuario;

-- 3. Pasos de un flujo activo con su estado
SELECT ps.id_paso_solicitud, ps.nombre, ps.estado
FROM PasoSolicitud ps
WHERE ps.flujo_activo_id = 1;

-- 4. Flujos activos finalizados con su solicitud
SELECT fa.id_flujo_activo, fa.estado, s.id_solicitud
FROM FlujoActivo fa
JOIN Solicitud s ON fa.solicitud_id = s.id_solicitud
WHERE fa.estado = 'finalizado';

-- 5. Métricas de un flujo específico
SELECT m.nombre, m.valor, m.unidad
FROM Metrica m
WHERE m.flujo_id = 1;