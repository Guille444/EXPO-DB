DROP DATABASE IF EXISTS db_taller_rodriguez;

CREATE DATABASE db_taller_rodriguez;

USE db_taller_rodriguez;

CREATE TABLE Cargos(
	id_cargo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	cargo VARCHAR(30) NOT NULL
);

CREATE TABLE Empleados(
	id_empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_cargo INT NOT NULL,
	CONSTRAINT fk_empleado_cargo
	FOREIGN KEY (id_cargo)
	REFERENCES Cargos (id_cargo),
	nombre_empleado VARCHAR(50) NOT NULL,
	apellido_empleado VARCHAR(50) NOT NULL,
	alias_empleado VARCHAR(50) NOT NULL,
	correo_empleado VARCHAR(100) NOT NULL,
	contrasenia_empleado VARCHAR(64) NOT NULL,
	imagen_empleado VARCHAR(25) NOT NULL
);

ALTER TABLE Empleados
ADD CONSTRAINT unique_correo_empleado UNIQUE (correo_empleado);

-- Restricción UNIQUE en el campo alias_empleado
ALTER TABLE Empleados
ADD CONSTRAINT unique_alias_empleado UNIQUE (alias_empleado);


CREATE TABLE Marcas(
	id_marca INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	marca_vehiculo VARCHAR(30)
);

ALTER TABLE Marcas
ADD CONSTRAINT unique_marca_vehiculo UNIQUE (marca_vehiculo);

CREATE TABLE Modelos(
	id_modelo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	modelo_vehiculo VARCHAR(30),
    id_marca INT NOT NULL,
    CONSTRAINT fk_modelo_marca
	FOREIGN KEY (id_marca)
	REFERENCES Marcas (id_marca)
);

ALTER TABLE Modelos
ADD CONSTRAINT unique_modelo_vehiculo UNIQUE (modelo_vehiculo);

CREATE TABLE Clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nombre_cliente VARCHAR(50),
	apellido_cliente VARCHAR(50),
	alias_cliente VARCHAR(50),
	correo_cliente VARCHAR(100),
	contrasenia_cliente VARCHAR(64),
	contacto_cliente VARCHAR(9)
);

ALTER TABLE Clientes
ADD CONSTRAINT chk_contacto_cliente_format
CHECK (contacto_cliente REGEXP '^[0-9]{4}-[0-9]{4}$');

ALTER TABLE Clientes
ADD CONSTRAINT unique_correo_cliente UNIQUE (correo_cliente);

ALTER TABLE Clientes
ADD CONSTRAINT unique_alias_cliente UNIQUE (alias_cliente);

CREATE TABLE Vehiculos(
	id_vehiculo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_modelo INT NOT NULL,
	CONSTRAINT fk_vehiculo_modelo
	FOREIGN KEY (id_modelo)
	REFERENCES Modelos (id_modelo)
);

CREATE TABLE Detalle_Vehiculos(
	id_detalle_vehiculo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_vehiculo INT NOT NULL,
	CONSTRAINT fk_detalle_vehiculo
	FOREIGN KEY (id_vehiculo)
	REFERENCES Vehiculos (id_vehiculo),
    id_cliente INT NOT NULL,
    CONSTRAINT fk_detalle_cliente
	FOREIGN KEY (id_cliente)
	REFERENCES Clientes (id_cliente),
    placa_vehiculo VARCHAR(30) NOT NULL,
	color_vehiuclo VARCHAR(30) NOT NULL,
    vim_motor VARCHAR(50) NOT NULL
);
    
CREATE TABLE Citas(
	id_cita INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_detalle_vehiculo INT NOT NULL,
    CONSTRAINT fk_cita_detalle_vehiculo
	FOREIGN KEY (id_detalle_vehiculo)
	REFERENCES Detalle_Vehiculos (id_detalle_vehiculo),
	fecha_hora_cita DATETIME NOT NULL,
	servicio_cita VARCHAR(50) NOT NULL,
    estado_cita BOOLEAN
);

