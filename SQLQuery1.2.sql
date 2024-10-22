USE RINCONGT;

CREATE PROCEDURE spAgregarCliente
    @NOMBRE VARCHAR(50),
    @TELEFONO VARCHAR(50),
    @DIRECCION VARCHAR(50),
    @NIT VARCHAR(50) = NULL  -- NIT es opcional, puedes ajustar esto según tu lógica
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO CLIENTE (NOMBRE, TELEFONO, DIRECCION, NIT)
    VALUES (@NOMBRE, @TELEFONO, @DIRECCION, @NIT);
    
    -- Puedes devolver el ID del cliente insertado si es necesario
    SELECT SCOPE_IDENTITY() AS ID_CLIENTE;
END;

SELECT * FROM CATEGORIA_PRODUCTO;
SELECT * FROM CLIENTE;
SELECT * FROM COBROS;
SELECT * FROM DETALLE_FACTURA;
SELECT * FROM DEVOLUCIONES;
SELECT * FROM FACTURA;
SELECT * FROM PRODUCTO;
SELECT * FROM PROVEEDOR;

INSERT INTO FACTURA VALUES (1,250.20,'10/09/2024');

ALTER TABLE DETALLE_FACTURA
ADD PRECIO_UNITARIO DECIMAL(10, 2) NOT NULL;


CREATE PROCEDURE spAgregarProducto
    @ID_CATEGORIA INT,
    @DESCRIPCION VARCHAR(50),
    @COSTO DECIMAL(10, 2),
    @PRECIO_VENTA DECIMAL(10, 2)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insertar un nuevo producto en la tabla PRODUCTO
    INSERT INTO PRODUCTO (ID_CATEGORIA, DESCRIPCION, COSTO, PRECIO_VENTA)
    VALUES (@ID_CATEGORIA, @DESCRIPCION, @COSTO, @PRECIO_VENTA);
    
    -- Opcionalmente devolver el ID del producto insertado
    SELECT SCOPE_IDENTITY() AS ID_PRODUCTO;
END;

CREATE PROCEDURE sp_AgregarProveedor
    @descripcion VARCHAR(50),
    @telefono VARCHAR(50) = NULL,  -- Este campo es opcional
    @direccion VARCHAR(50) = NULL  -- Este campo es opcional
AS
BEGIN
    -- Manejo de errores
    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;
        
        -- Inserción del nuevo proveedor en la tabla PROVEEDOR
        INSERT INTO PROVEEDOR (DESCRIPCION, TELEFONO, DIRECCION)
        VALUES (@descripcion, @telefono, @direccion);
        
        -- Confirmar la transacción
        COMMIT TRANSACTION;
        
        -- Mensaje de éxito
        PRINT 'Proveedor agregado exitosamente';
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;
        
        -- Capturar el error y devolver el mensaje
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        PRINT 'Error al agregar proveedor: ' + @ErrorMessage;
    END CATCH
END;

EXEC sp_AgregarProveedor @descripcion = 'Proveedor X', @telefono = '123456789', @direccion = 'Calle X';

