USE RINCONGT;

-- �ndice en la columna NIT de la tabla CLIENTE para b�squedas r�pidas por NIT
CREATE INDEX idx_cliente_nit ON CLIENTE(NIT);

-- �ndice en la columna DESCRIPCION de la tabla PRODUCTO para b�squedas r�pidas de productos por descripci�n
CREATE INDEX idx_producto_descripcion ON PRODUCTO(DESCRIPCION);

-- �ndice en la columna ID_FACTURA de la tabla COBRO para mejorar las b�squedas por factura asociada
CREATE INDEX idx_cobros_id_factura ON COBROS(ID_FACTURA);

-- �ndice en la columna ID_CLIENTE de la tabla FACTURA para consultas frecuentes por cliente
CREATE INDEX idx_factura_id_cliente ON FACTURA(ID_CLIENTE);

-- �ndice en la columna TELEFONO de la tabla CLIENTE para mejorar la b�squeda por n�mero de tel�fono
CREATE INDEX idx_cliente_telefono ON CLIENTE(TELEFONO);

-- �ndice en la columna ID_PRODUCTO de la tabla DETALLE_FACTURA para mejorar la b�squeda de productos dentro de los detalles de factura
CREATE INDEX idx_detalle_factura_id_producto ON DETALLE_FACTURA(ID_PRODUCTO);

-- �ndice en la columna ID_PRODUCTO de la tabla DEVOLUCIONES para mejorar las b�squedas relacionadas con productos devueltos
CREATE INDEX idx_devoluciones_id_producto ON DEVOLUCIONES(ID_PRODUCTO);

SELECT * FROM CLIENTE;
SELECT * FROM FACTURA;
SELECT * FROM DETALLE_FACTURA;