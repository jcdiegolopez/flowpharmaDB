-- Inserts de Rol
INSERT INTO Rol (id_rol, nombre) VALUES
(1, 'Administrador'),
(2, 'Usuario'),
(3, 'Aprobador');

-- Inserts de Usuario
INSERT INTO Usuario (id_usuario, nombre, email, rol_id) VALUES
(1, 'Juan Pérez', 'juan@empresa.com', 1),
(2, 'Ana López', 'ana@empresa.com', 2),
(3, 'Carlos Gómez', 'carlos@empresa.com', 3),
(4, 'Luisa Martínez', 'luisa@empresa.com', 2),
(5, 'Miguel Rojas', 'miguel@empresa.com', 3);

-- Inserts de FlujoAprobacion
INSERT INTO FlujoAprobacion (id_flujo, nombre, descripcion, version_actual, es_plantilla, creado_por) VALUES
(1, 'Aprobación de Compras', 'Flujo para aprobar solicitudes de compras', 1, FALSE, 1),
(2, 'Aprobación de Viajes', 'Flujo para aprobación de viajes corporativos', 1, TRUE, 1);

-- Inserts de PasoFlujo
INSERT INTO PasoFlujo (id_paso, flujo_id, nombre, tipo_flujo, orden, requiere_documento, requiere_ejecucion, regla_aprobacion) VALUES
(1, 1, 'Revisión Inicial', 'normal', 1, TRUE, FALSE, 'Verificar presupuesto'),
(2, 1, 'Aprobación Gerencial', 'normal', 2, FALSE, TRUE, 'Aprobación final'),
(3, 2, 'Solicitud de Itinerario', 'normal', 1, TRUE, FALSE, 'Revisar itinerario'),
(4, 2, 'Aprobación de Viaje', 'normal', 2, FALSE, TRUE, 'Aprobación por Gerencia');

-- Inserts de CaminoParalelo
INSERT INTO CaminoParalelo (id_camino, paso_origen_id, paso_destino_id, es_excepcion) VALUES
(1, 1, 2, FALSE),
(2, 3, 4, FALSE);

-- Inserts de Solicitud
INSERT INTO Solicitud (id_solicitud, flujo_base_id, solicitante_id, estado) VALUES
(1, 1, 2, 'pendiente'),
(2, 2, 4, 'pendiente');

-- Inserts de FlujoActivo
INSERT INTO FlujoActivo (id_flujo_activo, solicitud_id, flujo_ejecucion_id, estado) VALUES
(1, 1, 1, 'en_proceso'),
(2, 2, 2, 'en_proceso');

-- Inserts de PasoSolicitud
INSERT INTO PasoSolicitud (id_paso_solicitud, flujo_activo_id, paso_id, camino_id, responsable_id, estado, nombre, tipo_flujo, orden, requiere_documento, requiere_ejecucion, regla_aprobacion) VALUES
(1, 1, 1, 1, 3, 'pendiente', 'Revisión Inicial', 'normal', 1, TRUE, FALSE, 'Verificar presupuesto'),
(2, 1, 2, 1, 1, 'pendiente', 'Aprobación Gerencial', 'normal', 2, FALSE, TRUE, 'Aprobación final'),
(3, 2, 3, 2, 5, 'pendiente', 'Solicitud de Itinerario', 'normal', 1, TRUE, FALSE, 'Revisar itinerario'),
(4, 2, 4, 2, 1, 'pendiente', 'Aprobación de Viaje', 'normal', 2, FALSE, TRUE, 'Aprobación por Gerencia');

-- Inserts de Documento
INSERT INTO Documento (id_documento, paso_solicitud_id, nombre, tipo, hash_firma) VALUES
(1, 1, 'Factura_001.pdf', 'pdf', 'hash123'),
(2, 3, 'Itinerario_001.pdf', 'pdf', 'hash456');

