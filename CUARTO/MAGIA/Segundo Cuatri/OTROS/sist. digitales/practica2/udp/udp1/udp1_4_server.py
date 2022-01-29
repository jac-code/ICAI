#######################################
# Al igual que en el cliente, se parsean los argumentos con sys.argv[] y como novedad, cerramos el socket si 
#    se recibe un mensaje de 'exit' con el método sclose()
#######################################

import socket,pickle
from sys import argv

error=1
while error==1:
    try:
        ip=argv[1]
        port=argv[2]
        port=int(port)

        msg= "Hello Client"
        bytes_tx=str.encode(msg)


        socket= socket.socket(family=socket.AF_INET,type=socket.SOCK_DGRAM)
        socket.bind((ip,port))

        error=0
        print("UDP server up and listening ({})".format(port))
        while True:

            bytes_rx=socket.recvfrom(1024)
            message=pickle.loads(bytes_rx[0])
            address=bytes_rx[1]
            print("Recieved {} characters from Client {}".format(len(message[0]), message[1]))
            print("Message from Client {}: {}".format(message[1],message[0]))
            print("Client IP address: {}".format(address))
            if message[0]!="exit":
                socket.sendto(bytes_tx,address)
            else:
                socket.sendto(str.encode("Bye Client {}".format(message[1])),address)
                print("Bye")
                break
        socket.close()

    except ValueError:
        print("The port introduced is not an integer")
