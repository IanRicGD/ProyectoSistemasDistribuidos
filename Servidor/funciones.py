from datetime import date, datetime

def reservacion(cursor,tarjeta,nomUsuario):
	fecha = str(date.today())
	hora = datetime.today().strftime('%H:%M:%S')
	consulta="insert into RESERVACION values (?,?,?,?);"
	cursor.execute(consulta,fecha,hora,tarjeta,nomUsuario)

#hora, fecha, origen, destino, numAsiento, codigoAvion, codigoReservación, nombreUsuario, numPase, codigoVuelo
def pase(cursor,nombreUsuario,numPase,codigoAvion,codigoVuelo,asientoFila,asientoColumna,numReservacion):
	consulta="exec PA_crearPase ?,?,?,?,?,?,?;"
	cursor.execute(consulta,nombreUsuario,numPase,codigoAvion,codigoVuelo,asientoFila,asientoColumna,numReservacion)

def consultaVuelos(cursor,origen,destino, fechaSalida):
    consulta = "exec PA_consultarVuelos ?,?,?;"
    cursor.execute(consulta,origen,destino,fechaSalida)
    listaVuelos = []
    resultado=cursor.fetchone()
    while resultado:
        listaVuelos.append(resultado)
        resultado=cursor.fetchone()
    
    print(listaVuelos)

def consultaAsiento(cursor,codigoVuelo):
    consulta = "exec PA_consultarAsientoDisponible ?;"
    cursor.execute(consulta, codigoVuelo)
    listaAsientos = []
    resultado=cursor.fetchone()
    while resultado:
        listaAsientos.append(resultado)
        resultado=cursor.fetchone()
    
    print(listaAsientos)