-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: piscina
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carrito`
--

DROP TABLE IF EXISTS `carrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrito` (
  `idCarrito` int unsigned NOT NULL AUTO_INCREMENT,
  `idUser` int unsigned NOT NULL,
  PRIMARY KEY (`idCarrito`),
  KEY `fk_Carrito_User` (`idUser`),
  CONSTRAINT `fk_Carrito_User` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrito`
--

LOCK TABLES `carrito` WRITE;
/*!40000 ALTER TABLE `carrito` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compra`
--

DROP TABLE IF EXISTS `compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compra` (
  `idCompra` int unsigned NOT NULL AUTO_INCREMENT,
  `estado` enum('pendiente','aceptado','entregado') NOT NULL,
  `total` decimal(6,2) NOT NULL,
  `fecha_compra` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idUser` int unsigned NOT NULL,
  `idCarrito` int unsigned NOT NULL,
  PRIMARY KEY (`idCompra`),
  KEY `fk_Compra_User` (`idUser`),
  KEY `fk_compra_Carrito` (`idCarrito`),
  CONSTRAINT `fk_compra_Carrito` FOREIGN KEY (`idCarrito`) REFERENCES `carrito` (`idCarrito`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Compra_User` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra`
--

LOCK TABLES `compra` WRITE;
/*!40000 ALTER TABLE `compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direccion`
--

DROP TABLE IF EXISTS `direccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direccion` (
  `idDireccion` int unsigned NOT NULL AUTO_INCREMENT,
  `calle` varchar(50) NOT NULL,
  `MZ` int NOT NULL,
  `SMZ` int NOT NULL,
  `NumInt` varchar(10) DEFAULT NULL,
  `NumExt` varchar(10) NOT NULL,
  `Fracc` varchar(50) NOT NULL,
  `Estado` varchar(50) NOT NULL,
  `Municipio` varchar(80) NOT NULL,
  `Ciudad` varchar(60) NOT NULL,
  `CP` int NOT NULL,
  PRIMARY KEY (`idDireccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direccion`
--

LOCK TABLES `direccion` WRITE;
/*!40000 ALTER TABLE `direccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `direccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista`
--

DROP TABLE IF EXISTS `lista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista` (
  `idproductos` int unsigned NOT NULL,
  `idCarrito` int unsigned NOT NULL,
  KEY `fk_Lista_productos_has_Carrito_productos` (`idproductos`),
  KEY `fk_productos_has_Carrito_Carrito1` (`idCarrito`),
  CONSTRAINT `fk_Lista_productos_has_Carrito_productos` FOREIGN KEY (`idproductos`) REFERENCES `productos` (`idproductos`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_productos_has_Carrito_Carrito1` FOREIGN KEY (`idCarrito`) REFERENCES `carrito` (`idCarrito`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista`
--

LOCK TABLES `lista` WRITE;
/*!40000 ALTER TABLE `lista` DISABLE KEYS */;
/*!40000 ALTER TABLE `lista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_proveedores`
--

DROP TABLE IF EXISTS `lista_proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lista_proveedores` (
  `idProveedor` int unsigned NOT NULL,
  `idproductos` int unsigned NOT NULL,
  KEY `fk_Lista_proveedores_Proveedores` (`idProveedor`),
  KEY `fk_Lista_proveedores_Productos` (`idproductos`),
  CONSTRAINT `fk_Lista_proveedores_Productos` FOREIGN KEY (`idproductos`) REFERENCES `productos` (`idproductos`),
  CONSTRAINT `fk_Lista_proveedores_Proveedores` FOREIGN KEY (`idProveedor`) REFERENCES `proveedores` (`idProveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_proveedores`
--

LOCK TABLES `lista_proveedores` WRITE;
/*!40000 ALTER TABLE `lista_proveedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `lista_proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento_maquinas`
--

DROP TABLE IF EXISTS `mantenimiento_maquinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento_maquinas` (
  `idmantenimiento_maquinas` int unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` text,
  `costo` decimal(6,2) DEFAULT NULL,
  `fecha_visita` datetime NOT NULL,
  `duracion` time NOT NULL,
  `idpiscina` int unsigned NOT NULL,
  `idMAquina` int unsigned NOT NULL,
  PRIMARY KEY (`idmantenimiento_maquinas`),
  KEY `fk_mantenimiento_maquinas__Piscina` (`idpiscina`),
  KEY `fk_mantenimiento_maquinas__Maquina` (`idMAquina`),
  CONSTRAINT `fk_mantenimiento_maquinas__Maquina` FOREIGN KEY (`idMAquina`) REFERENCES `maquina` (`idMaquina`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mantenimiento_maquinas__Piscina` FOREIGN KEY (`idpiscina`) REFERENCES `piscina` (`idpiscina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento_maquinas`
--

LOCK TABLES `mantenimiento_maquinas` WRITE;
/*!40000 ALTER TABLE `mantenimiento_maquinas` DISABLE KEYS */;
/*!40000 ALTER TABLE `mantenimiento_maquinas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento_piscina`
--

DROP TABLE IF EXISTS `mantenimiento_piscina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento_piscina` (
  `idMantenimiento_piscina` int unsigned NOT NULL AUTO_INCREMENT,
  `idpiscina` int unsigned NOT NULL,
  `idServicio_piscina` int unsigned NOT NULL,
  `idUser` int unsigned NOT NULL,
  PRIMARY KEY (`idMantenimiento_piscina`),
  KEY `fk_mantenimiento_piscina_Piscina` (`idpiscina`),
  KEY `fk_mantenimiento_piscina_Servicio_piscina` (`idServicio_piscina`),
  KEY `fk_mantenimiento_piscina_User` (`idUser`),
  CONSTRAINT `fk_mantenimiento_piscina_Piscina` FOREIGN KEY (`idpiscina`) REFERENCES `piscina` (`idpiscina`),
  CONSTRAINT `fk_mantenimiento_piscina_Servicio_piscina` FOREIGN KEY (`idServicio_piscina`) REFERENCES `servicio_piscina` (`idServicio_piscina`),
  CONSTRAINT `fk_mantenimiento_piscina_User` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento_piscina`
--

LOCK TABLES `mantenimiento_piscina` WRITE;
/*!40000 ALTER TABLE `mantenimiento_piscina` DISABLE KEYS */;
/*!40000 ALTER TABLE `mantenimiento_piscina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maquina`
--

DROP TABLE IF EXISTS `maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquina` (
  `idMaquina` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`idMaquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maquina`
--

LOCK TABLES `maquina` WRITE;
/*!40000 ALTER TABLE `maquina` DISABLE KEYS */;
/*!40000 ALTER TABLE `maquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `piscina`
--

DROP TABLE IF EXISTS `piscina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `piscina` (
  `idpiscina` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `tipo_piscina` enum('piscina de obra','Piscina prefabricada','piscina natural','piscina desbordante','piscina de arena','piscina de microsemento','piscina transparente') NOT NULL,
  `volumen` decimal(6,2) DEFAULT NULL,
  `idDireccion` int unsigned NOT NULL,
  `idUser` int unsigned NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idpiscina`),
  KEY `fk_Piscina_Direccion` (`idDireccion`),
  KEY `fk_Piscina_User` (`idUser`),
  CONSTRAINT `fk_Piscina_Direccion` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Piscina_User` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `piscina`
--

LOCK TABLES `piscina` WRITE;
/*!40000 ALTER TABLE `piscina` DISABLE KEYS */;
/*!40000 ALTER TABLE `piscina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `idproductos` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `categoria` enum('Limpieza','Quimicos') NOT NULL,
  `precio` decimal(6,2) NOT NULL,
  `stock` int NOT NULL,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`idproductos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `idProveedor` int unsigned NOT NULL AUTO_INCREMENT,
  `nom_comercial` varchar(100) NOT NULL,
  `num` varchar(10) NOT NULL,
  `email` varchar(250) NOT NULL,
  `idDireccion` int unsigned NOT NULL,
  PRIMARY KEY (`idProveedor`),
  KEY `fk_Proveedores_Direccion` (`idDireccion`),
  CONSTRAINT `fk_Proveedores_Direccion` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `idRol` int unsigned NOT NULL AUTO_INCREMENT,
  `rol` enum('Supervisor','administrador','trabajador','cliente') NOT NULL,
  `estado` enum('Activo','Desactivado') NOT NULL,
  PRIMARY KEY (`idRol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio_piscina`
--

DROP TABLE IF EXISTS `servicio_piscina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_piscina` (
  `idServicio_piscina` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` enum('cepillado','filtrado','aspirado') NOT NULL,
  `precio` decimal(6,2) DEFAULT NULL,
  `estado` enum('pendiente','realizando','completado') NOT NULL,
  `dia` enum('lunes','martes','miercoles','jueves','viernes','sabado') NOT NULL,
  `hora` time NOT NULL,
  PRIMARY KEY (`idServicio_piscina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio_piscina`
--

LOCK TABLES `servicio_piscina` WRITE;
/*!40000 ALTER TABLE `servicio_piscina` DISABLE KEYS */;
/*!40000 ALTER TABLE `servicio_piscina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `idUser` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido_paterno` varchar(50) NOT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `telefono` varchar(10) NOT NULL,
  `email` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `idrol` int unsigned NOT NULL,
  `idDireccion` int unsigned DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idUser`),
  KEY `fk_User_Direccion` (`idDireccion`),
  KEY `fk_User_rol` (`idrol`),
  CONSTRAINT `fk_User_Direccion` FOREIGN KEY (`idDireccion`) REFERENCES `direccion` (`idDireccion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_User_rol` FOREIGN KEY (`idrol`) REFERENCES `rol` (`idRol`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-25  1:07:41
