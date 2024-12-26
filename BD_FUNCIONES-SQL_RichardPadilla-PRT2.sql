-- Richard Padilla - PARTE 2
-- Aprendizaje de Funciones SQL: Creación, Análisis y Ejecución
create database Funciones_sql;
use Funciones_sql;

create table Productos (
    ProductoID int auto_increment primary key,
    Nombre varchar(100) not null unique,
    Precio decimal(10, 2) not null check (Precio > 0),
    Stock int not null check (Stock >= 0),
    Descripcion text
);

create table Ordenes (
    OrdenID int auto_increment primary key,
    ProductoID int not null,
    Cantidad int not null check (Cantidad > 0),
    Fecha_Orden date not null,
    foreign key (ProductoID) references Productos(ProductoID)
);

insert into Productos (Nombre, Precio, Stock, Descripcion)
values 
('Laptop', 800.00, 10, 'Laptop con 16GB de RAM y 512GB SSD'),
('Smartphone', 500.00, 20, 'Smartphone de última generación con pantalla AMOLED'),
('Auriculares', 50.00, 50, 'Auriculares inalámbricos con cancelación de ruido'),
('Monitor', 200.00, 15, 'Monitor de 24 pulgadas Full HD');

insert into Ordenes (ProductoID, Cantidad, Fecha_Orden)
values 
(1, 2, '2024-12-24'),
(2, 1, '2024-12-25'),
(3, 4, '2024-12-25'),
(4, 1, '2024-12-26');


-- FUNCIONE 1
delimiter //

create function Calcular_Total_Orden(id_orden int)
returns decimal(10, 2)
deterministic
begin
    declare total decimal(10, 2);
    declare iva decimal(10, 2);
    
    set iva = 0.15;
    
    select sum(P.Precio * O.Cantidad)
    into total
    from Ordenes O
    join Productos P on O.ProductoID = P.ProductoID
    where O.OrdenID = id_orden;
    
    set total = total + (total * iva);
    
    return total;
end;
//

delimiter ;

select  Calcular_Total_Orden (1) as TOTAL;


-- FUNCION 2
create table Personas (
    PersonaID int auto_increment primary key,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Fecha_Nacimiento date not null
);

insert into Personas (Nombre, Apellido, Fecha_Nacimiento)
values 
('Richard', 'Padilla', '1990-05-15'),
('Ana', 'López', '1985-12-20'),
('Carlos', 'Pérez', '2000-07-10'),
('María', 'García', '1995-03-25');


delimiter //

create function calcularEdad(fecha_nacimiento date)
returns int
deterministic
begin 
	declare edad int;
    set edad = timestampdiff(year, fecha_nacimiento, curdate());
    return edad;
end;
//

delimiter ;

select Nombre, Apellido, calcularEdad(Fecha_Nacimiento) as Edad from Personas;


-- FUNCCION 3
create table Productos1 (
    ProductosID int auto_increment primary key,
    Nombre varchar(100) not null,
    Precio decimal(10, 2) not null check (Precio > 0),
    Existencia int not null check (Existencia >= 0)
);

-- Insertar registros de ejemplo
insert into Productos1 (Nombre, Precio, Existencia)
values 
('Café Colombiano', 10.50, 100),
('Café Expreso', 12.00, 50),
('Taza de Cerámica', 5.00, 0),
('Filtro de Café', 2.50, 300);

delimiter // 

create function VerificarStock(producto_id int)
returns boolean
deterministic
begin
	declare stock int;
    select Existencia into stock
    from Productos1
    where ProductosID = producto_id;
    
	if stock > 0 then
		return True;
	else
		return false;
	end if;
end;
// 

delimiter ;

select VerificarStock(1) as Stock_Disponible;


-- FUNCION 4
create table Transacciones (
    TransaccionID int auto_increment primary key,
    cuenta_id int not null,
    tipo_transaccion varchar(10) not null check (tipo_transaccion in ('deposito', 'retiro')),
    monto decimal(10, 2) not null check (monto > 0),
    fecha_transaccion date not null
);

insert into Transacciones (cuenta_id, tipo_transaccion, monto, fecha_transaccion)
values 
(1, 'deposito', 1000.00, '2024-12-20'),
(1, 'retiro', 200.00, '2024-12-21'),
(1, 'deposito', 500.00, '2024-12-22'),
(2, 'deposito', 1500.00, '2024-12-20'),
(2, 'retiro', 700.00, '2024-12-21'),
(3, 'deposito', 300.00, '2024-12-22');

delimiter // 

create function CalcularSaldo(id_cuenta int)
returns decimal(10, 2)
deterministic
begin
	declare saldo decimal(10,2);
    
    select sum(case
		when tipo_transaccion = 'deposito' then monto
		when tipo_transaccion = 'retiro' then -monto
		else 0
	end) into saldo 
    from Transacciones
    where cuenta_id = id_cuenta;
    
    return saldo;
end;
//

delimiter ;

select CalcularSaldo(1) as SALDO_TOTAL;
    
    
    
    
    
    

     
    