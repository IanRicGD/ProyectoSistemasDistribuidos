import pyodbc
from funciones import reservacion, pase 

server="localhost"
bd='ProyectoDistribuidos'
usuario = 'MyLogin'
contrasena= '123'

try:
    conexion=pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+bd+';UID='+usuario+';PWD='+contrasena)    
    print("Conexión exitosa")
except Exception as Es:
    print("Error al intentar conectarse")
    print(Es)


cursor= conexion.cursor()
#reservacion(cursor,1,1,"A","12345678","Balucito1")
pase(cursor,"Balucito1",1,1,1,1,"A",4)

cursor.execute("Select * from PASE;")

asiento=cursor.fetchone()

while asiento:
    print(asiento)
    asiento=cursor.fetchone()

cursor.commit()
cursor.close
conexion.close