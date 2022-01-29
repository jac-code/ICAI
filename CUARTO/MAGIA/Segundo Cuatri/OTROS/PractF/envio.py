import socket
import struct
import sys
import pickle
import traceback
from threading import Thread
import threading


#Creamos una hebra
def clientThread():
    while True:
        client_input = connection.recv(1024)
        data_client=pickle.loads(client_input)
        print("Message from client {}: {}".format(data_client[0],data_client[1]))
        if data_client[1]=='quit':
            print("Closing connection...")
            sock.close()
            break
    

def start_server():
    MCAST_GRP='224.1.1.3'
    MCAST_PORT=5007

    sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM,socket.IPPROTO_UDP)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)

    sock.bind(('',MCAST_PORT))

    #sock.sendto(str.encode("adios"), (MCAST_GRP,MCAST_PORT))

    mreq=struct.pack("4sl", socket.inet_aton(MCAST_GRP),socket.INADDR_ANY)
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP,mreq)

    ttl=struct.pack('b',1)
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL,ttl)
    
    #sock.sendto(str.encode("Hello, this is user 2"), (MCAST_GRP,MCAST_PORT))
    id_client=1
    try:
        Thread(target=clientThread, args=(sock, MCAST_GRP, MCAST_PORT)).start()
    except:
        print("Thread did not start.")
        traceback.print_exc()
    
    while True:
        msg=input("Send message---->")
        sock.sendto(pickle.dumps([id_client,msg]),(MCAST_GRP, MCAST_PORT))
