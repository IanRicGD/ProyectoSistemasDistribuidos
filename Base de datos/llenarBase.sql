
use ProyectoDistribuidos
go
insert into AEROPUERTO values ('AICM Benito Juarez','Ciudad de Mexico','México')
go
insert into AEROPUERTO values ('Angel Albino Corzo','Tuxtla Gutierrez','Chiapas')
go

select * from AEROPUERTO
go

insert into AVION values ('Modelo A',20)
go
insert into AVION values ('Modelo B',20)
go

select * from AVION
go

insert into ASIENTO values (1,'A',1,0)
go
insert into ASIENTO values (1,'B',1,0)
go

insert into ASIENTO values (1,'A',2,0)
go
insert into ASIENTO values (1,'B',2,0)
go

select * from Asiento
go

insert into Cliente  values ('GOSA990524HDFMGL05','Álvaro','Gómez','Segovia','9612403301')
go

select * from Cliente
go

insert into RESERVACION  values ('2021-12-10','17:38:00','12345678','GOSA990524HDFMGL05')
go

select * from RESERVACION
go

insert into VUELO values ('19:00:00','17:42:00','2021-12-10','2021-12-10',1,2,1,0)
go

select * from VUELO
go