CREATE TABLE Reseñas (
    id_resenia INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_reseña_cliente
	FOREIGN KEY (id_cliente)
	REFERENCES Clientes (id_cliente),
    fecha_resenia DATE NOT NULL,
    comentario_reseña VARCHAR(250)
);

CREATE TABLE Piezas(
	id_pieza INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_vehiculo INT NOT NULL,
    CONSTRAINT fk_pieza_vehiculo
	FOREIGN KEY (id_vehiculo)
	REFERENCES Vehiculos (id_vehiculo),
	nombre_pieza VARCHAR(30) NOT NULL,
	descripcion_pieza VARCHAR(250) NOT NULL,
	precio_unitario DECIMAL(10, 2),
	proveedor VARCHAR(100) NOT NULL
);

ALTER TABLE Piezas
ADD CONSTRAINT unique_nombre_pieza UNIQUE (nombre_pieza);

ALTER TABLE Piezas
ADD CONSTRAINT chk_precio_unitario_positive CHECK (precio_unitario > 0);


CREATE TABLE Inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_pieza INT NOT NULL,
    CONSTRAINT fk_inventario_pieza
	FOREIGN KEY (id_pieza)
	REFERENCES Piezas (id_pieza),
    cantidad_disponible INT NOT NULL,
    fecha_ingreso DATE
);

/*INSERTS DE TABLAS*/

INSERT INTO Cargos (cargo) VALUES
('Administrador'),
('Empleado');


/*Función calcula el total de ingresos sumando el precio de las piezas utilizadas en las citas de servicio*/
DELIMITER //

CREATE FUNCTION calcular_total_ingresos()
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(precio_unitario) INTO total
    FROM Citas
    INNER JOIN Detalle_Vehiculos ON Citas.id_detalle_vehiculo = Detalle_Vehiculos.id_detalle_vehiculo
    INNER JOIN Piezas ON Detalle_Vehiculos.id_vehiculo = Piezas.id_vehiculo;
    
    RETURN total;
END//

DELIMITER ;


/*Procedimiento almacenado para insertar un nuevo empleado en la tabla Empleados*/

DELIMITER //

CREATE PROCEDURE insertar_empleado(
    IN cargo_id INT,
    IN nombre_empleado VARCHAR(50),
    IN apellido_empleado VARCHAR(50),
    IN alias_empleado VARCHAR(50),
    IN correo_empleado VARCHAR(100),
    IN contrasenia_empleado VARCHAR(64),
    IN imagen_empleado VARCHAR(25)
)
BEGIN
    INSERT INTO Empleados (id_cargo, nombre_empleado, apellido_empleado, alias_empleado, correo_empleado, contrasenia_empleado, imagen_empleado)
    VALUES (cargo_id, nombre_empleado, apellido_empleado, alias_empleado, correo_empleado, contrasenia_empleado, imagen_empleado);
END//

DELIMITER ;	

CALL insertar_empleado(1, 'Juan', 'Pérez', 'juan.p', 'juan.perez@gmail.com', 'password123', 'juan_perez.jpg');

DELIMITER //

/*Trigger que valide el formato de los correos electrónicos antes de insertar un nuevo registro*/

DELIMITER //

CREATE TRIGGER validar_formato_correo
BEFORE INSERT ON Empleados
FOR EACH ROW
BEGIN
    DECLARE correo_valido BOOLEAN;

    -- Verificar si el correo electrónico cumple con el formato válido
    IF NEW.correo_empleado NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        SET correo_valido = FALSE;
    ELSE
        SET correo_valido = TRUE;
    END IF;

    -- Si el correo electrónico no cumple con el formato válido, generar un error y cancelar la inserción
    IF NOT correo_valido THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El formato del correo electrónico no es válido';
    END IF;
END//

DELIMITER ;


