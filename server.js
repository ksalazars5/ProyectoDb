const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const sql = require('mssql');
const app = express();

// Configuración de conexión a la base de datos
const config = {
    user: 'sa',
    password: 'Collect1',
    server: 'localhost', // o 'localhost\\NombreInstancia' si es necesario
    port: 1433,
    database: 'RINCONGT',
    options: {
        encrypt: true,
        trustServerCertificate: true,
        requestTimeout: 30000
    }
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public')); // Middleware para servir archivos estáticos

// Conexión inicial
sql.connect(config)
    .then(() => console.log('Conectado a la base de datos'))
    .catch(err => console.error('Error al conectar a la base de datos:', err));
// Ruta para manejar el login
app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        let pool = await sql.connect(config);
        const result = await pool.request()
            .input('username', sql.VarChar, username)
            .input('password', sql.VarChar, password)
            .query('SELECT * FROM USUARIO WHERE ID_USUARIO = @username AND PASS = @password');

        if (result.recordset.length > 0) {
            res.redirect('/success'); // Redirige a la página de éxito después de login exitoso
        } else {
            res.send('Usuario o contraseña incorrectos');
        }
        await pool.close();
    } catch (err) {
        console.error('Error al conectar a la base de datos:', err.message);
        res.send('Error en el servidor');
    }
});
// Función para agregar un nuevo cliente utilizando el SP
async function agregarCliente(nombre, telefono, direccion, nit) {
    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('NOMBRE', sql.VarChar, nombre)
            .input('TELEFONO', sql.VarChar, telefono)
            .input('DIRECCION', sql.VarChar, direccion)
            .input('NIT', sql.VarChar, nit ? nit : null)  // Si NIT es opcional
            .execute('spAgregarCliente');  // Ejecutar el SP
            
        return result;  // Devolver el resultado
    } catch (error) {
        console.error('Error al agregar cliente:', error);
        throw error;
    }
}

// Ruta para agregar cliente
app.post('/agregar-cliente', async (req, res) => {
    const { nombre, telefono, direccion, nit } = req.body;  // Ya no req.body directamente, sino el objeto JSON
    console.log('Datos recibidos:', { nombre, telefono, direccion, nit });

    try {
        await agregarCliente(nombre, telefono, direccion, nit);
        res.status(201).json({ success: true, message: 'Cliente agregado con éxito' });  // Responder en formato JSON
    } catch (error) {
        console.error('Error al agregar el cliente:', error);
        res.status(500).json({ success: false, message: 'Error al agregar el cliente: ' + error.message });
    }
});

// Ruta para obtener todos los clientes
app.get('/clientes', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        const result = await pool.request().query('SELECT * FROM CLIENTE');
        res.json(result.recordset);
        await pool.close();
    } catch (error) {
        console.error('Error al recuperar clientes:', error);
        res.status(500).json({ error: 'Error al recuperar clientes' });
    }
});

//clientes por nit
app.get('/clientes/nit/:nit', async (req, res) => {
    const nit = req.params.nit;
    console.log('Buscando cliente con NIT:', nit); // Agrega esta línea
    let pool;
    try {
        pool = await sql.connect(config);
        const result = await pool.request()
            .input('NIT', sql.VarChar, nit)
            .query('SELECT * FROM CLIENTE WHERE NIT = @NIT');

        console.log('Resultado de la base de datos:', result.recordset); // Agrega esta línea

        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).json({ error: 'Cliente no encontrado' });
        }
    } catch (error) {
        console.error('Error al buscar el cliente:', error);
        res.status(500).json({ error: 'Error al buscar el cliente' });
    } finally {
        if (pool) {
            await pool.close();
        }
    }
});

// Rutas para obtener productos
// Rutas para obtener productos
app.get('/productos', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        const result = await pool.request().query('SELECT * FROM PRODUCTO');
        res.json(result.recordset);
        await pool.close(); 
    } catch (err) {
        console.error('Error al obtener productos:', err.message);
        res.status(500).send('Error al obtener productos');
    }
});

