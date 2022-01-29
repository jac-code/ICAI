import socket

error=1
while error==1:
    try: 
        port=input("Introduce port number: ")
        port=int(port)
        
        msg= "Hello Client"
        bytes_tx=str.encode(msg)
        

        socket= socket.socket(family=socket.AF_INET,type=socket.SOCK_DGRAM)
        socket.bind(("127.0.0.1",port))
        
        error=0
        print("UDP server up and listening ({})".format(port))
        while True:
           
            bytes_rx=socket.recvfrom(1024)
            message=bytes_rx[0]
            address=bytes_rx[1]
            print("Message from Client: {}".format(message))
            print("Client IP address: {}".format(address))
            socket.sendto(bytes_tx,address)
        
    except ValueError:
        print("The port introduced is not an integer")
