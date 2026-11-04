create database ticketgo;

use ticketgo;

create table rol (
id_rol  int auto_increment,
nombre_rol  varchar(20)  not null,
descripcion varchar(100),

constraint pk_rol primary key (id_rol),
constraint up_rol_nombre unique (nombre_rol)
);

create table usuario (
id_usuario int auto_increment,
documento  varchar(20)  not null,
nombre  varchar(80)  not null,
correo   varchar(100) not null,
contrasena varchar(255) not null,
telefono    varchar(20),
fecha_creacion  datetime  not null default current_timestamp,
id_rol   int  not null,

constraint pk_usuario primary key (id_usuario),
constraint uq_usuario_documento unique (documento),
constraint uq_usuario_correo unique (correo),
constraint fk_usuario_rol foreign key (id_rol) references rol (id_rol)
);

create table evento (
id_evento int auto_increment,
nombre  varchar(100) not null,
categoria  varchar(20)  not null,
fecha  datetime  not null,
lugar  varchar(100) not null,
estado  varchar(15)  not null default 'borrador',
fecha_creacion  datetime  not null default current_timestamp,
fecha_actualizacion  datetime  not null default current_timestamp on update current_timestamp, 
id_administrador int  not null,
imagen  varchar(255) null,

constraint pk_evento primary key (id_evento),
constraint fk_evento_administrador foreign key (id_administrador) references usuario (id_usuario)

);

create table zona (
id_zona  int auto_increment,
nombre   varchar(30) not null,
cupo_total   int not null,
cupo_disponible  int   not null,
precio   decimal(10,2) not null,
id_evento   int  not null,

constraint pk_zona primary key (id_zona),
constraint uq_zona_evento_nombre unique (id_evento, nombre),
constraint fk_zona_evento foreign key (id_evento) references evento (id_evento),
constraint ck_zona_cupo_total check (cupo_total > 0),
constraint ck_zona_cupo_disp check (cupo_disponible >= 0 and cupo_disponible <= cupo_total),
constraint ck_zona_precio check (precio >= 0)
);



create table descuento (
cod_descuento varchar(20)  not null,
tipo_condicion varchar(20)  not null,
porcentaje decimal(5,2) not null,
fecha_inicio date not null,
fecha_fin date not null,
cant_min int  not null default 1,
usado int  not null default 0,

constraint pk_descuento primary key (cod_descuento),
constraint ck_desc_porcentaje check (porcentaje > 0 and porcentaje <= 100),
constraint ck_desc_vigencia check (fecha_fin >= fecha_inicio),
constraint ck_desc_cant_min check (cant_min >= 1),
constraint ck_desc_usado check (usado >= 0)
);

create table venta (
id_venta   int auto_increment,
fecha_venta  datetime not null default current_timestamp,
subtotal decimal(12,2) not null default 0,
total  decimal(12,2) not null default 0,
estado   varchar(15)  not null default 'pendiente',
id_cliente  int  not null,
cod_descuento  varchar(20)  null,

constraint pk_venta primary key (id_venta),
constraint fk_venta_cliente foreign key (id_cliente) references usuario (id_usuario),
constraint fk_venta_descuento foreign key (cod_descuento) references descuento (cod_descuento),
constraint ck_venta_valores check (subtotal >= 0 and total >= 0)
);

create table pago (
id_pago int auto_increment,
fecha  datetime   not null default current_timestamp,
monto  decimal(12,2) not null,
metodo_pago varchar(20)  not null,
id_venta int  not null,

constraint pk_pago primary key (id_pago),
constraint uq_pago_venta unique (id_venta),
constraint fk_pago_venta foreign key (id_venta) references venta (id_venta),
constraint ck_pago_monto check (monto >= 0)
);


create table boleta (
id_boleta  int auto_increment,
estado varchar(15) not null default 'activa',
id_venta int not null,
id_zona   int  not null,

constraint pk_boleta primary key (id_boleta),
constraint fk_boleta_venta foreign key (id_venta) references venta (id_venta),
constraint fk_boleta_zona foreign key (id_zona) references zona (id_zona)
);


