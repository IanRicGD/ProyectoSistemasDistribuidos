import pyodbc

server="localhost"
bd='Aeropuerto'
usuario = 'MyLogin'
contrasena= '123'

try:
    conexion=pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+bd+';UID='+usuario+';PWD='+contrasena)    
    print("Conexión exitosa")
except Exception as Es:
    print("Error al intentar conectarse")
    print(Es)


cursor= conexion.cursor()
cursor.execute("Select * from Asiento;")

asiento=cursor.fetchone()

while asiento:
    print(asiento)
    asiento=cursor.fetchone()

cursor.close
conexion.close