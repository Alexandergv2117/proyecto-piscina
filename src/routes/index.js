const express = require('express');
const router = express.Router();

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

router.get('/', (req, res) => {
    res.render('index');
});

module.exports = router;