--Host: 35.184.11.1
--Server del mysql: https://northmkt.com.mx:8443/smb/web/view
--r2Do%y34

CREATE DATABASE piscina;

USE piscina;

CREATE TABLE Rol (
    idRol INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    rol ENUM('Supervisor', 'administrador', 'trabajador', 'cliente') NOT NULL,
    estado enum('Activo','Desactivado') NOT NULL
);

CREATE TABLE direccion (
    iddireccion INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    calle VARCHAR(50) NOT NULL,
    mz INT(10) NOT NULL,
    smz INT(10) NOT NULL,
    numint VARCHAR(10),
    numext VARCHAR(10) NOT NULL,
    fracc VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    Ciudad VARCHAR(60) NOT NULL,
    CP INT NOT NULL
);

CREATE TABLE users(
    idUser INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    telefono VARCHAR(10) NOT NULL,
    email VARCHAR(250) NOT NULL,
    password VARCHAR(250) NOT NULL, 
    idrol INT(11) UNSIGNED NOT NULL,
    idDireccion INT(11) UNSIGNED,
    CONSTRAINT fk_User_Direccion FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_User_rol FOREIGN KEY (idrol) REFERENCES rol(idrol) ON UPDATE CASCADE ON DELETE RESTRICT,
    fecha_registro TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE maquina(
    idmaquina INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE piscina (
    idpiscina INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (50) NOT NULL,
    tipo_piscina ENUM('piscina de obra','Piscina prefabricada','piscina natural','piscina de arena','piscina de microsemento','piscina transparente') NOT NULL,
    volumen DEC(6,2) NOT NULL,
    idDireccion INT(11) UNSIGNED,
    idUser INT(11) UNSIGNED NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT fk_Piscina_Direccion FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_Piscina_User FOREIGN KEY (idUser) REFERENCES User(idUser) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE mantenimiento_maquinas (
    idmantenimiento_maquinas INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    descripcion TEXT,
    costo DEC(6,2),
    fecha_visita DATETIME NOT NULL,
    duracion TIME NOT NULL,
    idpiscina INT(11) UNSIGNED NOT NULL,
    idMAquina INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_mantenimiento_maquinas__Piscina FOREIGN KEY (idpiscina) REFERENCES Piscina(idpiscina),
    CONSTRAINT fk_mantenimiento_maquinas__Maquina FOREIGN KEY (idMaquina) REFERENCES Maquina(idMaquina) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE servicio_piscina (
    idservicio_piscina INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DEC(6,2) NOT NULL,
    descripcion TEXT NOT NULL
);

CREATE TABLE mantenimiento_piscina (
    idmantenimiento_piscina INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idpiscina INT(11) UNSIGNED NOT NULL,
    idServicio_piscina INT(11) UNSIGNED NOT NULL,
    idUser INT(11) UNSIGNED,
    precio DEC(6,2),
    estado ENUM('pendiente', 'realizando', 'completado') NOT NULL,
    dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado') NOT NULL,
    hora TIME NOT NULL,
    CONSTRAINT fk_mantenimiento_piscina_Piscina FOREIGN KEY (idpiscina) REFERENCES piscina(idpiscina),
    CONSTRAINT fk_mantenimiento_piscina_Servicio_piscina FOREIGN KEY (idServicio_piscina) REFERENCES Servicio_piscina(idServicio_piscina),
    CONSTRAINT fk_mantenimiento_piscina_User FOREIGN KEY (idUser) REFERENCES User(idUser)
);

--//////////TIENDA
CREATE TABLE carrito (
    idcarrito INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    iduser INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_Carrito_User FOREIGN KEY (idUser) REFERENCES User(idUser) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE compra (
    idcompra INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    estado ENUM('pendiente', 'aceptado', 'entregado') NOT NULL,
    total DEC(6,2) NOT NULL,
    fecha_compra TIMESTAMP NOT NULL DEFAULT current_timestamp,
    idUser INT(11) UNSIGNED NOT NULL,
    idCarrito INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_Compra_User FOREIGN KEY (idUser) REFERENCES User(idUser),
    CONSTRAINT fk_compra_Carrito FOREIGN KEY (idCarrito) REFERENCES Carrito(idCarrito) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE productos (
    idproductos INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    categoria ENUM('Limpieza', 'Quimicos') NOT NULL,
    precio DEC(6,2) NOT NULL,
    stock INT(100) NOT NULL,
    descripcion TEXT NOT NULL
);

CREATE TABLE Lista (
    idproductos INT(11) UNSIGNED NOT NULL,
    idCarrito INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_Lista_productos_has_Carrito_productos FOREIGN KEY (idproductos) REFERENCES productos(idproductos) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_productos_has_Carrito_Carrito1 FOREIGN KEY (idCarrito) REFERENCES Carrito(idCarrito) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Proveedores (
    idProveedor INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom_comercial VARCHAR (100) NOT NULL,
    num VARCHAR(10) NOT NULL,
    email VARCHAR(250) NOT NULL,
    idDireccion INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_Proveedores_Direccion FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Lista_Proveedores (
    idProveedor INT(11) UNSIGNED NOT NULL,
    idproductos INT(11) UNSIGNED NOT NULL,
    CONSTRAINT fk_Lista_proveedores_Proveedores FOREIGN KEY (idProveedor) REFERENCES Proveedores(idProveedor),
    CONSTRAINT fk_Lista_proveedores_Productos FOREIGN KEY (idproductos) REFERENCES Productos(idproductos)
);