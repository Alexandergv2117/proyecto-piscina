const express = require('express');
const router = express.Router();

const passport = require('passport');
const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

//Sign Up
router.get('/signup', isNotLoggedIn,(req, res) => {
    res.render('auth/signup');
});


router.post('/signup', passport.authenticate('local.signup', {
    successRedirect: '/signin',
    failureRedirect: '/',
    failureFlash: true
}));

//Sign In
router.get('/signin', isNotLoggedIn, (req, res) => {
    req.logOut();
    res.render('auth/signin');
});

router.post('/signin', (req, res, next) => {
    passport.authenticate('local.signin', {
        successRedirect: '/home',
        failureRedirect: '/signin',
        failureFlash: true
    })(req, res, next);
});

//Log Out
router.get('/logout', (req, res) => {
    req.logOut();
    res.redirect('/');
});

router.get('/home', (req, res) => {
        res.render('home/home');

});


module.exports = router;