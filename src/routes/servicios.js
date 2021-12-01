const express = require('express');
const router = express.Router();

const pool = require('../database');

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

//Listar los servicios al cliente y admin

//-------------------PISCINA-------------------------------------
router.get('/piscina', async (req, res) => {
    const servicios_piscina = await pool.query('SELECT * FROM servicio_piscina');

    if (req.user.rolAdministrador) {
        res.render('servicios/piscina/list_admin', { servicios_piscina });
    } else {
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
    console.log('hola');
    
    await pool.query('UPDATE servicio_piscina SET ? WHERE idservicio_piscina = ?', [newServicio, id]);

    req.flash('success', 'Servicio editado');

    res.redirect('/servicios/piscina');
});

module.exports = router;