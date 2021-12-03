const express = require('express');
const router = express.Router();

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

const pool = require('../database');

//mostrar piscinas segun el usuario
router.get('/', isLoggedIn, async (req, res) => {
    const piscinas = await pool.query('SELECT * FROM piscina WHERE idUser = ?', [req.user.idUser]);

    for (var i = 0; i < piscinas.length; i++) {
        if (piscinas[i].idDireccion == null) {
            piscinas[i].direccion = true;
        }
    }
    res.render('piscina/list', { piscinas });
});

//Añadir una piscina aun no se guarda su direccion
router.get('/add', (req, res) => {
    res.render('piscina/add');
});

router.post('/add', async (req, res) => {
    const { nombre, tipo_piscina, volumen } = req.body;

    const newPiscina = {
        nombre,
        tipo_piscina,
        volumen,
        iduser: req.user.idUser
    };

    await pool.query('INSERT INTO piscina SET ?', [newPiscina]);

    req.flash('success', 'Piscina agragada, se require agregarle una direccion para poder contratar un servicio');

    res.redirect('/home');
});

//Eliminar piscina
router.get('/delete/:id', async (req, res) => {
    const { id } =  req.params;

    await pool.query('DELETE FROM piscina WHERE idpiscina = ?', [id]);

    req.flash('success', 'Piscina eliminada');
    res.redirect('/piscina');
});

//Editar piscina
router.get('/edit/:id', async (req, res) => {
    const { id } = req.params;

    const piscinas = await pool.query('SELECT * FROM piscina WHERE idpiscina = ?', [id]);

    res.render('piscina/edit', { piscina: piscinas[0]});
});

router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, tipo_piscina, volumen } = req.body;

    const newDataPiscina = {
        nombre, 
        tipo_piscina, 
        volumen
    };

    await pool.query('UPDATE piscina SET ? WHERE idpiscina = ?', [newDataPiscina, id]);

    req.flash('success', 'Datos de la piscina editado');

    res.redirect('/piscina');
});


//agregar direccion a la piscina
router.get('/direccion/:id', (req, res) => {
    const { id } = req.params;

    res.render('piscina/direccion', {id});
}); 

router.post('/direccion/:idpiscina', async (req, res) => {
    const { idpiscina } = req.params;

    const { calle, mz, smz, numint, numext, fracc, estado, ciudad, cp } = req.body;

    const newDireccion = {
        calle, 
        mz,
        smz, 
        numint, 
        numext, 
        fracc, 
        estado, 
        ciudad, 
        cp
    };

    const idDireccion = await pool.query('INSERT INTO direccion SET ?',[newDireccion]);

    console.log(idDireccion);

    await pool.query('UPDATE piscina SET idDireccion = ? WHERE idpiscina = ?', [idDireccion.insertId, idpiscina]);

    res.redirect('/piscina');
});

module.exports = router;