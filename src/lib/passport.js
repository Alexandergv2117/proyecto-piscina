const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const pool = require('../database');
const helpers = require('../lib/helpers');


passport.use('local.signup', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true
}, async (req, email, password, done) => {
    var  estado;
    const { nombres, apellidos, telefono, rol} = req.body;

    if (rol == 'Cliente') {
        estado = 'Activo';
    } else {
        estado = 'Desactivado';
    }
    const newRol = {
        rol,
        estado
    };

    const result_rol = await pool.query('INSERT INTO rol SET ? ', [newRol]);
    console.log(result_rol);

    const newUser = {
        nombre: nombres,
        apellido_paterno: apellidos,
        telefono,
        email,
        password,
        idrol: result_rol.insertId
    };

    newUser.password = await helpers.encryptPassword(password);

    const result = await pool.query('INSERT INTO user SET ?', [newUser]);
    newUser.id = result.insertId;

    return done(null, newUser);
}));

passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
    const rows = await pool.query('SELECT * FROM user WHERE iduser = ?', [id]);
    done(null, rows[0]);
});