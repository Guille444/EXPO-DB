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

/*INSERTS DE TABLAS*/

INSERT INTO Cargos (cargo) VALUES
('Administrador'),
('Empleado');

INSERT INTO Empleados (id_cargo, nombre_empleado, apellido_empleado, alias_empleado, correo_empleado, contrasenia_empleado, imagen_empleado) VALUES
(1, 'Luis', 'Martínez', 'luis.m', 'luis.martinez@gmail.com', 'password123', 'luis_martinez.jpg'),
(1, 'Ana', 'Gómez', 'ana.g', 'ana.gomez@gmail.com', 'securepass', 'ana_gomez.jpg'),
(1, 'Pedro', 'Sánchez', 'pedro.s', 'pedro.sanchez@gmail.com', 'p@$$w0rd', 'pedro_sanchez.jpg'),
(1, 'María', 'Pérez', 'maria.p', 'maria.perez@gmail.com', 'abc123', 'maria_perez.jpg'),
(1, 'Carlos', 'Rodríguez', 'carlos.r', 'carlos.rodriguez@gmail.com', 'qwerty', 'carlos_rodriguez.jpg'),
(2, 'Laura', 'Hernández', 'laura.h', 'laura.hernandez@gmail.com', 'pass123', 'laura_hernandez.jpg'),
(2, 'Javier', 'López', 'javier.l', 'javier.lopez@gmail.com', 'admin123', 'javier_lopez.jpg'),
(2, 'Sofía', 'García', 'sofia.g', 'sofia.garcia@gmail.com', '123456', 'sofia_garcia.jpg'),
(2, 'David', 'Martín', 'david.m', 'david.martin@gmail.com', 'davidpass', 'david_martin.jpg'),
(2, 'Elena', 'Díaz', 'elena.d', 'elena.diaz@gmail.com', 'pass987', 'elena_diaz.jpg');

INSERT INTO Marcas (marca_vehiculo) VALUES
('Toyota'),
('Ford'),
('Honda'),
('Chevrolet'),
('Volkswagen'),
('BMW'),
('Mercedes-Benz'),
('Audi'),
('Hyundai'),
('Nissan');

INSERT INTO Modelos (modelo_vehiculo, id_marca) VALUES
('Camry', 1),
('F-150', 2),
('Civic', 3),
('Silverado', 4),
('Jetta', 5),
('3 Series', 6),
('C-Class', 7),
('A4', 8),
('Elantra', 9),
('Altima', 10);

INSERT INTO Clientes (nombre_cliente, apellido_cliente, alias_cliente, correo_cliente, contrasenia_cliente, contacto_cliente) VALUES
('Juan', 'García', 'juang', 'juang@gmail.com', 'password123', '1234-5678'),
('María', 'López', 'marial', 'marial@gmail.com', 'securepass', '2345-6789'),
('Pedro', 'Martínez', 'pedrom', 'pedrom@gmail.com', 'p@$$w0rd', '3456-7890'),
('Ana', 'Rodríguez', 'anar', 'anar@gmail.com', 'abc123', '4567-8901'),
('Carlos', 'Pérez', 'carlosp', 'carlosp@gmail.com', 'qwerty', '5678-9012'),
('Laura', 'Hernández', 'laurah', 'laurah@gmail.com', 'pass123', '6789-0123'),
('Javier', 'López', 'javierl', 'javierl@gmail.com', 'admin123', '7890-1234'),
('Sofía', 'García', 'sofiag', 'sofiag@gmail.com', '123456', '8901-2345'),
('David', 'Martín', 'davidm', 'davidm@gmail.com', 'davidpass', '9012-3456'),
('Elena', 'Díaz', 'elenad', 'elenad@gmail.com', 'pass987', '0123-4567');

INSERT INTO Vehiculos (id_modelo) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

INSERT INTO Detalle_Vehiculos (id_vehiculo, id_cliente, placa_vehiculo, color_vehiuclo, vim_motor) VALUES
(1, 1, 'ABC123', 'Rojo', 'VIN123456789'),
(2, 2, 'XYZ789', 'Azul', 'VIN987654321'),
(3, 3, 'DEF456', 'Negro', 'VIN654321987'),
(4, 4, 'GHI789', 'Blanco', 'VIN321654987'),
(5, 5, 'JKL012', 'Plateado', 'VIN987123456'),
(6, 6, 'MNO345', 'Gris', 'VIN456789123'),
(7, 7, 'PQR678', 'Verde', 'VIN789456123'),
(8, 8, 'STU901', 'Naranja', 'VIN123789456'),
(9, 9, 'VWX234', 'Amarillo', 'VIN456123789'),
(10, 10, 'YZA567', 'Morado', 'VIN789456123');

