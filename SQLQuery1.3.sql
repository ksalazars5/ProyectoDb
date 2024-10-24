USE RINCONGT;
SELECT * FROM CLIENTE;

DROP PROCEDURE IF EXISTS spAgregarFactura;
GO

CREATE PROCEDURE spAgregarFactura
    @ID_CLIENTE INT,
    @TOTAL_FACTURA DECIMAL(10,2),
    @FECHA DATE,
    @PRODUCTOS TipoProducto READONLY -- Usando el tipo de tabla definido anteriormente
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_FACTURA INT;

    -- Insertar la factura
    INSERT INTO FACTURA (ID_CLIENTE, TOTAL_FACTURA, FECHA)
    VALUES (@ID_CLIENTE, @TOTAL_FACTURA, @FECHA);

    -- Obtener el ID de la factura reci�n creada
    SET @ID_FACTURA = SCOPE_IDENTITY(); 

    -- Insertar los detalles de la factura
    INSERT INTO DETALLE_FACTURA (ID_FACTURA, ID_PRODUCTO, CANTIDAD, SUBTOTAL, PRECIO_UNITARIO)
    SELECT @ID_FACTURA, ID_PRODUCTO, CANTIDAD, SUBTOTAL, PRECIO_UNITARIO
    FROM @PRODUCTOS;

    -- Retornar el ID de la factura
    SELECT @ID_FACTURA AS ID_FACTURA;
END;
GO
CREATE PROCEDURE spAgregarProducto
    @ID_CATEGORIA INT,
    @DESCRIPCION VARCHAR(50),
    @COSTO DECIMAL(10, 2),
    @PRECIO_VENTA DECIMAL(10, 2),
    @INVENTARIO INT  -- Asegúrate de que este parámetro esté aquí
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insertar un nuevo producto en la tabla PRODUCTO
    INSERT INTO PRODUCTO (ID_CATEGORIA, DESCRIPCION, COSTO, PRECIO_VENTA, INVENTARIO)
    VALUES (@ID_CATEGORIA, @DESCRIPCION, @COSTO, @PRECIO_VENTA, @INVENTARIO);
    
    -- Opcionalmente devolver el ID del producto insertado
    SELECT SCOPE_IDENTITY() AS ID_PRODUCTO;
END;