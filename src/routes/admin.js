const express = require('express');
const router = express.Router();

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

const pool = require('../database');

router.get('/dashboard', isLoggedIn, (req, res) => {
    res.render('dashboard/index');
});

router.get('/cuentas', isLoggedIn, async (req, res) => {

    const users = await pool.query('SELECT `user`.idUser AS idUser, `user`.nombre AS nombre, `user`.apellido_paterno AS apellidos, `user`.telefono AS telefono, `user`.email AS email, rol.idRol AS idrol, rol.rol AS rol, rol.estado AS estado FROM `user` INNER JOIN rol ON `user`.idrol = rol.idRol');

    for (var i = 0; i < users.length; i++) {
        if (users[i].estado == 'Activo') {
            users[i].Status = true;
        } else {
            users[i].Status = false;
        }
    }

    res.render('dashboard/activarCuentas', { users });
});

router.get('/cuentas/desactivar/:idrol', isLoggedIn, async(req, res) => {
    const { idrol, Status } = req.params;
        await pool.query('UPDATE rol SET estado="Desactivado" WHERE idrol = ?', [idrol]);
    res.redirect('/admin/cuentas');
});
router.get('/cuentas/activar/:idrol', isLoggedIn, async(req, res) => {
    const { idrol} = req.params;
    await pool.query('UPDATE rol SET estado="Activo" WHERE idrol = ?', [idrol]);

    res.redirect('/admin/cuentas');
});

module.exports = router;