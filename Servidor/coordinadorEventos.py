import funciones as fun  
from connect import conectar

class transactionHandler:
    def __init__(self):
        pass
    
    
    def coordinadorEventos(self,action,data):
        #if(action == "Login"):
            #login
        #if(action == "Reservacion"):
            #transaccion
            self.abrirTransaccion(self,action,data)
            
 
    def abrirTransaccion(self,nombreUsuario,tarjetaCredito):
        conexion = conectar()
        cursor = conexion.cursor()
        #consulta="insert into TRANSACCIONES values (?);"
        #cursor.execute(consulta, "En Progreso")
        fun.consultaVuelos(cursor,'Ciudad de Mexico','Tuxtla', '2021-12-12')
        fun.consultaAsiento(cursor,1)

        cursor.commit()
        cursor.close()
        conexion.close()
        #Pelea por entrar
        
        
         #reservacion(cursor,"12345678","Balucito1")
        #pase(cursor,"Balucito1",1,1,1,1,"A",1)
        
        #cursor.execute("Select * from RESERVACION")
        #cursor.execute("Select * from PASE;")
        
        #cursor.commit()
        #cursor.close
        #conexion.close
        
        
    
    def cerrarTransaccion(self):
        return 0
        
    def abortarTransaccion(self):
        return 0
        
def main():
    ts = transactionHandler()
    ts.abrirTransaccion("Balucito1","12345678")
    
    
if __name__ == "__main__":
	main()