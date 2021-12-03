const bcrypt = require('bcryptjs');
const pool = require('../database');

//Requerimos el paquete
var nodemailer = require('nodemailer');

//Creamos el objeto de transporte
var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'happypoollimpieza@gmail.com',
    pass: 'XiuHotjeje'
  }
});

const helpers = {};

helpers.encryptPassword = async (password) => {
    const salt = await  bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);
    return hash;
};

helpers.matchPassword = async (password, savedPassword) => {
    try {
        return await bcrypt.compare(password, savedPassword);
    } catch(e) {
        console.log(e);
    }
};

helpers.validemail = async (email) => {
    const rows = await pool.query('SELECT email FROM user WHERE email=?', [email]);

    if (rows.length > 0) {
        const emailValided = rows[0];
        console.log(emailValided.email);
        if (emailValided.email == email){
            return true;
        }
        return false;
    }
};

helpers.sendEmail = async (email, subject, message) => {
    var mailOptions = {
        from: 'happypoollimpieza@gmail.com',
        to: email,
        subject: subject,
        text: message
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.log(error);
        } else {
          console.log('Email enviado: ' + info.response);
        }
      });
};

module.exports = helpers;