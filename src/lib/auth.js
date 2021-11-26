module.exports = {
    isLoggedIn(req, res, next){
        if (req.isAuthenticated()) {
            return next();
        }
        return res.redirect('/home');
    },
    isNotLoggedIn(req, res, next) {
        if (!req.isAuthenticated()) {
            return next();
        }
        return res.redirect('/signin');
    }
};