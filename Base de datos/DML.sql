use ProyectoDistribuidos
go

--Procedimientos almacenados
CREATE OR ALTER PROCEDURE PA_crearReservacion
	@fecha date,
	@hora time,
	@tarjeta varchar(20),
	@nomUsuario varchar(20)
	
AS
BEGIN
	set nocount on
	declare
	@idReservacion int

	insert into RESERVACION values (@fecha,@hora,@tarjeta,@nomUsuario)
	set @idReservacion = (select numReserva_D from RESERVACION where fecha = @fecha and hora = @hora)
	
	select numReserva_D as Codigo, nombreUsuario as Usuario,tarjeta as Tarjeta, fecha as Fecha, hora as Hora 
	from RESERVACION where numReserva_D = @idReservacion
END
go

begin tran
	exec PA_crearReservacion '2021-12-12','20:22:00','123456789','Balucito1'
rollback tran
go
DBCC CHECKIDENT (RESERVACION, RESEED, 0)
go

CREATE OR ALTER PROCEDURE PA_crearPase
	@nomUsuario varchar(20),
	@numPase int,
	@codigoAvion int,
	@codigoVuelo int,
	@filaAsiento int,
	@columnaAsiento char(1),
	@numReservacion int
AS
BEGIN
	set nocount on
	declare
	@codigoUnicoAsiento int,
	@horaSalida time,
	@fechaSalida date,
	@origen varchar(50),
	@destino varchar(50),
	@codigoAeropuertoLlegada int,
	@codigoAeropuertoSalida int

	set @horaSalida = (select horaSalida from VUELO where codigoAvion=@codigoAvion and codigoUnico_D=@codigoVuelo)
	set @fechaSalida = (select fechaSalida from VUELO where codigoAvion=@codigoAvion and codigoUnico_D=@codigoVuelo)
	set @codigoUnicoAsiento = (select numero_D from ASIENTO where codigoAvion=@codigoAvion and fila=@filaAsiento and columna=@columnaAsiento)
	set @codigoAeropuertoLlegada = (select codigoAeropuertoLlegada from VUELO where codigoAvion=@codigoAvion and codigoUnico_D=@codigoVuelo)
	set @codigoAeropuertoSalida= (select codigoAeropuertoSalida from VUELO where codigoAvion=@codigoAvion and codigoUnico_D=@codigoVuelo)
	set @origen = (select CONCAT(localidad,',',pais) from AEROPUERTO where codigoAeropuerto=@codigoAeropuertoSalida)
	set @destino = (select CONCAT(localidad,',',pais) from AEROPUERTO where codigoAeropuerto=@codigoAeropuertoLlegada)

	insert into PASE values (@horaSalida, @fechaSalida, @origen, @destino, @codigoUnicoAsiento, @codigoAvion, @numReservacion, @nomUsuario, @numPase, @codigoVuelo)
	update ASIENTO set ocupado = 1 where numero_D = @codigoUnicoAsiento and codigoAvion = @codigoAvion

	select @nomUsuario as Usuario, @codigoAvion as CodigoAvion, @codigoVuelo as CodigoVuelo, @origen as Origen, 
	@destino as Destino, @fechaSalida as FechaSalida,@horaSalida as HoraSalida, 
	CONCAT(@filaAsiento,@columnaAsiento) as Asiento
END
go

CREATE OR ALTER PROCEDURE PA_consultarVuelos
	@origen varchar(50),
	@destino varchar(50),
	@fechaSalida date
AS
BEGIN

	select
	V.codigoAvion as CodigoAvion, V.codigoUnico_D as CodigoVuelo, 
	V.fechaSalida as Fecha, V.horaSalida as HoraSalida, 
	concat(Sa.localidad,',',Sa.pais) as Origen, concat(Ll.localidad,',',Ll.pais) as Destino
	from VUELO as V 
	inner join AEROPUERTO as Ll
	on V.codigoAeropuertoLlegada = Ll.codigoAeropuerto
	inner join  AEROPUERTO as Sa
	on V.codigoAeropuertoSalida = Sa.codigoAeropuerto
	where V.fechaSalida = @fechaSalida
	and concat(Ll.localidad,',',Ll.pais) like '%'+ @destino + '%'
	and concat(Sa.localidad,',',Sa.pais) like '%'+ @origen + '%'
	
END
go
--Prueba
execute PA_consultarVuelos 'Ciudad de Mexico','Tuxtla', '2021-12-12'
go
execute PA_consultarVuelos 'Tuxtla','Ciudad de Mexico', '2021-12-10'
go
execute PA_consultarVuelos 'Tuxtla','Ciudad de Mexico', '2021-12-12'
go

CREATE OR ALTER PROCEDURE PA_consultarAsientoDisponible
	@codigoAvion int 
AS
BEGIN
	
	select  numero_D as CodigoAsiento,  fila as Fila, columna as Columna from ASIENTO 
	where codigoAvion = @codigoAvion and ocupado = 0
	
END
go

--Prueba
exec PA_consultarAsientoDisponible 1
go
exec PA_consultarAsientoDisponible 2
go
exec PA_consultarAsientoDisponible 3
go

CREATE OR ALTER PROCEDURE PA_validarLogin
	@nombreUsuario varchar(20),	
	@contraseña varchar(100)
AS
BEGIN
	declare 
	@contraseñaHash NVARCHAR(4000)

	set @contraseñaHash = HASHBYTES('MD5', CAST( @contraseña AS NVARCHAR(4000)))
	if exists (select nombreUsuario,contraseña from CLIENTE where nombreUsuario = @nombreUsuario and contraseña = @contraseñaHash)
	begin
		select 'True' as Resultado
	end
	else 
	begin
		select 'False' as Resultado
	end	
END
go
---Prueba
exec PA_validarLogin 'Balucito1','12345678'
exec PA_validarLogin 'Balucito2','12345678'

select * from cliente

------TRIGGERS-----
--TRIGGER: TRIGGER PARA CIFRAR LA CONTRASEÑA DEL USUARIO
create or alter trigger TG_contrasena
on CLIENTE instead of insert
as

begin
    insert into CLIENTE(nombreUsuario, contraseña,curp,nom,apPaterno,apMaterno,telefono)
    values(
    (select nombreUsuario from inserted),
	HASHBYTES('MD5', CAST( (select contraseña from inserted) AS NVARCHAR(4000))),
    (select curp from inserted),
    (select nom from inserted),
    (select apPaterno from inserted),
    (select apMaterno from inserted),
    (select telefono from inserted)
    )
end
go