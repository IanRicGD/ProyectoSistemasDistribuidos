
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
insert into AVION values ('Modelo C',20)
go

select * from AVION
go

insert into ASIENTO values (1,'A',1,0)
go
insert into ASIENTO values (1,'B',1,0)
go
insert into ASIENTO values (1,'C',1,0)
go
insert into ASIENTO values (1,'D',1,0)
go
insert into ASIENTO values (1,'E',1,0)
go
insert into ASIENTO values (1,'F',1,0)
go

insert into ASIENTO values (1,'A',2,0)
go
insert into ASIENTO values (1,'B',2,0)
go
insert into ASIENTO values (1,'C',2,0)
go
insert into ASIENTO values (1,'D',2,0)
go
insert into ASIENTO values (1,'E',2,0)
go
insert into ASIENTO values (1,'F',2,0)
go

insert into ASIENTO values (1,'A',3,0)
go
insert into ASIENTO values (1,'B',3,0)
go
insert into ASIENTO values (1,'C',3,0)
go
insert into ASIENTO values (1,'D',3,0)
go
insert into ASIENTO values (1,'E',3,0)
go
insert into ASIENTO values (1,'F',3,0)
go

select * from Asiento
go

insert into Cliente  values ('Balucito1','12345678','GOSA990524HDFMGL05','Álvaro','Gómez','Segovia','9612403301')
go

select * from Cliente
go

insert into VUELO values ('19:00:00','17:42:00','2021-12-10','2021-12-10',1,2,1,0)
go

insert into VUELO values ('19:00:00','17:42:00','2021-12-12','2021-12-12',2,1,1,0)
go

insert into VUELO values ('14:00:00','12:42:00','2021-12-12','2021-12-12',1,2,2,0)
go
insert into VUELO values ('15:00:00','13:42:00','2021-12-12','2021-12-12',2,1,3,0)
go

select * from VUELO
go

select * from PASE
go

select * from RESERVACION
go


select * from VUELO
go
select * from AEROPUERTO
go


select * from TRANSACCIONES
go

DBCC CHECKIDENT (TRANSACCIONES, RESEED, 0)