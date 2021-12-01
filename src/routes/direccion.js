const express = require('express');
const pool = require('../database');
const router = express.Router();

router.get('/add', (req, res) => {
    res.render('direccion/add');
});

router.post('/add', async (req, res) => {
    const { calle, mz, smz, numint, numext, fracc, estado, ciudad, cp } = req.body;

    console.log(req.user);

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

    const resultQuery = await pool.query('INSERT INTO direccion SET ?', [newDireccion]);

    await pool.query('UPDATE user SET idDireccion = ? WHERE idUser = ?', [resultQuery.insertId, req.user.idUser]);

    req.user.idDireccion = resultQuery.insertId;
    req.user.Direccion = false;

    res.redirect('/home');
    
});




module.exports = router;