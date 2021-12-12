import pyodbc

def conectar():
    
    server="localhost"
    bd='ProyectoDistribuidos'
    usuario = 'MyLogin'
    contrasena= '123'
    
    try:
        conexion=pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+bd+';UID='+usuario+';PWD='+contrasena)    
        print("Conexión exitosa")
        return conexion
    except Exception as Es:
        print("Error al intentar conectarse")
        print(Es)
        return Es

    
    
    
   