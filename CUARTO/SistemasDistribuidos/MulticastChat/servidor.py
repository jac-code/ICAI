import socket
import threading

# para un escenario real sería la IP privada aqui
HOST = '127.0.0.1'
PORT = 6780

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))

server.listen()

# van a estar en mismo orden y posición
clients = []
usernames = []

def broadcast(message):
    for client in clients:
        client.send(message)

def handle(client):
    while True:
        try:
            message = client.recv(1024)
            broadcast(message)
        except:
            index = clients.index(client)
            clients.remove(client)
            client.close()

            # podemos hacer esto porque están en misma posición que los clientes
            username = usernames[index]
            usernames.remove(username)
            break

def receive():
    while True:
        # se acepta la conexión
        client, address = server.accept()
        print(f"Connected with {str(address)}")

        client.send("JAIME".encode('utf-8'))
        username = client.recv(1024)

        usernames.append(username)
        clients.append(client)

        print(f"Username of client is {username}")
        # avisamos a todos de que esta conectado
        broadcast(f"{username} connected to th server!!\n".encode('utf-8'))
        client.send("Connected to the server.".encode('utf-8'))

        # la gestión de thread lo hacemos en a función handle
        thread = threading.Thread(target=handle, args=(client,))
        thread.start()

print('Server running...')
receive()