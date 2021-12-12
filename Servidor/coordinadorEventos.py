#from funciones import reservacion, pase 
from connect import conectar

 
def abrirTransaccion(nombreUsuario,tarjetaCredito):
    conexion = conectar()
    cursor = conexion.cursor()
    consulta="insert into TRANSACCIONES values (?);"
    cursor.execute(consulta, "En Progreso")
    cursor.commit()
    #Pelea por entrar
    
    
     #reservacion(cursor,"12345678","Balucito1")
    #pase(cursor,"Balucito1",1,1,1,1,"A",1)
    
    #cursor.execute("Select * from RESERVACION")
    #cursor.execute("Select * from PASE;")
    
    #cursor.commit()
    #cursor.close
    #conexion.close
    
    

def cerrarTransaccion():
    return 0
    
def abortarTransaccion():
    return 0
    
def main():
    abrirTransaccion("Balucito1","12345678")
    
    
main()