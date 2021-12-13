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
        #fun.registrarTransaccion(cursor,'En progreso')
        #fun.consultaVuelos(cursor,'Ciudad de Mexico','Tuxtla', '2021-12-12')
        #fun.consultaAsiento(cursor,1)
        a = fun.reservacion(cursor,"12345678","Balucito1")
        idRes=a[0][0]
        b = fun.pase(cursor,"Balucito1",idRes,1,1,1,"A",idRes)
        cursor.commit()
        cursor.close()
        conexion.close()
        #Pelea por entrar
        
        
         #reservacion(cursor,"12345678","Balucito1")
        #pase(cursor,"Balucito1",1,1,1,1,"A",1)
        
      
        
        #cursor.commit()
        #cursor.close
        #conexion.close
        
        
    
    def cerrarTransaccion(self):
        return 0
        
    def abortarTransaccion(self):
        return 0
    
    def controlConcurrencia(cursor, idT,operacion):
        disponibilidad = True
        if(disponibilidad == True):
            if(operacion == 'Escritura'):
                #fun.reservacion(cursor,"12345678","Balucito1")
                #fun.pase(cursor,"Balucito1",1,1,1,1,"A",1)
                return 1
            else:
                return 0
                
        
        
def main():
    ts = transactionHandler()
    ts.abrirTransaccion("Balucito1","12345678")
    
    
if __name__ == "__main__":
	main()