const express = require('express');
const router = express.Router();

const helpers = require('../lib/helpers');

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

router.get('/', isNotLoggedIn, (req, res) => {
    res.render('index');
});

router.get('/faqs',(req,res) => {
    res.render('home/faqs');
});

router.get('/cotizar',(req,res) => {
    res.render('cotizar');
});
router.post('/cotizarp', async (req, res) => {
    const { nombrectz, direccionctz, emailctz, largoP, anchoP, altoP, observaPs } = req.body;

    helpers.sendEmail('happypoollimpieza@gmail.com','Solicitud de cotización', nombrectz + ' ha solicitado una cotizacion para servicios de limpieza. La pisina tiene unas dimensiones de: '+ largoP +' de largo * ' + anchoP + ' de ancho * ' + altoP + ' de altura, otros datos que peden ser relevantes son: ' + observaPs + '             en ' + direccionctz + '         mandar cotización a: ' + emailctz);

    req.flash('success', 'Cotización realizada con exito');

    res.redirect('/');
});

router.post('/cotizarm', async (req, res) => {
    const { nombrectz, direccionctz, emailctz, equipoP, descripEPs } = req.body;



    helpers.sendEmail('happypoollimpieza@gmail.com','Solicitud de cotización',nombrectz + ' ha solicitado una cotizacion para reparacion de maquinaria.  El nombre que nos dio el cliente es: ' + equipoP + ' el problema descrito por el cliente es: ' + descripEPs + ' en ' + direccionctz + '         mandar cotización a: ' + emailctz);

    req.flash('success', 'Cotización realizada con exito');

    res.redirect('/');
});


module.exports = router;