use ProyectoDistribuidos
go
------TRIGGERS-----
--TRIGGER: TRIGGER PARA CIFRAR LA CONTRASE�A DEL USUARIO
create or alter trigger TG_contrasena
on CLIENTE instead of insert
as

begin
    insert into CLIENTE(nombreUsuario, contrase�a,curp,nom,apPaterno,apMaterno,telefono)
    values(
    (select nombreUsuario from inserted),
	HASHBYTES('MD5', CAST( (select contrase�a from inserted) AS NVARCHAR(4000))),
    (select curp from inserted),
    (select nom from inserted),
    (select apPaterno from inserted),
    (select apMaterno from inserted),
    (select telefono from inserted)
    )
end
go