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


