#########################################
# Para poder pasar los argumentos por consola, se ha realizado el script a parte. 
# Los argumentos se parsean con sys.argv[]
# Con respecto a los ejercicios anteriores hay un nuevo cambio, si el mensaje que se recibe o se envía, se termina la conexión,
#    por lo que cerramos el socket con el método close()
#########################################

import socket,pickle
from sys import argv

socket= socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
ip=argv[1]
port=argv[2]
client_id=argv[3]

while True:
    try:

        port=int(port)

        msg=input("Introduce message to send: ")

        server_address= (ip,port)

        message=[msg,client_id]


        socket.sendto(pickle.dumps(message),server_address)
        print("Message sent to {}".format(server_address))

        socket.settimeout(5)
        bytes_rx=socket.recvfrom(1024)

        print("Message \"{}\" recieved from server at {}".format(bytes_rx[0].decode(),bytes_rx[1]))
        socket.settimeout(None)
        if msg=="exit":
            socket.close()
            break

    except ValueError:
        print("The port introduced is not an integer")
        port=input("Introduce a valid port: ")
    except OSError:
        print("El servidor no esta disponible")
        break
