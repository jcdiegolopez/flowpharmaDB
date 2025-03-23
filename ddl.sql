-- Table: Rol
CREATE TABLE Rol (
    id_rol INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Table: Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    rol_id INT NOT NULL,
    suplente_id INT DEFAULT NULL,
    FOREIGN KEY (rol_id) REFERENCES Rol(id_rol),
    FOREIGN KEY (suplente_id) REFERENCES Usuario(id_usuario)
);

-- Table: FlujoAprobacion
CREATE TABLE FlujoAprobacion (
    id_flujo INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    version_actual INT DEFAULT 1,
    es_plantilla BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creado_por INT NOT NULL,
    FOREIGN KEY (creado_por) REFERENCES Usuario(id_usuario)
);

-- Table: PasoFlujo
CREATE TABLE PasoFlujo (
    id_paso INT PRIMARY KEY,
    flujo_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    tipo_flujo VARCHAR(50) NOT NULL CHECK (tipo_flujo IN ('normal','bifurcacion','union')),
    orden INT NOT NULL,
    requiere_documento BOOLEAN DEFAULT FALSE,
    requiere_ejecucion BOOLEAN DEFAULT FALSE,
    regla_aprobacion VARCHAR(255),
    FOREIGN KEY (flujo_id) REFERENCES FlujoAprobacion(id_flujo),
    UNIQUE(flujo_id, orden)  -- Each step within a flow must have a unique order
);

-- Table: CaminoParalelo
CREATE TABLE CaminoParalelo (
    id_camino INT PRIMARY KEY,
    paso_origen_id INT NOT NULL,
    paso_destino_id INT NOT NULL,
    es_excepcion BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (paso_origen_id) REFERENCES PasoFlujo(id_paso),
    FOREIGN KEY (paso_destino_id) REFERENCES PasoFlujo(id_paso)
);

-- Table: Solicitud
CREATE TABLE Solicitud (
    id_solicitud INT PRIMARY KEY,
    flujo_base_id INT NOT NULL,
    solicitante_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('pendiente','aprobado','rechazado')),
    FOREIGN KEY (flujo_base_id) REFERENCES FlujoAprobacion(id_flujo),
    FOREIGN KEY (solicitante_id) REFERENCES Usuario(id_usuario)
);

-- Table: FlujoActivo
CREATE TABLE FlujoActivo (
    id_flujo_activo INT PRIMARY KEY,
    solicitud_id INT NOT NULL,
    flujo_ejecucion_id INT NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion TIMESTAMP DEFAULT NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('en_proceso','finalizado','cancelado')),
    FOREIGN KEY (solicitud_id) REFERENCES Solicitud(id_solicitud),
    FOREIGN KEY (flujo_ejecucion_id) REFERENCES FlujoAprobacion(id_flujo)
);

-- Table: PasoSolicitud
CREATE TABLE PasoSolicitud (
    id_paso_solicitud INT PRIMARY KEY,
    flujo_activo_id INT NOT NULL,
    paso_id INT DEFAULT NULL,  -- Optional for added steps
    camino_id INT NOT NULL,
    responsable_id INT DEFAULT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP DEFAULT NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('pendiente','completado','cancelado')),
    resultado VARCHAR(50) DEFAULT NULL,
    nombre VARCHAR(255) NOT NULL,      -- Duplicated for self-containment
    tipo_flujo VARCHAR(50) NOT NULL,     -- Duplicated
    orden INT NOT NULL,                  -- Duplicated
    requiere_documento BOOLEAN DEFAULT FALSE,  -- Duplicated
    requiere_ejecucion BOOLEAN DEFAULT FALSE,  -- Duplicated
    regla_aprobacion VARCHAR(255) DEFAULT NULL,  -- Duplicated
    FOREIGN KEY (flujo_activo_id) REFERENCES FlujoActivo(id_flujo_activo),
    FOREIGN KEY (paso_id) REFERENCES PasoFlujo(id_paso),
    FOREIGN KEY (camino_id) REFERENCES CaminoParalelo(id_camino),
    FOREIGN KEY (responsable_id) REFERENCES Usuario(id_usuario)
);

-- Table: Documento
CREATE TABLE Documento (
    id_documento INT PRIMARY KEY,
    paso_solicitud_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    hash_firma VARCHAR(255),
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paso_solicitud_id) REFERENCES PasoSolicitud(id_paso_solicitud)
);

