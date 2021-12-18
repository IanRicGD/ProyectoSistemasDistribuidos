import funciones as fun  
from connect import conectar

disponibilidadLectura = True
disponibilidadEscritura = True

class transactionHandler:
    def __init__(self):
        pass
    
    def validarLogin(self,action,data):
        conexion = conectar()
        cursor  = conexion.cursor()
        #nombreUsuario, contraseña
        lista = fun.login(cursor, data[0],data[1])
        return lista           
            
 
    def abrirTransaccion(self,action,data):
        conexion = conectar()
        cursor = conexion.cursor()
        fun.registrarTransaccion(cursor,'En progreso')
        lista = self.coordinadorTransacciones(cursor,conexion,action,data)
        return lista
      
    def cerrarTransaccion(self,cursor,conexion):
        cursor.commit()
        cursor.close
        conexion.close
        
    
    def abortarTransaccion(self, cursor,conexion):
        cursor.close
        conexion.close
      
    
    def coordinadorTransacciones(self,cursor,conexion, action,data):
        global disponibilidadEscritura
        global disponibilidadLectura
        if(action == "ConsultaVuelo"):
            if(disponibilidadLectura):
                #Origen,Destino,FechaSalida
                lista = fun.consultaVuelos(cursor, data[0],data[1],data[2])
                return lista
            else:
                self.abortarTransaccion(cursor,conexion)
                return []
        elif(action == "ConsultaAsiento"):
            if(disponibilidadLectura):
                #codigoAvion
                lista = fun.consultaAsiento(cursor,data[0])
                return lista
            else:
                self.abortarTransaccion(cursor,conexion)
                return []
        elif(action == "Reservacion"):
            if(disponibilidadEscritura == True):
                disponibilidadEscritura = False
                disponibilidadLectura = False
                #nombreUsuario,tarjeta
                a = fun.reservacion(cursor,data[0],data[1])
                idRes=a[0][0]
                #cursor,nombreUsuario,numPase,codigoAvion,codigoVuelo,asientoFila,asientoColumna,numReservacion
                lista = fun.pase(cursor,data[1],idRes,data[2],data[3],data[4],data[5],idRes)
                self.cerrarTransaccion(cursor,conexion)
                disponibilidadEscritura = True
                disponibilidadLectura = True
                return lista
            else:
                self.abortarTransaccion(cursor,conexion)
                return []
        
        
                
        
def main2(action,data):
    ts = transactionHandler()
    if(action == "Login"):
        #login
        lista = ts.validarLogin(action,data)
    if(action == "Reservacion" or "ConsultaVuelo" or "ConsultaAsiento"):
        #Transaccion
        lista = ts.abrirTransaccion(action,data)
    return lista 
    
if __name__ == "__main__":
    data = ["Balucito1","12345678"]
    main2("Login",data)