insert into rol (nombre_rol, descripcion) values
('Administrador', 'Gestiona eventos, zonas, descuentos y ventas'),
('Cliente',       'Consulta eventos y compra boletas');

insert into usuario (documento, nombre, correo, contrasena, telefono, fecha_creacion, id_rol) values
('1067890123','Carlos Andres Mendoza Ruiz','carlos.mendoza@ticketgo.com',sha2('Admin2026*', 256), '3105551201', '2026-08-20 09:00:00', 1),
('1065432109','Laura Valentina Ortega Perez','laura.ortega@gmail.com',sha2('Laura*2026', 256), '3115551202', '2026-08-25 09:15:00', 2),
('78456123', 'Jorge Luis Banda Castro', 'jorge.banda@hotmail.com', sha2('Jorge*2026', 256), '3125551203', '2026-08-29 10:30:00', 2),
('1003456789','Daniela Sofia Hernandez Vega','daniela.hernandez@gmail.com', sha2('Daniela*2026', 256), '3205551204', '2026-09-01 14:20:00', 2),
('1064789012','Santiago Jose Martinez Lopez','santiago.martinez@gmail.com', sha2('Santiago*2026', 256), '3015551205', '2026-09-03 16:45:00', 2),
('1002345678','Valeria Isabel Rojas Pineda','valeria.rojas@hotmail.com', sha2('Valeria*2026', 256), '3045551206', '2026-09-05 11:10:00', 2),
('1067123456','Andres Felipe Garcia Mora','andres.garcia@gmail.com',sha2('Andres*2026', 256), '3175551207', '2026-09-08 19:05:00', 2),
('1001987654','Camila Andrea Diaz Suarez','camila.diaz@outlook.com',sha2('Camila*2026', 256), '3185551208', '2026-09-12 08:50:00', 2),
('1066543210','Juan David Pacheco Arrieta','juan.pacheco@gmail.com',sha2('Juan*2026', 256), '3225551209', '2026-09-15 13:30:00', 2),
('1004567890','Mariana Lucia Torres Ballesteros','mariana.torres@gmail.com',sha2('Mariana*2026', 256), '3235551210', '2026-09-19 17:25:00', 2),
('1063210987','Sebastian Camilo Vergara Oviedo','sebastian.vergara@hotmail.com',sha2('Sebastian*2026', 256), '3135551211', '2026-09-24 20:00:00', 2),
('1007654321','Isabella Maria Guzman Salcedo','isabella.guzman@gmail.com', sha2('Isabella*2026', 256), '3145551212', '2026-09-28 12:40:00', 2),
('1068901234','Miguel Angel Cogollo Lara', 'miguel.cogollo@outlook.com', sha2('Miguel*2026', 256), '3165551213', '2026-10-02 15:15:00', 2),
('1002109876','Natalia Paola Doria Espitia','natalia.doria@gmail.com',sha2('Natalia*2026', 256), '3195551214', '2026-10-07 18:35:00', 2),
('1065098765','Luis Fernando Sierra Pastrana','luis.sierra@gmail.com', sha2('Luis*2026', 256), '3005551215', '2026-10-12 10:05:00', 2);   



