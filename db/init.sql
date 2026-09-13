-- =========================================
-- BASE DE DATOS: BaseDatosGym
-- =========================================

-- 1. CATEGORÍAS DE EJERCICIOS
CREATE TABLE categoria_ejercicio (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 2. EJERCICIOS
CREATE TABLE ejercicio (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    grupo_muscular VARCHAR(100),
    imagen_url TEXT,
    video_url TEXT,
    categoria_id INT NOT NULL,
    CONSTRAINT fk_ejercicio_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria_ejercicio(id)
);

-- 3. RUTINAS
CREATE TABLE rutina (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    duracion_semanas INT NOT NULL
);

-- 4. RELACIÓN ENTRE RUTINAS Y EJERCICIOS
CREATE TABLE rutina_ejercicio (
    rutina_id INT NOT NULL,
    ejercicio_id INT NOT NULL,
    series INT NOT NULL,
    repeticiones VARCHAR(50) NOT NULL,
    peso_sugerido VARCHAR(50),
    orden INT NOT NULL,
    notas TEXT,
    PRIMARY KEY (rutina_id, ejercicio_id),
    CONSTRAINT fk_rutina_ejercicio_rutina
        FOREIGN KEY (rutina_id)
        REFERENCES rutina(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_rutina_ejercicio_ejercicio
        FOREIGN KEY (ejercicio_id)
        REFERENCES ejercicio(id)
        ON DELETE CASCADE
);

-- 5. USUARIOS
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

-- 6. ASIGNACIÓN DE RUTINAS A USUARIOS
CREATE TABLE asignacion (
    usuario_id INT NOT NULL,
    rutina_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    semana_numero INT,
    estado VARCHAR(50) NOT NULL,
    notas TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (usuario_id, rutina_id, fecha_inicio),
    CONSTRAINT fk_asignacion_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_asignacion_rutina
        FOREIGN KEY (rutina_id)
        REFERENCES rutina(id)
        ON DELETE CASCADE
);

-- =========================================
-- DATOS DE EJEMPLO
-- =========================================
INSERT INTO categoria_ejercicio (nombre) VALUES
    ('Fuerza'),
    ('Cardio'),
    ('Flexibilidad'),
    ('Funcional');

INSERT INTO ejercicio (nombre, descripcion, grupo_muscular, imagen_url, video_url, categoria_id) VALUES
    ('Press de banca', 'Ejercicio de empuje horizontal', 'Pecho', '', '', 1),
    ('Sentadilla', 'Ejercicio compuesto de tren inferior', 'Piernas', '', '', 1),
    ('Trote continuo', 'Carrera a ritmo moderado', 'Cuerpo completo', '', '', 2),
    ('Plancha', 'Isométrico de core', 'Abdomen', '', '', 4);

INSERT INTO rutina (nombre, descripcion, duracion_semanas) VALUES
    ('Full Body Principiante', 'Rutina de cuerpo completo 3 días', 4),
    ('Hipertrofia Torso-Pierna', 'Split torso pierna', 8);

INSERT INTO rutina_ejercicio (rutina_id, ejercicio_id, series, repeticiones, peso_sugerido, orden) VALUES
    (1, 1, 4, '8-10', '40kg', 1),
    (1, 2, 4, '10-12', '50kg', 2),
    (1, 4, 3, '30s', 'Peso corporal', 3);

-- Contraseña de ambos: "admin123" (hash bcrypt real)
INSERT INTO usuario (nombre, apellido, email, password, rol) VALUES
    ('Admin', 'General', 'admin@gym.com', '$2y$10$b0U9y9q7eELaWdgwVug.n.dwyw5SmD4S3Vr5C4sW2hCV6UEjDqmbq', 'admin'),
    ('Juan', 'Perez', 'cliente@gym.com', '$2y$10$b0U9y9q7eELaWdgwVug.n.dwyw5SmD4S3Vr5C4sW2hCV6UEjDqmbq', 'cliente');

-- Le asignamos al cliente de ejemplo la rutina 1 para poder probar
-- "Mis Entrenamientos" apenas se levanta el proyecto.
INSERT INTO asignacion (usuario_id, rutina_id, fecha_inicio, estado) VALUES
    ((SELECT id FROM usuario WHERE email = 'cliente@gym.com'), 1, CURRENT_DATE, 'activa');
