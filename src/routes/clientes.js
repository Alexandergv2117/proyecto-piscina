const express = require('express');
const router = express.Router();

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

router.get('/perfil', (req, res) => {
    res.send('Perfil de cliente')
});




module.exports = router;