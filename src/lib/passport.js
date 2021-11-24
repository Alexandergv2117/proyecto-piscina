const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const pool = require('../database');
const helpers = require('../lib/helpers');

//SIGN IN
passport.use('local.signin', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true
}, async (req, email, password, done) => {
    const rows =  await pool.query('SELECT * FROM user WHERE email = ?',[email]);

    if (rows.length > 0) {
        const user = rows[0];
        const validPassword = await helpers.matchPassword(password, user.password);

        const rol_consult = await pool.query('SELECT * FROM rol WHERE idrol = ?', [user.idrol]);
            const rol = rol_consult[0];

        if (validPassword) {
            if (rol.rol == 'cliente') {
                user.rolCliente = true;
                console.log('cliente');
            }
            if (rol.rol == 'trabajador') {
                user.rolTrabajador = true;
                console.log('trabajador');
            }
            if (rol.rol == 'administrador') {
                user.rolAdministrador = true;
                console.log('administrador');
            }
            //done(null, false, req.flash('message', 'La cuenta no esta activada'));
            done(null, user, req.flash('success', 'Welcome ' + user.nombre));

        } else {
            done(null, false, req.flash('message', 'Incorrect Password'));
        }
    } else {
        return done(null, false, req.flash('message',  'The email does not exist'));
    }
}));


//SIGN UP
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

/*passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
    const rows = await pool.query('SELECT * FROM user WHERE iduser = ?', [id]);
    done(null, rows[0]);
});*/

passport.serializeUser((user, done) => {
    done(null, user);
  });
  
  passport.deserializeUser((user, done) => {
    done(null, user);
  });