INSERT INTO Citas (id_detalle_vehiculo, fecha_hora_cita, servicio_cita, estado_cita) VALUES
(1, '2024-04-10 08:00:00', 'Cambio de aceite', true),
(2, '2024-04-11 10:30:00', 'Reparación de frenos', false),
(3, '2024-04-12 12:00:00', 'Mantenimiento general', true),
(4, '2024-04-13 14:30:00', 'Revisión de motor', false),
(5, '2024-04-14 16:00:00', 'Cambio de neumáticos', true),
(6, '2024-04-15 09:30:00', 'Alineación y balanceo', true),
(7, '2024-04-16 11:00:00', 'Reemplazo de parabrisas', false),
(8, '2024-04-17 13:30:00', 'Diagnóstico de falla eléctrica', true),
(9, '2024-04-18 15:00:00', 'Instalación de accesorios', false),
(10, '2024-04-19 17:30:00', 'Lavado exterior e interior', true);

INSERT INTO Reseñas (id_cliente, fecha_resenia, comentario_reseña) VALUES
(1, '2024-03-20', 'Excelente servicio. Muy recomendado.'),
(2, '2024-03-22', 'Buen trato al cliente. Volveré.'),
(3, '2024-03-24', 'Profesionales en su trabajo. Satisfecho.'),
(4, '2024-03-26', 'Hubo algunos problemas, pero se solucionaron.'),
(5, '2024-03-28', 'Rápidos y eficientes. Muy buen servicio.'),
(6, '2024-03-30', 'Me gustó el trabajo realizado. Recomendado.'),
(7, '2024-04-01', 'El personal fue amable y servicial.'),
(8, '2024-04-03', 'Excelente atención al cliente. Volveré.'),
(9, '2024-04-05', 'El servicio fue rápido y eficaz.'),
(10, '2024-04-07', 'Muy buen trabajo. Totalmente recomendado.');

INSERT INTO Piezas (id_vehiculo, nombre_pieza, descripcion_pieza, precio_unitario, proveedor) VALUES
(1, 'Filtro de aceite', 'Filtro de aceite genuino Toyota', 15.99, 'Toyota Parts Inc.'),
(2, 'Pastillas de freno delanteras', 'Pastillas de freno originales Ford', 39.99, 'Ford Motorcraft'),
(3, 'Juego de bujías de encendido', 'Bujías NGK para vehículos Honda', 8.49, 'NGK Spark Plugs'),
(4, 'Correa de distribución', 'Correa de distribución AC Delco para Chevrolet', 29.99, 'AC Delco Parts'),
(5, 'Llanta de aleación', 'Llanta de aleación Volkswagen de 16 pulgadas', 129.99, 'VW Genuine Parts'),
(6, 'Amortiguadores traseros', 'Amortiguadores Monroe para BMW', 89.99, 'Monroe Auto Parts'),
(7, 'Sistema de escape', 'Sistema de escape Magnaflow para Mercedes-Benz', 299.99, 'Magnaflow Exhaust'),
(8, 'Radiador', 'Radiador Behr para Audi A4', 179.99, 'Behr Parts'),
(9, 'Alternador', 'Alternador Denso para Hyundai Elantra', 199.99, 'Denso Auto Parts'),
(10, 'Batería', 'Batería Bosch para Nissan Altima', 149.99, 'Bosch Battery');

INSERT INTO Inventario (id_pieza, cantidad_disponible, fecha_ingreso) VALUES
(1, 50, '2024-04-01'),
(2, 30, '2024-04-01'),
(3, 100, '2024-04-01'),
(4, 20, '2024-04-01'),
(5, 40, '2024-04-01'),
(6, 10, '2024-04-01'),
(7, 5, '2024-04-01'),
(8, 15, '2024-04-01'),
(9, 25, '2024-04-01'),
(10, 35, '2024-04-01');