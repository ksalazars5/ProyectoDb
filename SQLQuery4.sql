CREATE DATABASE RINCONGT;
USE RINCONGT;

-- Tabla CATEGORIA_PRODUCTO
CREATE TABLE CATEGORIA_PRODUCTO (
    ID_CATEGORIA INT IDENTITY(1,1) PRIMARY KEY,
    DESCRIPCION VARCHAR(50) NOT NULL
);

-- Tabla PRODUCTO
CREATE TABLE PRODUCTO (
    ID_PRODUCTO INT IDENTITY(1,1) PRIMARY KEY,
    ID_CATEGORIA INT FOREIGN KEY REFERENCES CATEGORIA_PRODUCTO(ID_CATEGORIA),
    DESCRIPCION VARCHAR(50) NOT NULL,
    COSTO DECIMAL(10,2) NOT NULL,
    PRECIO_VENTA DECIMAL(10,2) NOT NULL,
    INVENTARIO INT NOT NULL DEFAULT 0
);

-- Tabla DEVOLUCIONES
CREATE TABLE DEVOLUCION (
    ID_DEVOLUCION INT IDENTITY(1,1) PRIMARY KEY,
    ID_FACTURA INT FOREIGN KEY REFERENCES FACTURA(ID_FACTURA),
    ID_PRODUCTO INT FOREIGN KEY REFERENCES PRODUCTO(ID_PRODUCTO),
    CANTIDAD_DEVUELTA INT NOT NULL,
    RAZON VARCHAR(255) NOT NULL,
    DESCRIPCION_PRODUCTO VARCHAR(255),
    FECHA_DEVOLUCION DATE NOT NULL,
);

-- Tabla USUARIO
CREATE TABLE USUARIO (
    ID_USUARIO VARCHAR(50) PRIMARY KEY,
    PASS VARCHAR(50) NOT NULL
);

-- Tabla PROVEEDOR
CREATE TABLE PROVEEDOR (
    ID_PROVEEDOR INT IDENTITY(1,1) PRIMARY KEY,
    DESCRIPCION VARCHAR(50) NOT NULL,
    TELEFONO VARCHAR(50),
    DIRECCION VARCHAR(50)
);

-
-- Tabla COBRO
CREATE TABLE COBROS (
    ID_COBRO INT PRIMARY KEY IDENTITY(1,1),  -- Clave primaria, autoincremental
    ID_TIPO_COBRO INT,                       -- Clave foránea que se relaciona con TIPO_COBRO
    METODO_PAGO VARCHAR(50) NOT NULL,        -- Método de pago, como Efectivo, Tarjeta Crédito, etc.
    TOTAL DECIMAL(10, 2) NOT NULL,           -- Monto total del cobro
    NUMERO_TARJETA VARCHAR(16),              -- Número de tarjeta, si el pago es con tarjeta
    FECHA_EXPIRACION DATE,                   -- Fecha de expiración de la tarjeta
    CODIGO_SEGURIDAD VARCHAR(4),             -- Código de seguridad de la tarjeta (CVV)
    FECHA_COBRO DATE NOT NULL,               -- Fecha en que se realizó el cobro
    CONSTRAINT FK_TIPO_COBRO FOREIGN KEY (ID_TIPO_COBRO)  -- Llave foránea
    REFERENCES TIPO_COBRO(ID_TIPO_COBRO)     -- Referencia a la tabla TIPO_COBRO
);

-- Tabla TIPO_COBRO
CREATE TABLE TIPO_COBRO (
    ID_TIPO_COBRO INT PRIMARY KEY,
    DESCRIPCION VARCHAR(50) NOT NULL
);


-- Tabla CLIENTE
CREATE TABLE CLIENTE (
    ID_CLIENTE INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    TELEFONO VARCHAR(50),
    DIRECCION VARCHAR(50),
    NIT VARCHAR(50)
    FECHA_REGISTRO DATE NOT NULL DEFAULT GETDATE();
);

-- Tabla FACTURA
CREATE TABLE FACTURA (
    ID_FACTURA INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT FOREIGN KEY REFERENCES CLIENTE(ID_CLIENTE),
    TOTAL_FACTURA DECIMAL(10,2) NOT NULL,
    FECHA DATE NOT NULL
);

-- Tabla DETALLE_FACTURA
    CREATE TABLE DETALLE_FACTURA (
        ID_REGISTRO INT IDENTITY(1,1) PRIMARY KEY,
        ID_FACTURA INT FOREIGN KEY REFERENCES FACTURA(ID_FACTURA),
        ID_PRODUCTO INT FOREIGN KEY REFERENCES PRODUCTO(ID_PRODUCTO),
        CANTIDAD INT NOT NULL,
        SUBTOTAL DECIMAL(10,2) NOT NULL,
        PRECIO_UNITARIO DECIMAL(10,2) NOT NULL,
    );

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

