use veterinaria_proyecto;
-- Tabla Persona 
CREATE TABLE Persona (
    id_Persona INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE
);
-- Tabla de Administradores 
CREATE TABLE Administradores (
    id_Admin INT PRIMARY KEY,
    nCedula VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (id_Admin) REFERENCES Persona(id_Persona)
    ON DELETE CASCADE
);

-- Tabla de Clientes 
CREATE TABLE Clientes (
    id_Cliente INT PRIMARY KEY,
    FOREIGN KEY (id_Cliente) REFERENCES Persona(id_Persona)
    ON DELETE CASCADE
);

-- Tabla de Mascotas
CREATE TABLE Mascotas (
    id_Mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    edad INT,
    raza VARCHAR(50),
    peso DECIMAL(5, 2),
    id_Cliente INT NOT NULL,
    FOREIGN KEY (id_Cliente) REFERENCES Clientes(id_Cliente)
    ON DELETE CASCADE
);

-- Tabla de Veterinarios 
CREATE TABLE Veterinarios (
    id_Veterinario INT PRIMARY KEY,
    licencia VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (id_Veterinario) REFERENCES Persona(id_Persona)
    ON DELETE CASCADE
);

-- Tabla de Horarios
CREATE TABLE Horarios (
    id_Horario INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    estado ENUM('Disponible', 'Ocupado') NOT NULL
);

-- Tabla de Citas Agendadas
CREATE TABLE Citas_Agendadas (
    id_Cita INT AUTO_INCREMENT PRIMARY KEY,
    motivo VARCHAR(255),
    fecha DATE NOT NULL,
    id_Horario INT NOT NULL,
    id_Mascota INT NOT NULL,
    id_Veterinario INT NOT NULL,
    FOREIGN KEY (id_Horario) REFERENCES Horarios(id_Horario)
    ON DELETE CASCADE,
    FOREIGN KEY (id_Mascota) REFERENCES Mascotas(id_Mascota)
    ON DELETE CASCADE,
    FOREIGN KEY (id_Veterinario) REFERENCES Veterinarios(id_Veterinario)
    ON DELETE CASCADE
);

-- Tabla de Gestión de Usuarios 
CREATE TABLE Gestion_Usuarios (
    id_Admin INT NOT NULL,
    id_Cliente INT NOT NULL,
    PRIMARY KEY (id_Admin, id_Cliente),
    FOREIGN KEY (id_Admin) REFERENCES Administradores(id_Admin)
    ON DELETE CASCADE,
    FOREIGN KEY (id_Cliente) REFERENCES Clientes(id_Cliente)
    ON DELETE CASCADE
);

-- Tabla de Gestión de Horarios
CREATE TABLE Gestion_Horarios (
    id_Veterinario INT NOT NULL,
    id_Horario INT NOT NULL,
    PRIMARY KEY (id_Veterinario, id_Horario),
    FOREIGN KEY (id_Veterinario) REFERENCES Veterinarios(id_Veterinario)
    ON DELETE CASCADE,
    FOREIGN KEY (id_Horario) REFERENCES Horarios(id_Horario)
    ON DELETE CASCADE
);


-- Insertar datos 
INSERT INTO Persona (nombres, direccion, telefono, email)
VALUES ('Juan Pérez', 'Calle 123', '123456789', 'juan.perez@example.com'), -- Administrador
       ('Carlos López', 'Avenida 456', '987654321', 'carlos.lopez@example.com'), -- Cliente
       ('Dra. Ana Gómez', 'Calle Veterinaria', '456789123', 'ana.gomez@example.com'); -- Veterinario

INSERT INTO Administradores (id_Admin, nCedula)
VALUES (1, '1234567890');

INSERT INTO Clientes (id_Cliente)
VALUES (2);

INSERT INTO Veterinarios (id_Veterinario, licencia)
VALUES (3, 'VET12345');

INSERT INTO Mascotas (nombres, edad, raza, peso, id_Cliente)
VALUES ('Firulais', 3, 'Labrador', 25.5, 2);

INSERT INTO Horarios (fecha, estado)
VALUES ('2025-01-28', 'Disponible');

INSERT INTO Citas_Agendadas (motivo, fecha, id_Horario, id_Mascota, id_Veterinario)
VALUES ('Chequeo general', '2025-01-28', 1, 1, 3);

INSERT INTO Gestion_Usuarios (id_Admin, id_Cliente)
VALUES (1, 2);