insert into evento (nombre,categoria, fecha, lugar, estado, fecha_creacion, fecha_actualizacion, imagen, id_administrador) values
('Carlos Vives en concierto', 'concierto', '2026-11-27 20:00:00', 'Movistar Arena - Bogota', 'publicado', '2026-09-02 10:00:00', '2026-09-02 10:00:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/Carlos Vives.jpg', 1),
('Blessd Tour 2026', 'concierto', '2026-11-20 21:00:00', 'Movistar Arena - Bogota', 'publicado', '2026-09-04 11:30:00', '2026-09-10 09:15:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/Blessd.jpg', 1),
('Junior vs Nacional', 'deporte',   '2026-11-29 18:00:00', 'Estadio Metropolitano - Barranquilla', 'publicado', '2026-09-06 15:00:00', '2026-09-06 15:00:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/Junior vs Nacional.jpg', 1),
('Hamlet', 'teatro',  '2026-12-05 19:30:00', 'Teatro Jorge Eliecer Gaitan - Bogota', 'borrador',  '2026-09-09 09:40:00', '2026-10-11 16:20:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/hamlet.jpg', 1),
('Los cincuenta de Joselito', 'teatro',  '2026-11-30 19:00:00', 'Teatro El Ensueno - Bogota', 'publicado', '2026-09-11 14:10:00', '2026-09-11 14:10:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/Los 50 de Joselito.jpg', 1),
('Cine domo - Tunka',  'cine',  '2026-11-21 18:30:00', 'Maloka - Bogota',  'publicado', '2026-09-13 12:00:00', '2026-09-20 10:05:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/tunka.jpg', 1),
('Preguntale al expreso', 'teatro', '2026-12-12 20:00:00', 'Teatro Santander - Bucaramanga',  'publicado', '2026-09-16 17:45:00', '2026-09-16 17:45:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/expreso.jpg', 1),
('Noche de salsa Cali', 'concierto', '2026-12-04 21:00:00', 'Centro de Eventos Valle del Pacifico - Cali',   'publicado', '2026-09-18 10:25:00', '2026-09-25 13:00:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/nochesalsa.jpg', 1),
('Festival Vallenato del Caribe', 'festival',  '2026-12-18 17:00:00', 'Ronda del Sinu - Monteria', 'publicado', '2026-09-21 09:00:00', '2026-09-21 09:00:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/fvallenato.jpg', 1),
('Final Liga de Baloncesto', 'deporte', '2026-12-10 19:00:00', 'Coliseo El Pueblo - Cali', 'publicado', '2026-09-24 16:30:00', '2026-09-30 11:45:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/baloncesto.jpg', 1),
('Concierto Navideno Filarmonico',  'concierto', '2026-12-20 18:00:00', 'Teatro Pablo Tobon Uribe - Medellin',  'publicado', '2026-09-27 13:15:00', '2026-09-27 13:15:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/navideno.png', 1),
('America vs Santa Fe', 'deporte',   '2026-11-25 20:00:00', 'Estadio Pascual Guerrero - Cali',  'publicado', '2026-10-01 10:50:00', '2026-10-05 08:30:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/america-santafe.jpg', 1),
('Stand up comedy: Risas sin filtro', 'comedia',   '2026-12-02 20:00:00', 'Teatro Santander - Bucaramanga',   'publicado', '2026-10-04 15:20:00', '2026-10-04 15:20:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/standup.jpg', 1),
('Festival de Jazz del Caribe', 'festival',  '2027-01-16 18:00:00', 'Parque Cultural del Caribe - Barranquilla', 'borrador',  '2026-10-08 11:00:00', '2026-10-14 17:10:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/jazz.jpg', 1),
('Torneo Nacional de Voleibol', 'deporte',   '2027-01-23 09:00:00', 'Coliseo Happy Lora - Monteria', 'borrador',  '2026-10-13 14:40:00', '2026-10-13 14:40:00', 'C:/Users/HP/Downloads/RUTA IMAGENES/voleibol.jpg', 1);


