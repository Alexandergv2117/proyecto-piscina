const express = require('express');
const router = express.Router();

router.get('/perfil', (req, res) => {
    res.send('Perfil de cliente')
});




module.exports = router;