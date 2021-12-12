use ProyectoDistribuidos
go
------PROCEDIMIENTOS-----
CREATE OR ALTER PROCEDURE PA_crearPase
-- Definimos los parametros de entrada y salida
	@nomUsuario varchar(20),
	@numPase int,
	@codigoAvion int,
	@codigoVuelo int,
	@filaAsiento int,
	@columnaAsiento char(1),
	@numReservacion int
AS
BEGIN
	declare
	@codigoUnicoAsiento int,
	@horaSalida time,
	@fechaSalida date,
	@origen varchar(20),
	@destino varchar(20),
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
END

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