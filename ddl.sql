-- Departamento
CREATE TABLE Departamento (
    id_departamento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Rol
CREATE TABLE Rol (
    id_rol INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Usuario
CREATE TABLE Usuario (
    id_usuario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    departamento_id INT,
    rol_id INT,
    CONSTRAINT fk_usuario_departamento FOREIGN KEY (departamento_id)
        REFERENCES Departamento(id_departamento),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id)
        REFERENCES Rol(id_rol)
);

-- FlujoAprobacion: Nota – se impone la regla que 'creado_por' < 'id_flujo'.
CREATE TABLE FlujoAprobacion (
    id_flujo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    version_actual INT,
    es_plantilla BOOLEAN,
    fecha_creacion TIMESTAMP,
    creado_por INT,
    CONSTRAINT fk_flujo_creado_por FOREIGN KEY (creado_por)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT chk_flujo_creado_por CHECK (creado_por < id_flujo)
);

-- PasoFlujo
CREATE TABLE PasoFlujo (
    id_paso INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    flujo_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    tipo_flujo VARCHAR(50) NOT NULL,   -- Valores esperados: 'normal', 'bifurcacion', 'union'
    tipo_paso VARCHAR(50) NOT NULL,     -- Valores: 'Ejecucion', 'Aprobacion'
    regla_aprobacion VARCHAR(50) NOT NULL,  -- Valores: 'Unanime', 'Individual', 'Ancla'
    CONSTRAINT fk_paso_flujo FOREIGN KEY (flujo_id)
        REFERENCES FlujoAprobacion(id_flujo),
    CONSTRAINT chk_tipo_flujo CHECK (tipo_flujo IN ('normal', 'bifurcacion', 'union')),
    CONSTRAINT chk_tipo_paso CHECK (tipo_paso IN ('Ejecucion', 'Aprobacion')),
    CONSTRAINT chk_regla_aprobacion CHECK (regla_aprobacion IN ('Unanime', 'Individual', 'Ancla'))
);

-- CaminoParalelo
CREATE TABLE CaminoParalelo (
    id_camino INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paso_origen_id INT NOT NULL,
    paso_destino_id INT NOT NULL,
    es_excepcion BOOLEAN,
    CONSTRAINT fk_camino_origen FOREIGN KEY (paso_origen_id)
        REFERENCES PasoFlujo(id_paso),
    CONSTRAINT fk_camino_destino FOREIGN KEY (paso_destino_id)
        REFERENCES PasoFlujo(id_paso)
);

-- Solicitud
CREATE TABLE Solicitud (
    id_solicitud INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    flujo_base_id INT NOT NULL,
    solicitante_id INT NOT NULL,
    fecha_creacion TIMESTAMP,
    estado VARCHAR(50),
    CONSTRAINT fk_solicitud_flujo FOREIGN KEY (flujo_base_id)
        REFERENCES FlujoAprobacion(id_flujo),
    CONSTRAINT fk_solicitud_solicitante FOREIGN KEY (solicitante_id)
        REFERENCES Usuario(id_usuario)
);

-- FlujoActivo
CREATE TABLE FlujoActivo (
    id_flujo_activo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solicitud_id INT NOT NULL,
    flujo_ejecucion_id INT NOT NULL,
    fecha_inicio TIMESTAMP,
    fecha_finalizacion TIMESTAMP,
    estado VARCHAR(50),
    CONSTRAINT fk_flujoactivo_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES Solicitud(id_solicitud),
    CONSTRAINT fk_flujoactivo_flujo FOREIGN KEY (flujo_ejecucion_id)
        REFERENCES FlujoAprobacion(id_flujo)
);

-- RelacionVisualizador
CREATE TABLE RelacionVisualizador (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    flujo_activo_id INT NOT NULL,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_visualizador_flujoactivo FOREIGN KEY (flujo_activo_id)
        REFERENCES FlujoActivo(id_flujo_activo),
    CONSTRAINT fk_visualizador_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
);

-- Inputs
CREATE TABLE Inputs (
    id_input INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo_input VARCHAR(50) NOT NULL,  -- Valores: 'TextoCorto', 'TextoLargo', 'ComboBox', 'MultipleCheckbox', 'Date', 'Number', 'Archivo'
    CONSTRAINT chk_tipo_input CHECK (tipo_input IN ('TextoCorto', 'TextoLargo', 'ComboBox', 'MultipleCheckbox', 'Date', 'Number', 'Archivo'))
);

-- PasoSolicitud
CREATE TABLE PasoSolicitud (
    id_paso_solicitud INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    flujo_activo_id INT NOT NULL,
    paso_id INT,   -- Opcional para pasos agregados
    camino_id INT NOT NULL,
    responsable_id INT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    tipo_paso VARCHAR(50) NOT NULL,   -- Valores: 'Ejecucion', 'Aprobacion'
    estado VARCHAR(50),               -- Valores: 'Aprobado', 'Rechazado', 'Excepcion'
    nombre VARCHAR(255),
    tipo_flujo VARCHAR(50) NOT NULL,    -- Valores: 'normal', 'bifurcacion', 'union'
    regla_aprobacion VARCHAR(50) NOT NULL, -- Valores: 'Unanime', 'Individual', 'Ancla'
    CONSTRAINT fk_pasosolicitud_flujoactivo FOREIGN KEY (flujo_activo_id)
        REFERENCES FlujoActivo(id_flujo_activo),
    CONSTRAINT fk_pasosolicitud_paso FOREIGN KEY (paso_id)
        REFERENCES PasoFlujo(id_paso),
    CONSTRAINT fk_pasosolicitud_camino FOREIGN KEY (camino_id)
        REFERENCES CaminoParalelo(id_camino),
    CONSTRAINT fk_pasosolicitud_responsable FOREIGN KEY (responsable_id)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT chk_pasosolicitud_tipo_paso CHECK (tipo_paso IN ('Ejecucion', 'Aprobacion')),
    CONSTRAINT chk_pasosolicitud_estado CHECK (estado IN ('Aprobado', 'Rechazado', 'Excepcion')),
    CONSTRAINT chk_pasosolicitud_tipo_flujo CHECK (tipo_flujo IN ('normal', 'bifurcacion', 'union')),
    CONSTRAINT chk_pasosolicitud_regla_aprobacion CHECK (regla_aprobacion IN ('Unanime', 'Individual', 'Ancla')),
    CONSTRAINT chk_paso_vs_flujo CHECK (id_paso_solicitud < flujo_activo_id)
);

-- RelacionInput
CREATE TABLE RelacionInput (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    input_id INT NOT NULL,
    valor VARCHAR(255),
    requerido BOOLEAN,
    paso_solicitud_id INT,
    solicitud_id INT,
    CONSTRAINT fk_relinput_input FOREIGN KEY (input_id)
        REFERENCES Inputs(id_input),
    CONSTRAINT fk_relinput_pasosolicitud FOREIGN KEY (paso_solicitud_id)
        REFERENCES PasoSolicitud(id_paso_solicitud),
    CONSTRAINT fk_relinput_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES Solicitud(id_solicitud),
    CONSTRAINT chk_relinput_exclusivo CHECK (
         (paso_solicitud_id IS NOT NULL AND solicitud_id IS NULL)
         OR (paso_solicitud_id IS NULL AND solicitud_id IS NOT NULL)
    )
);

-- GrupoAprobacion
CREATE TABLE GrupoAprobacion (
    id_grupo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha TIMESTAMP,
    es_global BOOLEAN
);

-- RelacionGrupoAprobacion
CREATE TABLE RelacionGrupoAprobacion (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    grupo_aprobacion_id INT NOT NULL,
    paso_solicitud_id INT,
    solicitud_id INT,
    CONSTRAINT fk_relgrupo_grupo FOREIGN KEY (grupo_aprobacion_id)
        REFERENCES GrupoAprobacion(id_grupo),
    CONSTRAINT fk_relgrupo_pasosolicitud FOREIGN KEY (paso_solicitud_id)
        REFERENCES PasoSolicitud(id_paso_solicitud),
    CONSTRAINT fk_relgrupo_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES Solicitud(id_solicitud),
    CONSTRAINT chk_relgrupo_exclusivo CHECK (
         (paso_solicitud_id IS NOT NULL AND solicitud_id IS NULL)
         OR (paso_solicitud_id IS NULL AND solicitud_id IS NOT NULL)
    )
);

-- RelacionDecisionUsuario
CREATE TABLE RelacionDecisionUsuario (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INT NOT NULL,
    relacion_grupo_aprobacion_id INT NOT NULL,
    decision BOOLEAN,
    CONSTRAINT fk_decision_usuario FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_decision_relgrupo FOREIGN KEY (relacion_grupo_aprobacion_id)
        REFERENCES RelacionGrupoAprobacion(id_relacion)
);

-- Delegacion
CREATE TABLE Delegacion (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    delegado_id INT NOT NULL,
    superior_id INT NOT NULL,
    grupo_aprobacion_id INT NOT NULL,
    fecha_Inicio TIMESTAMP,
    fecha_Fin TIMESTAMP,
    CONSTRAINT fk_delegacion_delegado FOREIGN KEY (delegado_id)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_delegacion_superior FOREIGN KEY (superior_id)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_delegacion_grupo FOREIGN KEY (grupo_aprobacion_id)
        REFERENCES GrupoAprobacion(id_grupo)
);

-- RelacionUsuarioGrupo
CREATE TABLE RelacionUsuarioGrupo (
    id_relacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    grupo_aprobacion_id INT NOT NULL,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_relusuariogrupo_grupo FOREIGN KEY (grupo_aprobacion_id)
        REFERENCES GrupoAprobacion(id_grupo),
    CONSTRAINT fk_relusuariogrupo_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
    -- NOTA: La regla de que 'grupo_aprobacion_id' < 'rol_id' de Usuario requiere validación externa.
);

-- Comentario
CREATE TABLE Comentario (
    id_comentario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paso_solicitud_id INT,
    flujo_activo_id INT,
    usuario_id INT NOT NULL,
    contenido TEXT,
    fecha TIMESTAMP,
    CONSTRAINT fk_comentario_pasosolicitud FOREIGN KEY (paso_solicitud_id)
        REFERENCES PasoSolicitud(id_paso_solicitud),
    CONSTRAINT fk_comentario_flujoactivo FOREIGN KEY (flujo_activo_id)
        REFERENCES FlujoActivo(id_flujo_activo),
    CONSTRAINT fk_comentario_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT chk_comentario_exclusivo CHECK (
         (paso_solicitud_id IS NOT NULL OR flujo_activo_id IS NOT NULL)
    )
);

-- Notificacion
CREATE TABLE Notificacion (
    id_notificacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT NOT NULL,
    mensaje TEXT,
    prioridad VARCHAR(50),
    leida BOOLEAN,
    fecha_envio TIMESTAMP,
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
);

-- Propuesta
CREATE TABLE Propuesta (
    id_propuesta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    usuario_creador_id INT NOT NULL,
    flujo_id INT,  -- Opcional
    estado VARCHAR(50),
    fecha_creacion TIMESTAMP,
    CONSTRAINT fk_propuesta_usuario FOREIGN KEY (usuario_creador_id)
        REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_propuesta_flujo FOREIGN KEY (flujo_id)
        REFERENCES FlujoAprobacion(id_flujo)
);

-- Votacion
CREATE TABLE Votacion (
    id_votacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    propuesta_id INT NOT NULL,
    tipo VARCHAR(50),
    resultado VARCHAR(50),
    fecha_cierre TIMESTAMP,
    CONSTRAINT fk_votacion_propuesta FOREIGN KEY (propuesta_id)
        REFERENCES Propuesta(id_propuesta)
);

-- Voto
CREATE TABLE Voto (
    id_voto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    votacion_id INT NOT NULL,
    usuario_id INT NOT NULL,
    valor VARCHAR(50),
    fecha TIMESTAMP,
    CONSTRAINT fk_voto_votacion FOREIGN KEY (votacion_id)
        REFERENCES Votacion(id_votacion),
    CONSTRAINT fk_voto_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
);

-- Backup
CREATE TABLE Backup (
    id_backup INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha TIMESTAMP,
    tipo VARCHAR(50),           -- Ej.: 'completo', 'incremental'
    ubicacion VARCHAR(255),
    tipo_contenido VARCHAR(50),  -- 'archivo' o 'enlace'
    referencia_contenido VARCHAR(255),
    usuario_id INT NOT NULL,
    CONSTRAINT fk_backup_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
);

-- Incidente
CREATE TABLE Incidente (
    id_incidente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descripcion TEXT,
    severidad VARCHAR(50),
    estado VARCHAR(50),
    usuario_reporta_id INT NOT NULL,
    fecha_reporte TIMESTAMP,
    CONSTRAINT fk_incidente_usuario FOREIGN KEY (usuario_reporta_id)
        REFERENCES Usuario(id_usuario)
);

-- Metrica
CREATE TABLE Metrica (
    id_metrica INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255),
    valor FLOAT,
    flujo_id INT NOT NULL,
    fecha_calculo TIMESTAMP,
    descripcion TEXT,
    unidad VARCHAR(50),
    meta FLOAT,
    tipo_metrica VARCHAR(50),
    CONSTRAINT fk_metrica_flujo FOREIGN KEY (flujo_id)
        REFERENCES FlujoAprobacion(id_flujo)
);

