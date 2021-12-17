# !/usr/bin/env python3
# ## ###############################################
#
# webserver.py
# Starts a custom webserver and handles all requests
#
# Autor: Kevin Lechuga
# License: MIT
#
# ## ###############################################

import os
import sys
import json
import magic
from http.server import BaseHTTPRequestHandler, HTTPServer

address = "0.0.0.0"
port = 8080

from transactionHandler import transactionHandler
TH = transactionHandler()

def transaccion(action,data):
    global TH
    if(action == "Login"):
        #login
        lista = TH.validarLogin(action,data)
    if(action == "Reservacion" or "ConsultaVuelo" or "ConsultaAsiento"):
        #Transaccion
        lista = TH.abrirTransaccion(action,data)
    return lista 
def listToHTML(lista):
	if len(lista) > 0:
		tabla = '<div><h2>Resultados</h2></div><table class="table">'+'<thead>'+'<tr>'
		tabla += '<th>Avion</th>'
		tabla += '<th>Vuelo</th>'
		tabla += '<th>Fecha</th>'
		tabla += '<th>Hora de Salida</th>'
		tabla += '<th>Origen</th>'
		tabla += '<th>Destino</th>'
		tabla += '<th>-</th>'
		tabla += '</tr></thead><tbody>'
		for l in lista:
			tabla += '<tr><td>{}</td><td>{}</td><td>{}</td><td>{}</td><td>{}</td><td>{}</td><td>{}</td></tr>'.format(l[0],
				l[1], l[2], l[3], l[4], l[5],'<button onclick="queryAsiento({})">Reservar</button>'.format(l[0]))
		tabla += '</tbody></table>'
		return tabla
	else:
		return "<p>Sin resultados</p>"

class WebServer(BaseHTTPRequestHandler):

	def _serve_file(self, rel_path):
		if not os.path.isfile(rel_path):
			self.send_error(404)
			return
		self.send_response(200)
		mime = magic.Magic(mime=True)
		self.send_header("Content-type", mime.from_file(rel_path))
		self.end_headers()
		with open(rel_path, 'rb') as file:
			self.wfile.write(file.read())


	def _serve_ui_file(self):
		if not os.path.isfile("user_interface.html"):
			err = "user_interface.html not found."
			self.wfile.write(bytes(err, "utf-8"))
			print(err)
			return
		try:
			with open("user_interface.html", "r") as f:
				content = "\n".join(f.readlines())
		except:
			content = "Error reading user_interface.html"
		self.wfile.write(bytes(content, "utf-8"))

	def _parse_post(self, json_obj):
		if not 'action' in json_obj or not 'value' in json_obj:
			return
		print("POST request:\n{}".format(json_obj))


	def do_GET(self):
		if self.path == '/':
			self.send_response(200)
			self.send_header("Content-type", "text/html")
			self.end_headers()
			self._serve_ui_file()
		elif self.path.find('?=') != -1:
			query = self.path.split('?=')[1].split("+")
			query = [q.replace("%20", " ") for q in query]
			print(query)
			response = listToHTML(transaccion("ConsultaVuelo", query))
			print(response)
			self.send_response(200)
			self.send_header("Content-type", "text/html")
			self.end_headers()
			self.wfile.write(bytes(response, "utf-8"))
		elif self.path.find('?2=') != -1:
			query = self.path.split('?2=')[1]
			print(query)
			response = transaccion("ConsultaAsiento", query)
			print(response)
			self.send_response(200)
			self.send_header("Content-type", "text/html")
			self.end_headers()
			self.wfile.write(bytes("<p>Aqui van los asientos</p>", "utf-8"))
		else:
			self._serve_file(self.path[1:])

	def do_POST(self):
		content_length = int(self.headers.get('Content-Length'))
		if content_length < 1:
			return
		post_data = self.rfile.read(content_length)
		try:
			jobj = json.loads(post_data.decode("utf-8"))
			self._parse_post(jobj)
		except:
			print(sys.exc_info())
			print("POST data not recognized.")

def main():
	address2 = str(input("Input the host address: "))
	address = address2 if address2 != "" else address 
	webServer = HTTPServer((address, port), WebServer)
	print("Servidor ON")
	print ("\tAtending requests at http://{}:{}".format(
		address, port))
	try:
		webServer.serve_forever()
	except KeyboardInterrupt:
		pass
	except:
		print(sys.exc_info())
	webServer.server_close()
	print("Server stopped.")

if __name__ == "__main__":
	main()
