const express = require('express');
const pool = require('../database');
const router = express.Router();

router.get('/servicios/nuevos',  async(req, res) => {
    const servicios = await pool.query('SELECT mantenimiento_piscina.idMantenimiento_piscina, mantenimiento_piscina.precio, mantenimiento_piscina.dia, mantenimiento_piscina.hora, piscina.nombre, piscina.tipo_piscina, piscina.volumen, servicio_piscina.nombre, servicio_piscina.descripcion, mantenimiento_piscina.idUser FROM servicio_piscina INNER JOIN mantenimiento_piscina ON servicio_piscina.idServicio_piscina = mantenimiento_piscina.idServicio_piscina INNER JOIN piscina ON mantenimiento_piscina.idpiscina = piscina.idpiscina');

    const servicios_disponibles = {};

    for (var i = 0; i < servicios.length; i++) {
        if (servicios[i].idUser == null) {
            servicios_disponibles[i] = servicios[i];
        }
    }

    res.render('trabajador/servicio_disponibles', { servicios_disponibles });

});

router.get('/aceptar/:idMantenimiento_piscina', async(req, res) => {
    const { idMantenimiento_piscina } = req.params;

    await pool.query('UPDATE mantenimiento_piscina SET idUser = ? WHERE idMantenimiento_piscina = ?', [req.user.idUser, idMantenimiento_piscina]);

    res.redirect('/trabajador/misservicios');
});

router.get('/misservicios', async(req, res) => {

    const Servicios = await pool.query('SELECT piscina.nombre AS nombre_piscina, piscina.tipo_piscina AS tipo_piscina, piscina.volumen AS volumen_piscina, mantenimiento_piscina.estado AS estado_matenimiento, mantenimiento_piscina.dia AS dia, mantenimiento_piscina.hora AS hora, `user`.nombre AS nombre_cliente, `user`.apellido_paterno AS apellidos_cliente, `user`.telefono AS telefono_cliente, servicio_piscina.nombre AS nombre_servicio, servicio_piscina.precio AS precio_servicio, servicio_piscina.descripcion AS descripcion_servicio, mantenimiento_piscina.idMantenimiento_piscina AS idMantenimiento_piscina FROM mantenimiento_piscina INNER JOIN piscina ON mantenimiento_piscina.idpiscina = piscina.idpiscina INNER JOIN `user` ON piscina.idUser = `user`.idUser INNER JOIN servicio_piscina ON mantenimiento_piscina.idServicio_piscina = servicio_piscina.idServicio_piscina WHERE mantenimiento_piscina.idUser = ?', [req.user.idUser]);

    console.log(Servicios);

    for (var i = 0; i < Servicios.length; i++) {
        if (Servicios[i].estado_matenimiento == "pendiente") {
            Servicios[i].pendiente = true;
        }
        if (Servicios[i].estado_matenimiento == "realizando") {
            Servicios[i].realizando = true;
        }
        if (Servicios[i].estado_matenimiento == "completado") {
            Servicios[i].completado = true;
        }
    }

    res.render('trabajador/misServicios', {Servicios});
    
});

router.get('/servicio/realizar/:idMantenimiento_piscina', async (req, res) => {
    const { idMantenimiento_piscina } = req.params;

    await pool.query('UPDATE mantenimiento_piscina SET estado="realizando" WHERE idMantenimiento_piscina = ?', [idMantenimiento_piscina]);
    
    res.redirect('/trabajador//misservicios');
});

router.get('/servicio/completado/:idMantenimiento_piscina', async (req, res) => {
    const { idMantenimiento_piscina } = req.params;

    await pool.query('UPDATE mantenimiento_piscina SET estado="completado" WHERE idMantenimiento_piscina = ?', [idMantenimiento_piscina]);

    res.redirect('/trabajador//misservicios');
});



module.exports = router;