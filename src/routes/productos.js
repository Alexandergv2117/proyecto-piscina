const express = require('express');
const router = express.Router();

const pool = require('../database');


//Añadir un producto
router.get('/add', (req, res) => {
    res.render('productos/add');
});

router.post('/add', async (req, res) => {
    const { nombre, categoria, precio, stock, descripcion } = req.body;

    const newProducto = {
        nombre,
        categoria,
        precio,
        stock,
        descripcion
    };

    await pool.query('INSERT INTO productos SET ?', [newProducto]);

    req.flash('success', 'Producto guardado');

    res.redirect('/productos');
});

//Mostrar productos
router.get('/', async (req, res) => {
    const productos = await pool.query('SELECT * FROM productos');

    res.render('productos/list', { productos });
});

//Eliminar productos
router.get('/delete/:id', async(req, res) => {
    const { id } = req.params;

    await pool.query('DELETE FROM productos WHERE idproductos = ?', [id]);
    req.flash('success', 'Producto eliminado');
    res.redirect('/productos');
});

//Editar productos
router.get('/edit/:id', async(req, res) => {
    const { id } = req.params;

    const productos = await pool.query('SELECT * FROM productos WHERE idproductos = ?', [id]);

    res.render('productos/edit', {producto: productos[0]});
    
});

router.post('/edit/:id', async(req, res) => {
    const { id } = req.params;
    const {nombre, categoria, precio, stock, descripcion } = req.body;

    const newProducto = {
        nombre, 
        categoria, 
        precio, 
        stock, 
        descripcion
    };

    await pool.query('UPDATE productos set ? WHERE idproductos = ?', [newProducto, id]);

    req.flash('success', 'Producto editado');

    res.redirect('/productos');
    
});

module.exports = router;