INSERT INTO CATEGORIA_PRODUCTO (DESCRIPCION)
VALUES 
    ('Pastas'),
    ('Productos C�rnicos'),
    ('Embutidos'),
    ('L�cteos'),
    ('Golosinas'),
    ('Aguas Gaseosas'),
    ('Carbonatados');

INSERT INTO PROVEEDOR (DESCRIPCION, TELEFONO, DIRECCION)
VALUES 
    ('Walmart', '1234-5678', 'Avenida Siempre Viva 742'),
    ('Costco', '2345-6789', 'Calle del Comercio 123'),
    ('Supermercado X', '3456-7890', 'Boulevard del Centro 456'),
    ('Bodega La Esperanza', '4567-8901', 'Calle de la Paz 789'),
    ('Droguer�a FarmaPlus', '5678-9012', 'Avenida de los M�dicos 321'),
    ('Distribuidora Frutal', '6789-0123', 'Calle Frutal 654'),
    ('Carnicer�a El Buen Sabor', '7890-1234', 'Calle del Pollo 987'),
    ('L�cteos La Granja', '8901-2345', 'Camino de los L�cteos 135'),
    ('Embutidos Deliciosos', '9012-3456', 'Calle de la Salsicha 246'),
    ('Aguas Gaseosas Oasis', '0123-4567', 'Avenida del Refresco 357');

INSERT INTO PRODUCTO (ID_CATEGORIA, DESCRIPCION, COSTO, PRECIO_VENTA, INVENTARIO)
VALUES 
    (1, 'Fideos Espagueti', 0.50, 1.00, 100),
    (1, 'Fideos Corbatitas', 0.40, 0.90, 150),
    (1, 'Fideos Tallarines', 0.55, 1.10, 80),
    (1, 'Fideos Penne', 0.60, 1.20, 60),
    (1, 'Fideos Sopa', 0.30, 0.70, 120),
    (2, 'Pollo Entero', 3.00, 5.00, 30),
    (2, 'Pechuga de Pollo', 2.50, 4.50, 50),
    (2, 'Carne de Cerdo (Costillas)', 4.00, 6.50, 40),
    (2, 'Carne de Cerdo (Pernil)', 3.50, 5.50, 20),
    (3, 'Jamón de Cerdo', 2.00, 3.50, 25),
    (3, 'Longaniza', 1.80, 3.00, 45),
    (3, 'Salchicha', 1.50, 2.50, 75),
    (4, 'Crema Fresca', 1.00, 2.00, 90),
    (4, 'Queso Mozzarella', 1.20, 2.50, 70),
    (4, 'Queso Cheddar', 1.30, 2.80, 65),
    (5, 'Chocolates de Leche', 0.80, 1.50, 150),
    (5, 'Dulces de Frutas', 0.70, 1.30, 200),
    (5, 'Galletas de Chocolate', 0.60, 1.20, 180),
    (6, 'Agua Mineral', 0.25, 0.50, 500),
    (6, 'Agua Saborizada', 0.30, 0.60, 300),
    (7, 'Gatorade', 1.00, 1.80, 120),
    (7, 'Revive', 0.90, 1.50, 140),
    (7, 'Bebida Energética', 1.50, 2.50, 100),
    (7, 'Refresco de Naranja', 0.80, 1.40, 250),
    (7, 'Refresco de Cola', 0.75, 1.30, 200),
    (7, 'Refresco de Limón', 0.70, 1.20, 220),
    (7, 'Bebida de Té Helado', 1.20, 1.80, 160),
    (7, 'Jugo de Manzana', 0.85, 1.50, 180),
    (7, 'Jugo de Piña', 0.90, 1.60, 140);

INSERT INTO PRODUCTO (ID_CATEGORIA, DESCRIPCION, COSTO, PRECIO_VENTA, INVENTARIO)
VALUES 
    (1, 'Fideos Rizados', 0.65, 1.30, 90),
    (1, 'Fideos de Arroz', 0.70, 1.40, 85),
    (1, 'Fideos Instantáneos', 0.45, 0.85, 100),
    (1, 'Fideos Udon', 0.75, 1.50, 60),
    (1, 'Fideos de Soba', 0.80, 1.60, 70),
    (2, 'Pechuga de Pollo Marinado', 2.80, 4.80, 55),
    (2, 'Carne de Cerdo Picada', 3.00, 5.00, 45),
    (2, 'Carne de Res (Corte para Asar)', 4.50, 7.00, 35),
    (2, 'Pollo en Filetes', 3.20, 5.20, 50),
    (3, 'Salami', 2.50, 4.00, 30),
    (3, 'Chorizo', 1.90, 3.30, 40),
    (4, 'Yogur Natural', 0.90, 1.70, 100),
    (4, 'Queso Feta', 1.40, 2.60, 70),
    (4, 'Leche Entera', 0.80, 1.50, 200),
    (5, 'Caramelos', 0.30, 0.60, 300),
    (5, 'Chicles', 0.25, 0.50, 350),
    (5, 'Galletas de Vainilla', 0.65, 1.20, 90),
    (6, 'Agua con Gas', 0.40, 0.80, 250),
    (6, 'Agua de Coco', 1.00, 1.80, 150),
    (7, 'Refresco de Manzana', 0.80, 1.40, 200),
    (7, 'Bebida Isotónica', 1.20, 2.00, 110);

