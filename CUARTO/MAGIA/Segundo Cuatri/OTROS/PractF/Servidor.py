import socket
import struct
import sys


#IMPLEMENTACION DEL SERVIDOR DE GRUPO

# Este fichero hace referencia al servidor del chat multicast
# en el almacenaremos los mensajes de los distintos clientes
# Enviaremos a las aplicaciones de cada cliente lso distintos mensajes almacenados en el grupo


multicast='224.0.0.32' # Definimos la dirección IP de grupo multicast
port=1234 # Definimos el puerto
bind_addr='' #Dirección de enlace



# Primero debemos crear el sokcet, enlazarlo a un puerto y añadirlo a un grupo multicast
# Creamos el socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# Lo enlazamos a la dirección del servidor (dirección ip '' (string vacio), puerto)
sock.bind((bind_addr,port))
# Añadimos el socket a un grupo multicast en todas las intefaces
group = socket.inet_aton(multicast)#convierte el grupo multicast de dirección IPv4
# del formato string a un formato de 32-bit binario empaquetado
mreq = struct.pack('4sL', group, socket.INADDR_ANY)
#Configuramos los parametros del grupo -> protocolo ip
# Añadimos al socket el grupo multicast
sock.setsockopt(socket.IPPROTO_IP,socket.IP_ADD_MEMBERSHIP,mreq)
#Creamos un diccionario donde alamacenaremos los mensajes de los distintos participantes del grupo
# El diccionario tiene como clave una tupla con 3 items
# El primero definirá la dirección ip del cliente 
# El segundo el puerto por el que envia el mensaje
# El tercero será el orden de los mensajes enviados para una misma dirección ip y puerto
nicks={('Servidor',0,0): 'Bienvenido al grupo'} #El primer valor es el Servidor dando la bienvenida 

usuarios = {('Servidor',0): 'Servidor'} #Creamos un diccionario que hará la función de intercambiar la ip+puerto por el nombre del usuario


# Definimos una variable mensajes que convertirá a string todos los mensajes del grupo
# Para poder enviarlos a los distintos participantes
mensajes='Mensajes Recibidos: \n' 
# Entramos en un bucle infinito
while True:
    print('\nGrupo multicast listo para recibir mensajes') #Avisamos por consola de que estamos listos
    msg, address = sock.recvfrom(1024) #recibimos el mensaje junto a la direccion ip y puerto del cliente que lo envia
    # Para poder ordenar los mensajes será necesario recorrer las claves, por ello las almacenamos en una variable
    keys=nicks.copy().keys() # La función .copy() es importante para que la variable keys no se modifique mientras se itera
    lon=len(keys)-1 # Es importante almacenar la longitud - 1 valor para saber cuando llegamos al final del bucle
    lon_usuarios=len(usuarios) #Almacenamos la longitus de los usuarios
    for i,key in enumerate(keys): #Recorremos la variable que acabamos de crear
    #Comparamos, si existe mensajes con el mismo puerto y dirección ip
    # Esto es importante para no perder infromación
    # Las claves de un diccionario no pueden ser iguales, si un cliente escribiese un mensaje dos veces, si no lo enumerasemos,
    # se perderían los mensajes anteriores
    	if key[0]==address[0] and key[1]==address[1]: #En caso de ser asi aumentamos el tercer valor de la tupla(el contador de mensajes)
    		nicks[(address[0],address[1],key[2]+1)]=msg.decode() #Guardamos el mensaje recibido
    		break #nos salimos del bucle
    	elif i==lon: #si llegamos al final y no hemos salido del grupo es que es un cliente nuevo
    		nicks[(address[0],address[1],0)]=msg.decode()
    		usuarios[(address[0],address[1])]= 'Usuario_' + str(lon_usuarios - 1) #Hay un usuario nuevo, guardadamos su nombre

    #Convertimos el diccionario en un string
    mensajes='Mensajes Recibidos: \n' #Definimos un string donde se encadenarán todos los mensajes recibidos hasta el momento
    for addr,ms in nicks.items(): #recorremos el diccionario
    	# Vamos almacenando en la variable los distintos mensajes mapenado el nombre del usuario con su puerto y direccion asociados
    	mensajes = mensajes + '<' + usuarios[(addr[0],addr[1])]+ '>: ' + str(ms) + '\n'

   	#Enviamos la informacion al cliente
    sock.sendto(mensajes.encode(), address)
