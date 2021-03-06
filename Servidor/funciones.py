from datetime import date, datetime

def reservacion(cursor,tarjeta,nomUsuario):
    fecha = str(date.today())
    hora = datetime.today().strftime('%H:%M:%S')
    consulta="execute PA_crearReservacion ?,?,?,?;"
    cursor.execute(consulta,fecha,hora,tarjeta,nomUsuario)
    reservacion = []
    resultado = cursor.fetchone()
    while resultado:
        reservacion.append(resultado)
        resultado = cursor.fetchone()
    
    print(reservacion)
    return reservacion
    


def pase(cursor,nombreUsuario,numPase,codigoAvion,codigoVuelo,asientoFila,asientoColumna,numReservacion):
    consulta="exec PA_crearPase ?,?,?,?,?,?,?;"
    cursor.execute(consulta,nombreUsuario,numPase,codigoAvion,codigoVuelo,asientoFila,asientoColumna,numReservacion)
    pase = []
    resultado = cursor.fetchone()
    while resultado:
        pase.append(resultado)
        resultado = cursor.fetchone()
    
    print(pase)
    return pase

def consultaVuelos(cursor,origen,destino, fechaSalida):
    consulta = "exec PA_consultarVuelos ?,?,?;"
    cursor.execute(consulta,origen,destino,fechaSalida)
    listaVuelos = []
    resultado=cursor.fetchone()
    while resultado:
        listaVuelos.append(resultado)
        resultado=cursor.fetchone()
    
    print(listaVuelos)
    return listaVuelos

def consultaAsiento(cursor,codigoVuelo):
    consulta = "exec PA_consultarAsientoDisponible ?;"
    cursor.execute(consulta, codigoVuelo)
    listaAsientos = []
    resultado=cursor.fetchone()
    while resultado:
        listaAsientos.append(resultado)
        resultado=cursor.fetchone()
    
    print(listaAsientos)
    return listaAsientos

def registrarTransaccion(cursor,status,action):
    fecha = str(date.today())
    hora = datetime.today().strftime('%H:%M:%S')
    consulta="insert into TRANSACCIONES values (?,?,?,?);"
    cursor.execute(consulta,fecha,hora,action,status)
    
def terminarTransaccion(cursor,status,idT):
    consulta = "update TRANSACCIONES set estado = (?) where id = (?);"
    cursor.execute(consulta,status,idT)
    
def login(cursor,nombreUsuario,contrase??a):
    consulta = "exec PA_validarLogin ?,?;"
    cursor.execute(consulta, nombreUsuario,contrase??a)
    resultado=cursor.fetchone()
    lista = resultado[0]
    print(lista)
    return lista