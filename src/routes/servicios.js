const express = require('express');
const router = express.Router();

const pool = require('../database');

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

//Listar los servicios al cliente y admin

//-------------------PISCINA-------------------------------------

//Mostrar los servicios
router.get('/piscina', async (req, res) => {

    const servicios_piscina = await pool.query('SELECT * FROM servicio_piscina');

    if (req.user.rolAdministrador) {
        res.render('servicios/piscina/list_admin', { servicios_piscina });
    } 
    if (req.user.rolCliente) {
        res.render('servicios/piscina/list', { servicios_piscina });
    }
});


//Añadir servicio  
//Solo el administardor puede añadirlos

router.get('/piscina/add', (req, res) => {
    res.render('servicios/piscina/add');
});

router.post('/piscina/add', async (req, res) => {
    const { nombre, precio, descripcion } = req.body;

    const newServicio = {
        nombre,
        precio,
        descripcion
    }

    await pool.query('INSERT INTO servicio_piscina SET ?', [newServicio]);

    req.flash('success', 'Servicio agregado');

    res.redirect('/servicios/piscina');
});

router.get('/piscina/eliminar/:id', async (req, res) => {
    const { id } = req.params;
    console.log(id);

    await pool.query('DELETE FROM servicio_piscina WHERE idservicio_piscina = ?', [id]);

    req.flash('success', 'Servicio eliminado');
    res.redirect('/servicios/piscina');
});

//Editar servicio
router.get('/piscina/editar/:id', async (req, res) => {
    const { id } = req.params;

    const servicio = await pool.query('SELECT * FROM servicio_piscina WHERE idservicio_piscina = ?', [id]);
    console.log('hola');
    console.log(servicio[0]);
    res.render('servicios/piscina/edit', {servicio: servicio[0]});
});
router.post('/piscina/editar/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, precio, descripcion } = req.body;
    const newServicio = {
        nombre,
        precio,
        descripcion
    };
    
    await pool.query('UPDATE servicio_piscina SET ? WHERE idservicio_piscina = ?', [newServicio, id]);

    req.flash('success', 'Servicio editado');

    res.redirect('/servicios/piscina');
});

//Contratar servicio


router.get('/', async (req, res) => {
    const piscinas = await pool.query('SELECT * FROM piscina WHERE idUser = ?', [req.user.idUser]);

    for (var i = 0; i < piscinas.length; i++) {
        if (piscinas[i].idDireccion == null) {
            piscinas[i].direccion = true;
        }
    }
    res.render('piscina/list', { piscinas });
});



router.get('/piscina/contratar/:idservicio_piscina', async (req, res) => {
    const { idservicio_piscina } = req.params;

    const servicio_contratar = await pool.query('SELECT * FROM servicio_piscina WHERE idservicio_piscina = ?', [idservicio_piscina]);

    const contratar = servicio_contratar[0];

    const piscinas_cliente = await pool.query('SELECT idpiscina, nombre FROM piscina WHERE idUser = ?', [req.user.idUser]);

    res.render('servicios/piscina/contratar', { contratar, piscinas_cliente });
});


router.post('/piscina/contratar/:idservicio_piscina', async (req, res) => {
    const { idservicio_piscina } = req.params;

    const { nombre, dia, hora} = req.body;

    const fecha = {
        dia, 
        hora
    };

    const servicio_contratar = await pool.query('SELECT * FROM servicio_piscina WHERE idservicio_piscina = ?', [idservicio_piscina]);

    const contratar = servicio_contratar[0];

    const resultQuery = await pool.query('SELECT * FROM piscina WHERE nombre = ?', [nombre]);

    
    piscina = resultQuery[0];

    var precio_total = piscina.volumen * contratar.precio;
    piscina.precio_total = precio_total.toFixed(2);

    if (piscina.idDireccion == null) {
        piscina.direccion = true;
    }

    res.render('servicios/piscina/confirmar', { contratar, piscina, fecha });

});

router.post('/piscina/confirmar/:idpiscina/:idServicio_piscina/:precio/:dia/:hora', async (req, res) => {
    const { idpiscina, idServicio_piscina, precio, dia, hora } = req.params;

    const newMantenimiento = {
        idpiscina, 
        idServicio_piscina,
        precio,
        estado: 1, 
        dia, 
        hora
    };

    await pool.query('INSERT INTO mantenimiento_piscina SET ?', [newMantenimiento]);

    res.redirect('/servicios/misservicios');

});

//mostrar los sevicios contratados

router.get('/misservicios', async (req, res) => {

    const misServicios = await pool.query('SELECT piscina.idpiscina AS idpiscina, piscina.nombre AS nombre_piscina, piscina.tipo_piscina AS tipo_piscina, piscina.volumen AS piscina_volumen, piscina.idDireccion AS idDireccion, mantenimiento_piscina.idMantenimiento_piscina AS idMantenimiento_piscina, mantenimiento_piscina.precio AS precio, mantenimiento_piscina.estado AS estado_servicio, mantenimiento_piscina.dia AS dia, mantenimiento_piscina.hora AS hora, servicio_piscina.idServicio_piscina AS idServicio_piscina, servicio_piscina.nombre AS nombre_servicio, servicio_piscina.descripcion AS descripcion_servicio FROM piscina INNER JOIN mantenimiento_piscina ON piscina.idpiscina = mantenimiento_piscina.idpiscina INNER JOIN servicio_piscina ON mantenimiento_piscina.idServicio_piscina = servicio_piscina.idServicio_piscina WHERE piscina.idUser = ?', [req.user.idUser]);

    res.render('servicios/piscina/misServicios', { misServicios });
});

//Eliminar Servicio

router.get('/piscina/servicio/cancelar/:idMantenimiento_piscina', async (req, res) => {
    const { idMantenimiento_piscina } = req.params;

    await pool.query('DELETE FROM mantenimiento_piscina WHERE idMantenimiento_piscina = ?', [idMantenimiento_piscina]);

    res.redirect('/servicios/misservicios');
});

module.exports = router;

