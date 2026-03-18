CREATE DATABASE tienda_online;
USE  tienda_online;

CREATE TABLE productos (
idProducto INT PRIMARY KEY auto_increment,
nombre varchar (50) not null,
precio double not null,
stock int default (0),
fechaCreacion timestamp default current_timestamp
) ;

create table clientes(
idCliente int primary key,
nombreCliente varchar (30) not null,
emailCliente varchar (50) unique not null,
telefonoCliente varchar (20) null
) ;

create table pedidos (
idPedidos int primary key,
idClienteFK int not null,
fechaHora timestamp default current_timestamp,

foreign key (idClienteFK) references clientes(idCliente)
) ;

alter table pedidos add column total int;
alter table productos add column categoria varchar (50);
alter table clientes modify column telefonoCliente varchar (15);
alter table pedidos change column total monto_total int;
alter table productos drop column fechaCreacion;

describe pedidos;