INSERT INTO TIPO_COBRO (ID_TIPO_COBRO, DESCRIPCION)
VALUES 
    (1, 'Tarjeta de Cr�dito'),
    (2, 'Tarjeta de D�bito'),
    (3, 'Efectivo');

INSERT INTO CLIENTE (NOMBRE, TELEFONO, DIRECCION, NIT)
VALUES 
    ('Luis Lopez Rodas', '+502-1234-5678', 'Avenida Reforma, Zona 9', '12345678-9'),
    ('Mar�a P�rez G�mez', '+502-2345-6789', 'Calle 10, Zona 1', '23456789-0'),
    ('Carlos Mart�nez Ruiz', '+502-3456-7890', 'Boulevard Los Pr�ceres, Zona 10', '34567890-1'),
    ('Ana Morales Castillo', '+502-4567-8901', 'Calle del �rbol, Villa Nueva', '45678901-2'),
    ('Jos� L�pez M�ndez', '+502-5678-9012', 'Avenida Las Am�ricas, Zona 13', '56789012-3'),
    ('Sof�a Hern�ndez Cifuentes', '+502-6789-0123', 'Calle del Bosque, Zona 7', '67890123-4'),
    ('Fernando Ram�rez Salazar', '+502-7890-1234', 'Calle de la Paz, San Marcos', '78901234-5'),
    ('Valeria D�az Reyes', '+502-8901-2345', 'Avenida de los Abetos, Mixco', '89012345-6'),
    ('David Castillo Alvarado', '+502-9012-3456', 'Calle de la Libertad, Santa Catarina Pinula', '90123456-7'),
    ('Claudia Salguero Serrano', '+502-0123-4567', 'Calle del Sol, Guatemala', '01234567-8'),
    ('Javier Mart�nez Becerra', '+502-1234-5678', 'Calle de la Esperanza, San Jos�', '12345679-0'),
    ('Laura Ramos Soto', '+502-2345-6789', 'Avenida San Juan, Escuintla', '23456780-1'),
    ('Eduardo Morales Cabrera', '+502-3456-7890', 'Calle de la Independencia, Quetzaltenango', '34567891-2'),
    ('Isabel Garc�a G�mez', '+502-4567-8901', 'Boulevard El Naranjo, Villa Nueva', '45678902-3'),
    ('Diego Fern�ndez Palacios', '+502-5678-9012', 'Calle de la Paz, Guatemala', '56789013-4'),
    ('Nadia V�zquez Santos', '+502-6789-0123', 'Avenida de la Reforma, San Miguel Petapa', '67890124-5'),
    ('Andr�s L�pez Qui�ones', '+502-7890-1234', 'Calle del Comercio, Chimaltenango', '78901235-6'),
    ('Patricia C�rdova Mej�a', '+502-8901-2345', 'Calle de la Amistad, Retalhuleu', '89012346-7'),
    ('Ra�l Aguilar Figueroa', '+502-9012-3456', 'Avenida El Caminante, Ciudad de Guatemala', '90123457-8'),
    ('Carmen Ruiz Mart�nez', '+502-0123-4567', 'Calle del R�o, Guatemala', '01234568-9'),
    ('Guillermo Ortega Pineda', '+502-1234-5678', 'Calle de la Luz, Santa Luc�a Milpas Altas', '12345680-0'),
    ('Paola Calder�n Sol�s', '+502-2345-6789', 'Avenida de los �ngeles, Guatemala', '23456781-1'),
    ('Mario Sandoval Cu�llar', '+502-3456-7890', 'Calle del Lago, San Pedro Sacatep�quez', '34567892-2'),
    ('Silvia Valenzuela N��ez', '+502-4567-8901', 'Calle de los �rboles, San Juan Sacatep�quez', '45678903-3'),
    ('Hugo Bonilla Porras', '+502-5678-9012', 'Avenida de la Paz, Guatemala', '56789014-4'),
    ('Luisa Mena Aguirre', '+502-6789-0123', 'Calle de los Maestros, Huehuetenango', '67890125-5'),
    ('Jorge R�os Rojas', '+502-7890-1234', 'Calle de la Integraci�n, Jalapa', '78901236-6'),
    ('Elena M�ndez Salas', '+502-8901-2345', 'Avenida de los Cerezos, Guatemala', '89012347-7'),
    ('Leonardo Silva Herrera', '+502-9012-3456', 'Calle de la Libertad, San Marcos', '90123458-8'),
    ('Natalia Estrada L�pez', '+502-0123-4567', 'Calle de los Sue�os, San Jos�', '01234569-9');

	INSERT INTO USUARIO VALUES ('admin1','Collect1');