-- Informe
CREATE TABLE Informe (
    id_informe INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(255),
    tipo VARCHAR(50),          -- Ej.: 'resumen', 'detallado'
    fecha_generacion TIMESTAMP,
    usuario_generador_id INT NOT NULL,
    contenido TEXT,
    CONSTRAINT fk_informe_usuario FOREIGN KEY (usuario_generador_id)
        REFERENCES Usuario(id_usuario)
);

-- Excepcion
CREATE TABLE Excepcion (
    id_excepcion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paso_solicitud_id INT NOT NULL,
    motivo TEXT,
    fecha_registro TIMESTAMP,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_excepcion_pasosolicitud FOREIGN KEY (paso_solicitud_id)
        REFERENCES PasoSolicitud(id_paso_solicitud),
    CONSTRAINT fk_excepcion_usuario FOREIGN KEY (usuario_id)
        REFERENCES Usuario(id_usuario)
);

-- InformeMetrica
CREATE TABLE InformeMetrica (
    id_informe_metrica INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    informe_id INT NOT NULL,
    metrica_id INT NOT NULL,
    CONSTRAINT fk_infometrica_informe FOREIGN KEY (informe_id)
        REFERENCES Informe(id_informe),
    CONSTRAINT fk_infometrica_metrica FOREIGN KEY (metrica_id)
        REFERENCES Metrica(id_metrica)
);

-- InformeFlujo
CREATE TABLE InformeFlujo (
    id_informe_flujo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    informe_id INT NOT NULL,
    flujo_id INT NOT NULL,
    CONSTRAINT fk_inforeflujo_informe FOREIGN KEY (informe_id)
        REFERENCES Informe(id_informe),
    CONSTRAINT fk_inforeflujo_flujo FOREIGN KEY (flujo_id)
        REFERENCES FlujoAprobacion(id_flujo)
);