insert into zona (nombre, cupo_total, cupo_disponible, precio, id_evento) values
('Platino', 200, 198, 85000.00, 1),
('General', 300, 297, 55000.00, 1),
('Tribuna alta', 10, 0, 35000.00, 1),
('Platino', 150, 149, 120000.00, 2),
('General', 400, 398, 70000.00, 2),
('Occidental', 300, 295, 90000.00, 3),
('Norte', 600, 596, 40000.00, 3),
('Platea', 180, 180, 70000.00, 4),
('Platea', 150, 148, 80000.00, 5),
('Balcon', 100, 98, 50000.00, 5),
('General', 120, 117, 30000.00, 6),
('Preferencial', 60, 60, 45000.00, 6),
('Platea', 140, 138, 65000.00, 7),
('Balcon', 80, 80, 40000.00, 7),
('VIP', 100, 100, 150000.00, 8),
('General', 500, 495, 60000.00, 8),
('Palco', 80, 78, 110000.00, 9),
('General', 800, 800, 50000.00, 9),
('Tribuna lateral', 400, 397, 55000.00, 10),
('Preferencial', 150, 150, 80000.00, 10),
('Platea', 200, 200, 95000.00, 11),
('Balcon', 120, 120, 60000.00, 11),
('Occidental', 250, 248, 85000.00, 12),
('Oriental', 700, 700, 38000.00, 12),
('Platea', 140, 138, 60000.00, 13),
('Balcon', 90, 90, 38000.00, 13),
('General', 300, 300, 70000.00, 14),
('General', 400, 400, 20000.00, 15);


insert into descuento (cod_descuento, tipo_condicion, porcentaje, fecha_inicio, fecha_fin, cant_min, usado) values
('GRUPO025', 'cantidad', 15.00, '2026-09-01', '2026-12-31', 5, 2),
('TEMPORADA333', 'temporada', 20.00, '2026-10-01', '2026-11-30', 1, 2),
('VERANO008', 'temporada', 10.00, '2026-12-01', '2027-02-28', 1, 0),
('GRUPO010', 'cantidad', 10.00, '2026-09-01', '2026-12-31', 3, 1),
('PAREJA012', 'cantidad', 12.00, '2026-09-15', '2026-12-31', 2, 1),
('BIENVENIDA05', 'temporada', 5.00, '2026-09-01', '2026-10-31', 1, 0),
('AMIGOS018', 'cantidad', 18.00, '2026-09-20', '2026-12-15', 6, 0),
('BLACKFRIDAY25', 'temporada', 25.00, '2026-11-20', '2026-11-30', 1, 0),
('NAVIDAD015', 'temporada', 15.00, '2026-12-01', '2026-12-24', 1, 0),
('FAMILIA020', 'cantidad', 20.00, '2026-09-01', '2027-01-31', 8, 0),
('UNICORDOBA10', 'temporada', 10.00, '2026-09-01', '2026-11-15', 1, 0),
('PREVENTA030', 'temporada', 30.00, '2026-09-01', '2026-09-30', 1, 3),
('OCTUBRE015', 'temporada', 15.00, '2026-10-01', '2026-10-31', 1, 2),
('FINDE010', 'temporada', 10.00, '2026-10-01', '2026-12-31', 1, 0),
('AMIGOS008', 'cantidad', 8.00, '2026-09-01', '2026-12-31', 2, 0);


insert into venta (fecha_venta, subtotal, total, estado, id_cliente, cod_descuento) values
('2026-09-03 10:15:00', 170000.00, 119000.00, 'pagada', 2, 'PREVENTA030'),
('2026-09-04 18:20:00', 165000.00, 165000.00, 'pagada', 3, null),
('2026-09-08 12:00:00', 160000.00, 144000.00, 'pagada', 4, 'GRUPO010'),
('2026-09-10 20:30:00', 140000.00, 98000.00, 'pagada', 5, 'PREVENTA030'),
('2026-09-14 09:45:00', 140000.00, 140000.00, 'pagada', 6, null),
('2026-09-17 16:10:00', 450000.00, 382500.00, 'pagada', 7, 'GRUPO025'),
('2026-09-20 11:25:00', 160000.00, 160000.00, 'pagada', 8, null),
('2026-09-22 19:00:00', 90000.00, 63000.00, 'pagada', 9, 'PREVENTA030'),
('2026-09-25 14:40:00', 130000.00, 114400.00, 'pagada', 10, 'PAREJA012'),
('2026-09-27 21:15:00', 210000.00, 210000.00, 'pagada', 11, null),
('2026-09-30 08:30:00', 300000.00, 255000.00, 'pagada', 12, 'GRUPO025'),
('2026-10-03 17:50:00', 120000.00, 102000.00, 'pagada', 13, 'OCTUBRE015'),
('2026-10-08 13:20:00', 220000.00, 176000.00, 'pagada', 14, 'TEMPORADA333'),
('2026-10-13 10:40:00', 165000.00, 165000.00, 'pagada', 15, null),
('2026-10-15 15:05:00', 100000.00, 85000.00, 'pagada', 2, 'OCTUBRE015'),
('2026-10-16 20:10:00', 170000.00, 136000.00, 'pagada', 7, 'TEMPORADA333'),
('2026-10-17 09:25:00', 120000.00, 120000.00, 'pagada', 4, null),
('2026-10-17 18:30:00', 190000.00, 190000.00, 'cancelada', 9, null);


