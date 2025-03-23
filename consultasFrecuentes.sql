-- ============================================================
-- CONSULTAS NIVEL FÁCIL
-- ============================================================

-- 1. Listar todos los usuarios.
SELECT * FROM Usuario;

-- 2. Listar todos los roles.
SELECT * FROM Rol;

-- 3. Obtener todos los flujos de aprobación.
SELECT * FROM FlujoAprobacion;

-- 4. Listar todas las solicitudes.
SELECT * FROM Solicitud;

-- 5. Obtener los documentos asociados a un paso de solicitud específico (por ejemplo, paso_solicitud con id 1).
SELECT * FROM Documento
WHERE paso_solicitud_id = 1;

-- ============================================================
-- CONSULTAS NIVEL INTERMEDIO
-- ============================================================

-- 1. Listar usuarios con su nombre de rol (JOIN entre Usuario y Rol).
SELECT u.id_usuario, u.nombre AS usuario, u.email, r.nombre AS rol
FROM Usuario u
JOIN Rol r ON u.rol_id = r.id_rol;

-- 2. Listar solicitudes junto con el nombre del flujo de aprobación asociado.
SELECT s.id_solicitud, s.estado, f.nombre AS flujo
FROM Solicitud s
JOIN FlujoAprobacion f ON s.flujo_base_id = f.id_flujo;

-- 3. Listar los pasos de cada flujo, mostrando el orden y nombre del paso.
SELECT pf.id_paso, f.nombre AS flujo, pf.orden, pf.nombre AS paso
FROM PasoFlujo pf
JOIN FlujoAprobacion f ON pf.flujo_id = f.id_flujo
ORDER BY f.nombre, pf.orden;

-- 4. Obtener las aprobaciones con el nombre del usuario que aprobó y su decisión.
SELECT a.id_aprobacion, ps.id_paso_solicitud, u.nombre AS usuario, a.decision, a.fecha
FROM Aprobacion a
JOIN Usuario u ON a.usuario_id = u.id_usuario
JOIN PasoSolicitud ps ON a.paso_solicitud_id = ps.id_paso_solicitud;

-- 5. Listar las propuestas junto con el nombre del flujo de aprobación asociado (si lo tienen) y el nombre del usuario creador.
SELECT p.id_propuesta, p.titulo, p.estado, u.nombre AS creador, f.nombre AS flujo
FROM Propuesta p
JOIN Usuario u ON p.usuario_creador_id = u.id_usuario
LEFT JOIN FlujoAprobacion f ON p.flujo_id = f.id_flujo;

-- ============================================================
-- CONSULTAS NIVEL DIFÍCIL
-- ============================================================

-- 1. Calcular el tiempo promedio (en minutos) entre el inicio y fin de cada paso de solicitud, agrupado por flujo activo.
SELECT flujo_activo_id,
       AVG(EXTRACT(EPOCH FROM (fecha_fin - fecha_inicio))/60) AS promedio_minutos
FROM PasoSolicitud
WHERE fecha_fin IS NOT NULL
GROUP BY flujo_activo_id;

-- 2. Generar un reporte que una métricas e informes: listar cada métrica junto con el contenido del informe asociado (usando la tabla InformeMetrica).
SELECT m.nombre AS metrica, m.valor, i.nombre AS informe, i.contenido
FROM InformeMetrica im
JOIN Metrica m ON im.metrica_id = m.id_metrica
JOIN Informe i ON im.informe_id = i.id_informe;

-- 3. Mostrar para cada usuario (excluyendo aquellos que son solicitantes) el conteo de aprobaciones realizadas.
SELECT u.id_usuario, u.nombre,
       COUNT(a.id_aprobacion) AS total_aprobaciones
FROM Usuario u
JOIN Aprobacion a ON u.id_usuario = a.usuario_id
GROUP BY u.id_usuario, u.nombre
HAVING COUNT(a.id_aprobacion) > 0;

-- 4. Recuperar los flujos que tienen solicitudes pendientes junto con los detalles del paso activo actual.
SELECT s.id_solicitud, f.nombre AS flujo, pa.id_paso_solicitud, pa.nombre AS paso, pa.estado
FROM Solicitud s
JOIN FlujoAprobacion f ON s.flujo_base_id = f.id_flujo
JOIN FlujoActivo fa ON s.id_solicitud = fa.solicitud_id
JOIN PasoSolicitud pa ON fa.id_flujo_activo = pa.flujo_activo_id
WHERE s.estado = 'pendiente'
  AND pa.estado = 'pendiente';

-- 5. Usar funciones de ventana para rankear los flujos de aprobación según el número de pasos que poseen, mostrando los 3 flujos con mayor cantidad de pasos.
SELECT f.id_flujo, f.nombre, COUNT(pf.id_paso) AS total_pasos,
       RANK() OVER (ORDER BY COUNT(pf.id_paso) DESC) AS ranking
FROM FlujoAprobacion f
JOIN PasoFlujo pf ON f.id_flujo = pf.flujo_id
GROUP BY f.id_flujo, f.nombre
ORDER BY total_pasos DESC
LIMIT 3;
