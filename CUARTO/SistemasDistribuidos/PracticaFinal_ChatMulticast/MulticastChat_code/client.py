import socket
import pickle
import struct
import threading
import tkinter as tk
import easygui as eg

class chatMulticast():

    #Constructor 
    def __init__(self):

        #Creamos la ventana con la librería tkinter
        self.ventana = tk.Tk()
        self.ventana.withdraw()

        #ventana para registrar el nombre de usuario
        self.login = tk.Toplevel(bg="#85e082") 
        self.login.title("Registro") 
        self.login.resizable(False,False) 
        self.login.geometry("300x100")

        #A continuación definimos todo lo que queremos que aparezca en la ventana de registgro

        self.nombreUsuario = tk.Label(self.login,text="Introduzca su nombre de usuario:",justify=tk.CENTER,bg="#85e082")
        self.nombreUsuario.pack()

        self.entradaNombre = tk.Entry(self.login)
        self.entradaNombre.pack()
        self.entradaNombre.focus()

        self.btncontinuar = tk.Button(self.login,text="CONTINUAR",command=lambda:self.continuar(self.entradaNombre.get()),bg="#ABB2B9")
        self.btncontinuar.pack()

        self.login.resizable(False,False)
        self.ventana.mainloop() 

    #Esta es la función que nos permite avanzar al char una vez que hemos puesto en mayúsculas el nombre de usuario
    #y verificado que el campo del usuario no está vacío, si es así nos saldrá un popup pidiendo que lo rellenemos
    def continuar(self,nombre):
        self.nombre = nombre.upper()
        if(self.nombre == ""):
            self.popNadaIntroducido()
        else:
            self.login.destroy() #eliminamos la ventana de registro
            self.chat(self.nombre) #pasamos a la función chat

    #Función que implementa el chat multicast
    def chat(self,nombre):

        self.nombre = nombre

        self.ventana.deiconify() #permite mostrar la ventana previamente ocultada
        self.ventana.configure(bg="#428040")
        self.ventana.title("ChatMulticast") #titulo de la ventana
        self.ventana.geometry("500x530") #tamaño de la ventana
        self.ventana.resizable(False,False)

        #Configuramos todo lo que queremos que aparezca en nuestra ventana de chat
        self.mensajeTitulo = self.nombre +",  BIENVENID@ AL CHAT MULTICAST"
        self.lblTitulo = tk.Label(self.ventana,text=self.mensajeTitulo,pady=5,bg="#428040",font='Arial 12 bold')
        self.lblTitulo.pack()

        self.btnSalir = tk.Button(self.ventana,text="Salir del grupo",width=20,bg="#ABB2B9",command=lambda:self.salir())
        self.btnSalir.pack()

        self.contenedorMensajes = tk.Text(self.ventana,width=20,height=2,bg="#85e082",fg="#070708",padx=5,pady=5,font="Arial 10")
        self.contenedorMensajes.place(x=10,y=60,height=400,width=480)
        self.contenedorMensajes.config(cursor="arrow")
        self.scrollbar = tk.Scrollbar(self.ventana)
        self.scrollbar.place(x=475,y=61,height=399,width=15)
        self.scrollbar.config(command=self.contenedorMensajes.yview)
        
        self.mensajeaenviar = tk.StringVar(value="")
        self.escrituraMensajes = tk.Entry(self.ventana,textvariable=self.mensajeaenviar,bg="#ACACAC",fg="#070708")                              
        self.escrituraMensajes.place(x=10,y=465,height=55,width=400)
        self.escrituraMensajes.focus()

        self.btnEnviar = tk.Button(self.ventana,text="Enviar",width=20,bg="#ABB2B9",command=lambda:self.enviar(self.mensajeaenviar.get())) 
        self.btnEnviar.place(x=415,y=465,height=55,width=75)

        #Inicializacion parametros para multicast
        self.MCAST_GRP = '224.1.1.1'
        self.MCAST_PORT = 5007

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

        #Usar '' para esuchar y escribir en el socket
        #Usar MCAST_GRP para escuchar solo en el socket
        self.sock.bind(('', self.MCAST_PORT))

        mreq = struct.pack("4sl", socket.inet_aton(self.MCAST_GRP), socket.INADDR_ANY)
        self.sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

        #Establecer el ttl
        ttl = struct.pack('b',1)
        self.sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, ttl)

        self.mensajeEntradaChat()

        reader = threading.Thread(target=self.time_function)
        reader.start()

    #esta función se encarga de estar escuchando y cuando recibe un mensaje lo muestra en el contenedor de los mensajes
    def time_function(self):
        while True:
            try:
                msg = self.sock.recv(1024)
                mensaje = pickle.loads(msg)
                self.contenedorMensajes.insert(tk.INSERT,mensaje[1]+": "+mensaje[0]+"\n")
            except:
                print("Conexion Finalizada")
                break
    
    #esta función se encarga de enviar el mensaje que ha escrito al resto de los participantes del grupo multicast
    def enviar(self,mensaje):
        try:
            bytes_tx = pickle.dumps([mensaje, self.nombre])
            self.sock.sendto(bytes_tx, (self.MCAST_GRP, self.MCAST_PORT))
        except:
            print("Conexion Finalizada")
        self.mensajeaenviar.set("") #Vaciamos nuestra entrada de texto para el siguiente mensaje

    #esta función es la que nos permite salir del grupo cuando pulsamos el botón de salir
    def salir(self):
        mensaje = "ABANDONÓ EL GRUPO"
        try:
            bytes_tx = pickle.dumps([mensaje, self.nombre])
            self.sock.sendto(bytes_tx, (self.MCAST_GRP, self.MCAST_PORT))
            self.escrituraMensajes.config(state=tk.DISABLED) #evitamos que pueda seguir escribiendo mensajes en la entrada de texto
            self.sock.close() #cerramos el socket levantado
        except:
            print("Conexion Finalizada")

    #esta función envía un mensaje notificando la entrada al chat del usuario que se acaba de conectar
    def mensajeEntradaChat(self):
        texto = "SE HA UNIDO AL GRUPO"
        try:
            bytes_tx = pickle.dumps([texto, self.nombre])
            self.sock.sendto(bytes_tx, (self.MCAST_GRP, self.MCAST_PORT))
        except:
            print("Conexión finalizada")

    #Esta función muestra un cuadro de mensaje para indicar que es obligatorio introducir un nombre de usuario
    def popNadaIntroducido(self):
        eg.msgbox (msg = "Es necesario introducir un nombre de usuario",title="USERNAME",ok_button="OK")  

def main():
    chatMulticast()

if __name__ == "__main__":
    main()
        
        