insert into pago (fecha, monto, metodo_pago, id_venta) values
('2026-09-03 10:18:00', 119000.00, 'pse', 1),
('2026-09-04 18:23:00', 165000.00, 'nequi', 2),
('2026-09-08 12:03:00', 144000.00, 'daviplata', 3),
('2026-09-10 20:33:00', 98000.00, 'efectivo', 4),
('2026-09-14 09:48:00', 140000.00, 'tarjeta', 5),
('2026-09-17 16:13:00', 382500.00, 'pse', 6),
('2026-09-20 11:28:00', 160000.00, 'nequi', 7),
('2026-09-22 19:03:00', 63000.00, 'tarjeta', 8),
('2026-09-25 14:43:00', 114400.00, 'pse', 9),
('2026-09-27 21:18:00', 210000.00, 'nequi', 10),
('2026-09-30 08:33:00', 255000.00, 'daviplata', 11),
('2026-10-03 17:53:00', 102000.00, 'efectivo', 12),
('2026-10-08 13:23:00', 176000.00, 'tarjeta', 13),
('2026-10-13 10:43:00', 165000.00, 'pse', 14),
('2026-10-15 15:08:00', 85000.00, 'nequi', 15),
('2026-10-16 20:13:00', 136000.00, 'tarjeta', 16),
('2026-10-17 09:28:00', 120000.00, 'pse', 17),
('2026-10-17 18:33:00', 190000.00, 'nequi', 18);

insert into boleta (estado, id_venta, id_zona) values
('activa', 1, 1),
('activa', 1, 1),
('activa', 2, 2),
('activa', 2, 2),
('activa', 2, 2),
('activa', 3, 7),
('activa', 3, 7),
('activa', 3, 7),
('activa', 3, 7),
('activa', 4, 5),
('activa', 4, 5),
('activa', 5, 3),
('activa', 5, 3),
('activa', 5, 3),
('activa', 5, 3),
('activa', 6, 6),
('activa', 6, 6),
('activa', 6, 6),
('activa', 6, 6),
('activa', 6, 6),
('activa', 7, 9),
('activa', 7, 9),
('activa', 8, 11),
('activa', 8, 11),
('activa', 8, 11),
('activa', 9, 13),
('activa', 9, 13),
('activa', 10, 3),
('activa', 10, 3),
('activa', 10, 3),
('activa', 10, 3),
('activa', 10, 3),
('activa', 10, 3),
('activa', 11, 16),
('activa', 11, 16),
('activa', 11, 16),
('activa', 11, 16),
('activa', 11, 16),
('activa', 12, 4),
('activa', 13, 17),
('activa', 13, 17),
('activa', 14, 19),
('activa', 14, 19),
('activa', 14, 19),
('activa', 15, 10),
('activa', 15, 10),
('activa', 16, 23),
('activa', 16, 23),
('activa', 17, 25),
('activa', 17, 25),
('anulada', 18, 21),
('anulada', 18, 21);