-- Inserts de Aprobacion
INSERT INTO Aprobacion (id_aprobacion, paso_solicitud_id, usuario_id, decision) VALUES
(1, 2, 1, 'aprobado'),
(2, 4, 1, 'pendiente');

-- Inserts de Comentario
INSERT INTO Comentario (id_comentario, paso_solicitud_id, usuario_id, contenido) VALUES
(1, 1, 3, 'El presupuesto es adecuado'),
(2, 2, 1, 'Proceder con la aprobación');

-- Inserts de Notificacion
INSERT INTO Notificacion (id_notificacion, usuario_id, mensaje, prioridad) VALUES
(1, 2, 'Tienes una nueva solicitud pendiente', 'alta'),
(2, 3, 'Se ha actualizado el estado de la solicitud', 'media');

--Inserts de Propuesta
INSERT INTO Propuesta (id_propuesta, titulo, descripcion, usuario_creador_id, flujo_id, estado) VALUES
(1, 'Nueva Modalidad de Aprobación', 'Propuesta para agilizar procesos', 2, 1, 'pendiente'),
(2, 'Ajuste en Flujo de Viajes', 'Propuesta para incluir validaciones adicionales', 4, 2, 'pendiente');

-- Inserts de Votacion
INSERT INTO Votacion (id_votacion, propuesta_id, tipo, resultado, fecha_cierre) VALUES
(1, 1, 'simple', 'aprobado', '2025-03-25 17:00:00'),
(2, 2, 'multiple', 'pendiente', '2025-03-30 17:00:00');

-- Inserts de Voto
INSERT INTO Voto (id_voto, votacion_id, usuario_id, valor) VALUES
(1, 1, 3, 'aprobado'),
(2, 1, 4, 'rechazado'),
(3, 2, 1, 'aprobado');

-- Inserts de Backup
INSERT INTO Backup (id_backup, tipo, ubicacion, tipo_contenido, referencia_contenido, usuario_id) VALUES
(1, 'completo', '/backups/backup_20250301.sql', 'archivo', '/backups/backup_20250301.sql', 1),
(2, 'incremental', 'http://s3.aws.com/backup_20250302', 'enlace', 'http://s3.aws.com/backup_20250302', 1);

-- Inserts de Incidente
INSERT INTO Incidente (id_incidente, descripcion, severidad, estado, usuario_reporta_id) VALUES
(1, 'Error en aprobación de solicitud', 'alta', 'abierto', 3),
(2, 'Demora en actualización de datos', 'media', 'cerrado', 2);

-- Inserts de Metrica
INSERT INTO Metrica (id_metrica, nombre, valor, flujo_id, descripcion, unidad, meta, tipo_metrica) VALUES
(1, 'Tiempo Promedio de Aprobación', 24.5, 1, 'Tiempo en horas', 'horas', 24, 'productividad'),
(2, 'Tasa de Aprobación', 90.0, 1, 'Porcentaje de solicitudes aprobadas', '%', 95, 'eficiencia');

-- Inserts de Informe
INSERT INTO Informe (id_informe, nombre, tipo, usuario_generador_id, contenido) VALUES
(1, 'Informe Mensual de Aprobaciones', 'resumen', 1, 'Resumen de aprobaciones del mes.'),
(2, 'Informe Detallado de Incidentes', 'detallado', 2, 'Detalle de incidentes registrados.');

-- Inserts de Excepcion
INSERT INTO Excepcion (id_excepcion, paso_solicitud_id, motivo, usuario_id) VALUES
(1, 1, 'Falta de documento adjunto', 3),
(2, 4, 'Aprobación fuera de tiempo', 1);

-- Inserts de InformeMetrica
INSERT INTO InformeMetrica (id_informe_metrica, informe_id, metrica_id) VALUES
(1, 1, 1),
(2, 2, 2);

-- Inserts de InformeFlujo
INSERT INTO InformeFlujo (id_informe_flujo, informe_id, flujo_id) VALUES
(1, 1, 1),
(2, 2, 2);