INSERT INTO Gestion_Horarios (id_Veterinario, id_Horario)
VALUES (3, 1);


-- Crear un nuevo cliente
INSERT INTO Persona (nombres, direccion, telefono, email)
VALUES ('Carlos López', 'Avenida 123', '987654321', 'carlos.lopez@example.com');

INSERT INTO Clientes (id_Cliente)
VALUES (LAST_INSERT_ID());

-- Agendar una cita
INSERT INTO Citas_Agendadas (motivo, fecha, id_Horario, id_Mascota, id_Veterinario)
VALUES ('Chequeo general', '2025-01-28', 1, 2, 3);

-- Consultar las citas de un cliente
SELECT Citas_Agendadas.id_Cita, 
       Citas_Agendadas.motivo, 
       Citas_Agendadas.fecha, 
       Mascotas.nombres AS nombre_mascota
FROM Citas_Agendadas
INNER JOIN Mascotas ON Citas_Agendadas.id_Mascota = Mascotas.id_Mascota
INNER JOIN Veterinarios ON Citas_Agendadas.id_Veterinario = Veterinarios.id_Veterinario
WHERE Mascotas.id_Cliente = 2;

-- Consultar horarios disponibles
SELECT * 
FROM Horarios 
WHERE estado = 'Disponible';

-- Actualizar la dirección de un cliente
UPDATE Persona
SET direccion = 'Nueva Avenida 456'
WHERE id_Persona = 2;

-- Cambiar el estado de un horario
UPDATE Horarios
SET estado = 'Ocupado'
WHERE id_Horario = 1;

-- Modificar los detalles de una cita
UPDATE Citas_Agendadas
SET motivo = 'Vacunación', fecha = '2025-02-01'
WHERE id_Cita = 5;


-- Sp's
DELIMITER //
CREATE PROCEDURE Sp_RegistrarCita(
    IN p_motivo VARCHAR(255),
    IN p_fecha DATE,
    IN p_idHorario INT,
    IN p_idMascota INT,
    IN p_idVeterinario INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    -- Verificar si el horario está disponible
    DECLARE v_estado VARCHAR(10);
    SELECT estado INTO v_estado FROM Horarios WHERE id_Horario = p_idHorario;

    IF v_estado = 'Disponible' THEN
        -- Insertar la cita
        INSERT INTO Citas_Agendadas (motivo, fecha, id_Horario, id_Mascota, id_Veterinario)
        VALUES (p_motivo, p_fecha, p_idHorario, p_idMascota, p_idVeterinario);

        -- Actualizar el estado del horario a 'Ocupado'
        UPDATE Horarios SET estado = 'Ocupado' WHERE id_Horario = p_idHorario;

        SET p_resultado = 'Cita registrada exitosamente.';
    ELSE
        SET p_resultado = 'El horario no está disponible.';
    END IF;
END//

DELIMITER ;
CALL Sp_RegistrarCita(
    'Chequeo general', 
    '2025-01-28', 
    5, 
    8, 
    3, 
    @resultado
);
SELECT @resultado;


-- Sp Actilizar estado 
DELIMITER //administradores
CREATE PROCEDURE Sp_ActualizacionHorario(
    IN p_idHorario INT,
    IN p_estado ENUM('Disponible', 'Ocupado'),
    OUT p_resultado VARCHAR(100)
)
BEGIN
 UPDATE Horarios
SET estado = p_estado
WHERE id_Horario = p_idHorario;

    IF ROW_COUNT() > 0 THEN
        SET p_resultado = 'Estado del horario actualizado correctamente.';
    ELSE
        SET p_resultado = 'No se encontró el horario especificado.';
    END IF;
END //

DELIMITER ;

CALL Sp_ActualizacionHorario(1, 'Disponible', @resultado);
SELECT @resultado As Resultados;


-- Eliminar la columna id_Cliente de citas_agendadas
ALTER TABLE citas_agendadas
DROP COLUMN id_Cliente;

-- Añadir la columna id_Mascota a citas_agendadas
ALTER TABLE citas_agendadas
ADD COLUMN id_Mascota INT;

-- Añadir la clave foránea para relacionar id_Mascota con mascotas
ALTER TABLE citas_agendadas
ADD CONSTRAINT fk_mascota
FOREIGN KEY (id_Mascota) REFERENCES mascotas(id_Mascota);