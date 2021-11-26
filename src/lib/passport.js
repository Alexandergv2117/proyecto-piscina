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
            
            if(rol.estado == 'Activo'){
                if (rol.rol == 'cliente') {
                    user.rolCliente = true;
                }
                if (rol.rol == 'trabajador') {
                    user.rolTrabajador = true;
                }
                if (rol.rol == 'administrador') {
                    user.rolAdministrador = true;
                }
                done(null, user, req.flash('success', 'Bienvenido ' + user.nombre));
            } else {
                done(null, false, req.flash('message', 'La cuenta no esta activada'));
            }
        } else {
            done(null, false, req.flash('message', 'Contraseña incorrecta'));
        }
    } else {
        return done(null, false, req.flash('message',  'Email no esta registrado'));
    }
}));


//SIGN UP
passport.use('local.signup', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true
}, async (req, email, password, done) => {

    //Valida si el email ya esat registrado
    const validemail = await helpers.validemail(email);

    if(validemail){
        return done(null, false, req.flash('message', 'El email ya esta registrado'));
    }

    //activa o desactiva la cuenta
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

    //Registra el usaurio
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

    if (estado == 'Desactivado') {
        return done(null, false, req.flash('message', 'La cuenta aun no esta activada'));
    }

    return done(null, newUser, req.flash('success', '!!Registro realizado con exito!!  Favor de logeate para iniciar sesión'));
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