const express = require('express');
const router = express.Router();

const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

router.get('/', isNotLoggedIn, (req, res) => {
    res.render('index');
});

router.get('/faqs',(req,res) => {
    res.render('home/faqs');
});

module.exports = router;