// Rutas para agregar y obtener productos utilizando el SP
app.post('/agregarProducto', async (req, res) => {
    const { id_categoria, descripcion, costo, precioVenta, inventario } = req.body; // Asegúrate de incluir inventario
    let pool;
    try {
        pool = await sql.connect(config);
        await pool.request()
            .input('ID_CATEGORIA', sql.Int, id_categoria)
            .input('DESCRIPCION', sql.VarChar(50), descripcion) // Verifica que aquí esté el tamaño correcto
            .input('COSTO', sql.Decimal(10, 2), costo)
            .input('PRECIO_VENTA', sql.Decimal(10, 2), precioVenta)
            .input('INVENTARIO', sql.Int, inventario) // Asegúrate de que esta línea esté presente
            .execute('spAgregarProducto');

        res.json({ success: true });
    } catch (err) {
        console.error('Error al agregar producto:', err);
        res.status(500).json({ success: false, message: 'Error al agregar producto' });
    } finally {
        if (pool) {
            await pool.close();
        }
    }
});



// Rutas para agregar y obtener proveedores utilizando el SP
app.post('/agregarProveedor', async (req, res) => {
    const { descripcion, telefono, direccion } = req.body;
    try {
        let pool = await sql.connect(config);
        await pool.request()
            .input('descripcion', sql.VarChar, descripcion)
            .input('telefono', sql.VarChar, telefono)
            .input('direccion', sql.VarChar, direccion)
            .execute('sp_AgregarProveedor'); // Ejecuta el Stored Procedure

        res.json({ success: true });
        await pool.close(); 
    } catch (err) {
        console.error(err);
        return res.json({ success: false });
    }
});
// Ruta para obtener proveedores
app.get('/proveedores', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        const result = await pool.request().query('SELECT * FROM PROVEEDOR');
        res.json(result.recordset); 
        await pool.close(); 
    } catch (err) {
        console.error('Error al obtener proveedores:', err.message);
        res.status(500).send('Error al obtener proveedores');
    }
});

// Ruta para la página de éxito
app.get('/success', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'success.html'));
});

// Rutas para la interfaz de despacho de productos
app.get('/factura', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'factura.html'));
});
// Ruta para guardar la compra y los productos
app.post('/compras', async (req, res) => {
    const { cliente, productos, total } = req.body;

    try {
        const pool = await sql.connect(config);
        
        // Insertar compra
        const resultCompra = await pool.request()
        .input('ID_CLIENTE', sql.Int, cliente.ID_CLIENTE)
        .input('TOTAL', sql.Decimal(10, 2), total)
        .query('INSERT INTO COMPRA (ID_CLIENTE, TOTAL) OUTPUT INSERTED.ID_COMPRA VALUES (@ID_CLIENTE, @TOTAL)');

        const idCompra = resultCompra.recordset[0].ID_COMPRA;
        
        // Insertar productos de la compra
        for (const producto of productos) {
            await pool.request()
                .input('ID_COMPRA', sql.Int, idCompra)
                .input('ID_PRODUCTO', sql.Int, producto.ID_PRODUCTO)
                .input('CANTIDAD', sql.Int, producto.cantidad)
                .input('PRECIO_UNITARIO', sql.Decimal(10, 2), producto.PRECIO_VENTA)
                .query('INSERT INTO DETALLE_COMPRA (ID_COMPRA, ID_PRODUCTO, CANTIDAD, PRECIO_UNITARIO) VALUES (@ID_COMPRA, @ID_PRODUCTO, @CANTIDAD, @PRECIO_UNITARIO)');
        }

        res.status(200).send('Compra registrada con éxito');
    } catch (error) {
        console.error('Error al registrar la compra:', error);
        res.status(500).send(`Error al registrar la compra: ${error.message}`);

    }
});
//Buscar clientes por nit
app.get('/buscar-sugerencias-clientes', async (req, res) => {
    const { nit } = req.query;
    if (!nit) {
        return res.status(400).json({ error: 'El parámetro "nit" es requerido.' });
    }

    try {
        await sql.connect(config);
        const sugerencias = await sql.query`SELECT TOP 10 NIT, NOMBRE FROM CLIENTE WHERE NIT LIKE ${nit + '%'} ORDER BY NIT ASC`;
        console.log('Sugerencias obtenidas desde la base de datos:', sugerencias.recordset);
        res.json(sugerencias.recordset); // Enviar las sugerencias al frontend como JSON
    } catch (error) {
        console.error('Error al buscar sugerencias de clientes:', error);
        res.status(500).json({ error: 'Error al buscar sugerencias de clientes.' });
    } finally {
        sql.close();
    }
});

    


// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});


// FACTRA
// Función para agregar una nueva factura
// Función para agregar factura y devolver el ID_FACTURA generado
// Función para agregar una nueva factura


async function agregarDetalleFactura(idFactura, idProducto, cantidad, subtotal, precioUnitario) {
    try {
        let pool = await sql.connect(config);
        await pool.request()
            .input('ID_FACTURA', sql.Int, idFactura)
            .input('ID_PRODUCTO', sql.Int, idProducto)
            .input('CANTIDAD', sql.Int, cantidad)
            .input('SUBTOTAL', sql.Decimal(10, 2), subtotal)
            .input('PRECIO_UNITARIO', sql.Decimal(10, 2), precioUnitario)
            .query('INSERT INTO DETALLE_FACTURA (ID_FACTURA, ID_PRODUCTO, CANTIDAD, SUBTOTAL, PRECIO_UNITARIO) VALUES (@ID_FACTURA, @ID_PRODUCTO, @CANTIDAD, @SUBTOTAL, @PRECIO_UNITARIO)');
        
        console.log(`Detalle agregado correctamente: Factura ID ${idFactura}, Producto ID ${idProducto}`);
    } catch (error) {
        console.error('Error al agregar detalle de factura:', error);
        throw error;
    }
}
// Ruta para agregar detalles de la factura
app.post('/agregar-detalle-factura', async (req, res) => {
    const { idFactura, idProducto, cantidad, subtotal, precioUnitario } = req.body;
    console.log('Datos recibidos para detalle de factura:', { idFactura, idProducto, cantidad, subtotal, precioUnitario });

    try {
        await agregarDetalleFactura(idFactura, idProducto, cantidad, subtotal, precioUnitario);
        res.status(201).json({ success: true, message: 'Detalle de factura agregado con éxito' });
    } catch (error) {
        console.error('Error al agregar el detalle de la factura:', error);
        res.status(500).json({ success: false, message: 'Error al agregar el detalle de la factura: ' + error.message });
    }
});
async function agregarFactura(idCliente, totalFactura, fecha) {
    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('ID_CLIENTE', sql.Int, idCliente)
            .input('TOTAL_FACTURA', sql.Decimal(10, 2), totalFactura)
            .input('FECHA', sql.Date, fecha)
            .query('INSERT INTO FACTURA (ID_CLIENTE, TOTAL_FACTURA, FECHA) VALUES (@ID_CLIENTE, @TOTAL_FACTURA, @FECHA); SELECT SCOPE_IDENTITY() AS ID_FACTURA;');

        // Obtener el ID de la factura generada
        const idFacturaGenerada = result.recordset[0].ID_FACTURA;
        return idFacturaGenerada; // Retorna el ID de la factura
    } catch (error) {
        console.error('Error al agregar factura:', error);
        throw error;
    }
}
// Ruta para agregar una factura
app.post('/agregar-factura', async (req, res) => {
    const { idCliente, totalFactura, fecha } = req.body;
    console.log('Datos recibidos para factura:', { idCliente, totalFactura, fecha });

    try {
        const idFactura = await agregarFactura(idCliente, totalFactura, fecha);
        res.status(201).json({ success: true, message: 'Factura agregada con éxito', idFactura });
    } catch (error) {
        console.error('Error al agregar la factura:', error);
        res.status(500).json({ success: false, message: 'Error al agregar la factura: ' + error.message });
    }
});
// Ruta para procesar el pago
app.post('/procesarPago', async (req, res) => {
    const { metodoPago, total, numeroTarjeta, fechaExpiracion, codigoSeguridad, fechaCobro } = req.body;
    let idTipoCobro = metodoPago === 'efectivo' ? 1 : 2; // 1 para efectivo, 2 para tarjeta

    try {
        // Conectar a la base de datos
        await sql.connect(config);

        // Consulta SQL para insertar el pago
        const query = `
        INSERT INTO COBROS (ID_TIPO_COBRO, METODO_PAGO, TOTAL, NUMERO_TARJETA, FECHA_EXPIRACION, CODIGO_SEGURIDAD, FECHA_COBRO)
        VALUES (@idTipoCobro, @metodoPago, @total, @numeroTarjeta, @fechaExpiracion, @codigoSeguridad, @fechaCobro);
        SELECT SCOPE_IDENTITY() AS ID_COBRO;
        `;

        // Ejecutar la consulta usando parámetros
        const request = new sql.Request();
        request.input('idTipoCobro', sql.Int, idTipoCobro);
        request.input('metodoPago', sql.VarChar(50), metodoPago);
        request.input('total', sql.Decimal(10, 2), total);
        request.input('numeroTarjeta', sql.VarChar(50), numeroTarjeta || null);
        request.input('fechaExpiracion', sql.Date, fechaExpiracion); // Asegúrate de que la fecha tenga el formato correcto
        request.input('codigoSeguridad', sql.VarChar(10), codigoSeguridad || null);
        request.input('fechaCobro', sql.Date, fechaCobro);

        const result = await request.query(query);

        // Enviar la respuesta con el ID_COBRO
        res.status(200).json({ success: true, idCobro: result.recordset[0].ID_COBRO });
    } catch (error) {
        console.error('Error en la consulta a la base de datos:', error);
        res.status(500).json({ success: false, message: 'Error al procesar el pago.', error: error.message });
    } finally {
        // Cerrar la conexión
        await sql.close();
    }
});


