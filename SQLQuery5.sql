USE RINCONGT;

-- Índice en la columna NIT de la tabla CLIENTE para búsquedas rápidas por NIT
CREATE INDEX idx_cliente_nit ON CLIENTE(NIT);

-- Índice en la columna DESCRIPCION de la tabla PRODUCTO para búsquedas rápidas de productos por descripción
CREATE INDEX idx_producto_descripcion ON PRODUCTO(DESCRIPCION);

-- Índice en la columna ID_FACTURA de la tabla COBRO para mejorar las búsquedas por factura asociada
CREATE INDEX idx_cobros_id_factura ON COBROS(ID_FACTURA);

-- Índice en la columna ID_CLIENTE de la tabla FACTURA para consultas frecuentes por cliente
CREATE INDEX idx_factura_id_cliente ON FACTURA(ID_CLIENTE);

-- Índice en la columna TELEFONO de la tabla CLIENTE para mejorar la búsqueda por número de teléfono
CREATE INDEX idx_cliente_telefono ON CLIENTE(TELEFONO);

-- Índice en la columna ID_PRODUCTO de la tabla DETALLE_FACTURA para mejorar la búsqueda de productos dentro de los detalles de factura
CREATE INDEX idx_detalle_factura_id_producto ON DETALLE_FACTURA(ID_PRODUCTO);

-- Índice en la columna ID_PRODUCTO de la tabla DEVOLUCIONES para mejorar las búsquedas relacionadas con productos devueltos
CREATE INDEX idx_devoluciones_id_producto ON DEVOLUCIONES(ID_PRODUCTO);

SELECT * FROM CLIENTE;
SELECT * FROM FACTURA;
SELECT * FROM DETALLE_FACTURA;