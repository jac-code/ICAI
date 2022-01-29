import socket
import struct

MCAST_GRP='224.1.1.1'
MCAST_PORT=5007

sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM,socket.IPPROTO_UDP)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)

sock.bind(('',MCAST_PORT))
sock.sendto(str.encode("Hello, this is user 1!"), (MCAST_GRP,MCAST_PORT))

mreq=struct.pack("4sl", socket.inet_aton(MCAST_GRP),socket.INADDR_ANY)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP,mreq)

ttl=struct.pack('b',1)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL,ttl)

while True:
    bytes_rx=sock.recvfrom(1024)
    message=bytes_rx[0].decode()
    address=bytes_rx[1]
    print(message)
    if message=='adios':
        break
sock.close()
