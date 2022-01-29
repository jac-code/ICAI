import socket


while True:
    try:
        port=input("Introduce port number: ")
        port=int(port)

        msg= "Hello Server, I am Client 1"
        bytes_tx=str.encode(msg)
        server_address= ("127.0.0.1",port)

        socket= socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
        socket.sendto(bytes_tx,server_address)
        print("Message sent to {}".format(server_address))
        
        bytes_rx=socket.recvfrom(1024)
        print("Message recieved")
        print(bytes_rx)
        socket.close()
        break
        
    except ValueError:
        print("The port introduced is not an integer")
