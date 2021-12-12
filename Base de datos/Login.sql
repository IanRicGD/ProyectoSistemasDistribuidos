CREATE LOGIN MyLogin WITH PASSWORD = '123';

create user ian for login MyLogin

Grant select,insert on PASE to ian
Grant EXECUTE on object::PA_crearPase to ian

select * from RESERVACION

select * from PASE