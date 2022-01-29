import socket,pickle


while True:
    try:
        port=input("Introduce port number: ")
        port=int(port)
        error=0
        
        msg=input("Introduce message to send: ")
        
        
        
        bytes_tx=str.encode(msg)
        server_address= ("127.0.0.1",port)
        client id=1
        
        

        socket= socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
        socket.sendto(bytes_tx,server_address)
        print("Message sent to {}".format(server_address))
        
        bytes_rx=socket.recvfrom(1024)
        print("Message recieved from Server {}:".format(bytes_rx[1])
        print(bytes_rx[0])
        socket.close()
        break
        
    except ValueError:
        print("The port introduced is not an integer")