// Método para registrar una devolución
// Obtener todas las facturas
// Suponiendo que estás usando Express

// Configuración del servidor
// Endpoint para procesar devoluciones
// Endpoint para obtener las devoluciones
app.post('/devolucion', async (req, res) => {
    const { idFactura, idProducto, cantidadDevuelta, razon, descripcionProducto } = req.body;

    try {
        const pool = await sql.connect(config);

        // Agregar nueva devolución
        await pool.request()
            .input('ID_FACTURA', sql.Int, idFactura)
            .input('ID_PRODUCTO', sql.Int, idProducto) // Agregar ID_PRODUCTO
            .input('CANTIDAD_DEVUELTA', sql.Int, cantidadDevuelta)
            .input('RAZON', sql.VarChar, razon)
            .input('DESCRIPCION_PRODUCTO', sql.VarChar, descripcionProducto) // Agregar descripción
            .input('FECHA_DEVOLUCION', sql.Date, new Date())
            .query('INSERT INTO DEVOLUCION (ID_FACTURA, ID_PRODUCTO, CANTIDAD_DEVUELTA, RAZON, DESCRIPCION_PRODUCTO, FECHA_DEVOLUCION) VALUES (@ID_FACTURA, @ID_PRODUCTO, @CANTIDAD_DEVUELTA, @RAZON, @DESCRIPCION_PRODUCTO, @FECHA_DEVOLUCION)');

        res.status(201).send('Devolución registrada exitosamente.');
    } catch (error) {
        console.error('Error al registrar la devolución:', error);
        res.status(500).send('Error al registrar la devolución');
    }
});

app.get('/devoluciones', async (req, res) => {
    try {
        const pool = await sql.connect(config);
        const result = await pool.request().query('SELECT * FROM DEVOLUCION');

        res.json(result.recordset);
    } catch (error) {
        console.error('Error al obtener devoluciones:', error);
        res.status(500).send('Error al obtener devoluciones');
    }
});