-- Table: Aprobacion
CREATE TABLE Aprobacion (
    id_aprobacion INT PRIMARY KEY,
    paso_solicitud_id INT NOT NULL,
    usuario_id INT NOT NULL,
    decision VARCHAR(50) NOT NULL CHECK (decision IN ('aprobado','rechazado','pendiente')),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paso_solicitud_id) REFERENCES PasoSolicitud(id_paso_solicitud),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    -- Business rule: The approver must not be the requester (this can be enforced via trigger or application logic)
);

-- Table: Comentario
CREATE TABLE Comentario (
    id_comentario INT PRIMARY KEY,
    paso_solicitud_id INT DEFAULT NULL,
    flujo_activo_id INT DEFAULT NULL,
    usuario_id INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paso_solicitud_id) REFERENCES PasoSolicitud(id_paso_solicitud),
    FOREIGN KEY (flujo_activo_id) REFERENCES FlujoActivo(id_flujo_activo),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
);

-- Table: Notificacion
CREATE TABLE Notificacion (
    id_notificacion INT PRIMARY KEY,
    usuario_id INT NOT NULL,
    mensaje TEXT NOT NULL,
    prioridad VARCHAR(50) NOT NULL CHECK (prioridad IN ('alta','media','baja')),
    leida BOOLEAN DEFAULT FALSE,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
);

-- Table: Propuesta
CREATE TABLE Propuesta (
    id_propuesta INT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    usuario_creador_id INT NOT NULL,
    flujo_id INT DEFAULT NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('pendiente','aprobada','rechazada')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_creador_id) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (flujo_id) REFERENCES FlujoAprobacion(id_flujo)
);

-- Table: Votacion
CREATE TABLE Votacion (
    id_votacion INT PRIMARY KEY,
    propuesta_id INT NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('simple','multiple')),
    resultado VARCHAR(50) DEFAULT NULL,
    fecha_cierre TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (propuesta_id) REFERENCES Propuesta(id_propuesta)
);

-- Table: Voto
CREATE TABLE Voto (
    id_voto INT PRIMARY KEY,
    votacion_id INT NOT NULL,
    usuario_id INT NOT NULL,
    valor VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (votacion_id) REFERENCES Votacion(id_votacion),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
);

-- Table: Backup
CREATE TABLE Backup (
    id_backup INT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('completo','incremental')),
    ubicacion VARCHAR(255) NOT NULL,
    tipo_contenido VARCHAR(50) NOT NULL CHECK (tipo_contenido IN ('archivo','enlace')),
    referencia_contenido VARCHAR(255) NOT NULL,
    usuario_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
);

-- Table: Incidente
CREATE TABLE Incidente (
    id_incidente INT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    severidad VARCHAR(50) NOT NULL CHECK (severidad IN ('baja','media','alta')),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('abierto','cerrado')),
    usuario_reporta_id INT NOT NULL,
    fecha_reporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_reporta_id) REFERENCES Usuario(id_usuario)
);

-- Table: Metrica
CREATE TABLE Metrica (
    id_metrica INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    valor FLOAT NOT NULL,
    flujo_id INT NOT NULL,
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT,
    unidad VARCHAR(50),
    meta FLOAT,
    tipo_metrica VARCHAR(100),
    FOREIGN KEY (flujo_id) REFERENCES FlujoAprobacion(id_flujo)
);

-- Table: Informe
CREATE TABLE Informe (
    id_informe INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('resumen','detallado')),
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_generador_id INT NOT NULL,
    contenido TEXT NOT NULL,
    FOREIGN KEY (usuario_generador_id) REFERENCES Usuario(id_usuario)
);

-- Table: Excepcion
CREATE TABLE Excepcion (
    id_excepcion INT PRIMARY KEY,
    paso_solicitud_id INT NOT NULL,
    motivo TEXT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT NOT NULL,
    FOREIGN KEY (paso_solicitud_id) REFERENCES PasoSolicitud(id_paso_solicitud),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
);

-- Table: InformeMetrica
CREATE TABLE InformeMetrica (
    id_informe_metrica INT PRIMARY KEY,
    informe_id INT NOT NULL,
    metrica_id INT NOT NULL,
    FOREIGN KEY (informe_id) REFERENCES Informe(id_informe),
    FOREIGN KEY (metrica_id) REFERENCES Metrica(id_metrica)
);

-- Table: InformeFlujo
CREATE TABLE InformeFlujo (
    id_informe_flujo INT PRIMARY KEY,
    informe_id INT NOT NULL,
    flujo_id INT NOT NULL,
    FOREIGN KEY (informe_id) REFERENCES Informe(id_informe),
    FOREIGN KEY (flujo_id) REFERENCES FlujoAprobacion(id_flujo)
);
