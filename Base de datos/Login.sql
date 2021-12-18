use master 
create LOGIN MyLogin WITH PASSWORD = '123';
go

use ProyectoDistribuidos
go
create user coordinador for login MyLogin
go

Grant select,insert on PASE to coordinador
go
Grant select, insert on RESERVACION to coordinador
go
Grant select, insert,update on TRANSACCIONES to coordinador
go
Grant EXECUTE on object::PA_crearPase to coordinador
go

Grant EXECUTE on object::PA_crearPase to coordinador
go

Grant EXECUTE on object::PA_consultarVuelos to coordinador
go

Grant EXECUTE on object::PA_consultarAsientoDisponible to coordinador
go

Grant EXECUTE on object::PA_crearReservacion to coordinador
go

Grant EXECUTE on object::PA_validarLogin to coordinador
go


