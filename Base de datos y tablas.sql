# En esta oportunidad vamos a crear una base de datos sobre Supermercados:

# Creamos la base de datos:
CREATE DATABASE supermercados;
USE supermercados;

# Creamos las tablas:
CREATE TABLE cadenas (
id_cadena INT AUTO_INCREMENT PRIMARY KEY,
   nombre_cadena VARCHAR(80) NOT NULL,
categoria VARCHAR(80) NOT NULL);

CREATE TABLE sucursales (
id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    provincia VARCHAR(80) NOT NULL,
  id_cadena INT NOT NULL,
FOREIGN KEY (id_cadena) REFERENCES cadenas(id_cadena)
);

CREATE TABLE categoria_productos (
   id_categoria INT AUTO_INCREMENT PRIMARY KEY,
nombre_categoria VARCHAR(80) NOT NULL
);

CREATE TABLE productos (
id_producto INT AUTO_INCREMENT PRIMARY KEY,
   nombre_producto VARCHAR(80) NOT NULL,
	marca VARCHAR(80),
      peso INT NOT NULL,
    id_categoria INT NOT NULL,
FOREIGN KEY (id_categoria) REFERENCES categoria_productos(id_categoria)
);

CREATE TABLE precios (
id_precio INT AUTO_INCREMENT PRIMARY KEY,
   id_producto INT NOT NULL,
     id_sucursal INT NOT NULL,
	  precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

CREATE TABLE ofertas (
id_oferta INT AUTO_INCREMENT PRIMARY KEY,
   id_producto INT NOT NULL,
      id_sucursal INT NOT NULL,
       descuento DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

CREATE TABLE empleados (
id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal INT NOT NULL,
       nombre VARCHAR(80) NOT NULL,
         apellido VARCHAR(80) NOT NULL,
       puesto VARCHAR(80) NOT NULL,
     salario INT NOT NULL,
   fecha_ingreso DATE NOT NULL,
FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

# Importamos los datos para las tablas a través de archivos CSV.