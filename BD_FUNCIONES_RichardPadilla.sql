-- Richard Padilla - PARTE 1
-- Creacion de la base de datos 
create database Tienda_online;
use Tienda_online;

-- Creacion de las tablas
create table clientes (
    id int auto_increment primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null unique,
    telefono varchar(15),
    fecha_registro date not null
);

create table productos (
    id int auto_increment primary key,
    nombre varchar(100) not null unique,
    precio decimal(10, 2) not null check (precio > 0),
    stock int not null check (stock >= 0),
    descripcion text
);

create table pedidos (
    id int auto_increment primary key,
    cliente_id int not null,
    fecha_pedido date not null, 
    total decimal(10, 2) not null check (total >= 0),
    foreign key (cliente_id) references clientes(id)
);

create table detalles_pedido (
    id int auto_increment primary key,
    pedido_id int not null,
    producto_id int not null,
    cantidad int not null check (cantidad > 0),
    precio_unitario decimal(10, 2) not null check (precio_unitario > 0),
    foreign key (pedido_id) references pedidos(id),
    foreign key (producto_id) references productos(id)
);

-- Registro para cada tabla
insert into clientes (nombre, apellido, email, telefono, fecha_registro)
values 
('Richard', 'Padilla', 'richard.padilla@example.com', '0987654321', '2018-12-20'),
('Ana', 'López', 'ana.lopez@example.com', '0987654322', '2024-12-21'),
('Carlos', 'Pérez', 'carlos.perez@example.com', '0987654323', '2024-12-22'),
('María', 'García', 'maria.garcia@example.com', '0987654324', '2024-12-23');

insert into productos (nombre, precio, stock, descripcion)
values 
('Café Colombiano', 10.50, 100, 'Café de origen colombiano, 100% orgánico'),
('Café Expreso', 12.00, 50, 'Mezcla especial para preparar expreso'),
('Taza de Cerámica', 5.00, 200, 'Taza blanca de cerámica con diseño clásico'),
('Filtro de Café', 2.50, 300, 'Filtro reutilizable para preparar café');

insert into pedidos (cliente_id, fecha_pedido, total)
values 
(1, '2024-12-24', 30.00),
(2, '2024-12-25', 20.00),
(3, '2024-12-25', 15.00),
(4, '2024-12-26', 40.00);

insert into detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario)
values 
(1, 1, 2, 10.50),
(1, 3, 2, 5.00),
(2, 2, 1, 12.00),
(2, 4, 4, 2.50),
(3, 1, 1, 10.50),
(3, 4, 2, 2.50),
(4, 2, 2, 12.00),
(4, 3, 4, 5.00);


-- Creacion de funciones
-- Obtener el nombre completo del cliente
delimiter //

create function obtener_nombres(cliente_id int)
returns varchar(50)
deterministic
begin
    declare nombre_completo varchar(50);
    select concat(nombre, ' ', apellido) 
    into nombre_completo
    from clientes
    where id = cliente_id;
    return nombre_completo;
end;
//

delimiter ;

select obtener_nombres(1) as nombre_completo;

-- Calcular el precio con descuento
delimiter // 

create function Calcular_precio_con_descuento(precio decimal(10,2), descuento decimal(5,2))
returns decimal(10,2)
deterministic
begin
	return precio - (precio * (descuento/100));
end;

//

delimiter ;

select Calcular_precio_con_descuento(12.50,10) as Precio_Descuento;

-- Calcular el total de un pedido
delimiter //

create function Calcular_total_pedidos(pedido_id int)
returns decimal(10,2)
deterministic
begin
	declare TOTAL decimal(10,2);
    select sum(cantidad*precio_unitario)
    into TOTAL
    from detalles_pedido
    where pedido_id = pedido_id;
    return ifnull(TOTAL, 0);
end;
//

delimiter ;

select Calcular_total_pedidos(1) as Total_Pedidos;

-- Verificar la disponibilidad de stock
delimiter //

create function Disponibilidad_stock(producto_id int, cantidad int)
returns boolean
deterministic
begin
    declare stock_actual int;
    select stock 
    into stock_actual
    from productos
    where id = producto_id;

    return stock_actual >= cantidad;
end;
//

delimiter ;

select Disponibilidad_stock(2,7) as Stock_Disponible;

-- Calcular la antigüedad de un cliente
delimiter // 

create function Antigüedad_cliente(cliente_id int)
returns int 
deterministic
begin
	declare antiguo int;
    select timestampdiff(year, fecha_registro, curdate()) 
    into antiguo
    from clientes
    where id = cliente_id;
    return antiguo;
end;
//

delimiter ;

select Antigüedad_cliente(1) as Cliente_mas_antiguo;







