from flask import Flask, request
import json
import requests
import time
import hashlib


import blockchain as blockchain_class
import block

app = Flask(__name__)

blockchain_global = blockchain_class.Blockchain()
peers = set()

@app.route("/")
def index():
    return "BIENVENIDO A LA API REST PARA LA PRÁCTICA DE BLOCKCHAIN"

@app.route("/new_transaction", methods = ['POST'])
def new_transaction():
    datos = request.get_json()
    
    autor = datos['author']
    contenido = datos['content']
    
    if autor == '' or contenido == '':
        return "Invalid data", 404
    else:
        timestamp = time.time()
        datos["time"] = timestamp
        blockchain_global.add_new_transaction(datos)
        return "Success", 201

@app.route("/chain", methods=['GET'])
def get_chain():
    global blockchain_global, peers
    
    diccionario = {}
    diccionario["length"] = len(blockchain_global.chain)
    diccionario["chain"] = [b.__dict__ for b in blockchain_global.chain]
    diccionario["peers"] = list(peers)
    
    return diccionario

@app.route("/mine", methods=['GET'])
def mine():
    global blockchain_global, peers
    index = 0
    
    # miramos si hace falta actualizar cadena
    if consensus():
        print("La cadena no era la más larga --> la hemos actualziado")
    else:
        print("nos quedeamos con la cadena actual")
    
    unconfirmed_transactions_backup = blockchain_global.unconfirmed_transactions
    
    out = blockchain_global.mine()
    if out == False:
        print("No hay transacciones para validar")
        return "No hay transacciones que validar"
    else:
        index = out
        print("Block mined: " + str(index))
        
        # hay una cadena MÁS larga --> ha minado a la vez y es mas grande
        if consensus() == True:
            print("Consensus despues de minado, no era la más larga")

            # restaurar la transacciones
            blockchain_global.unconfirmed_transactions = unconfirmed_transactions_backup

            return "El bloque ha sido descartado, hay que minar de nuevo"
        else:
            print("Consensus despues de minado, si era la más larga")
            announce_new_block(blockchain_global.chain[index], request)

            return "El bloque se ha minado exitosamente, indice del bloque: " + str(index)

@app.route("/pending_transactions", methods=['GET'])
def pending_transactions():
    return str(blockchain_global.unconfirmed_transactions)

@app.route("/register_new_node", methods = ['POST'])
def register_new_node():
    datos = request.get_json()
    
    node_ip = datos['new_node_address']
    
    if node_ip == '' :
        return "Invalid data", 404
    else:
        peers.add(node_ip)
        return get_chain()

@app.route("/add_peer", methods = ['POST'])
def update_peers_after_new_node_enters_blockchain_global():
    global peers
    datos = request.get_json()
    
    new_node = datos['new_node_address']
    
    if new_node == '' :
        return "Invalid data", 404
    else:
        peers.add(new_node)
    
@app.route("/register_with_existing_node", methods = ['POST'])
def register_with_existing_node():
    # para poder cambiar el valor de la variable global
    global peers, blockchain_global
    
    datos = request.get_json()
    node_ip_existente_en_la_red = datos['node_address']
    
    if node_ip_existente_en_la_red == '' :
        return "Invalid data", 404
    
    data = {"new_node_address": request.host}
    headers = {'Content-Type': "application/json"}
    
    url = f"http://{node_ip_existente_en_la_red}/register_new_node"
    response = requests.post(url, data=json.dumps(data), headers=headers)
    
    if response.status_code == 200:
        chain_dump = response.json()['chain']
        peer_dump = response.json()['peers']
        
        # para poder hacer uso de las funciones de blockchain_global
        nueva_blockchain_global = blockchain_class.Blockchain()
        cont = 0
        
        # cadena del nuevo nodo
        for bloque in chain_dump:
            indice = int(bloque["index"])
            transacciones = bloque["transactions"]
            timestamp = bloque["timestamp"]
            previous_hash = bloque["previous_hash"]
            current_hash = bloque["current_hash"]
            
            # necesitmaos crear un nuevo bloque para añadir a la cadena
            nuevo_bloque = block.Block(indice, transacciones, timestamp, previous_hash)
            
            # mirar si es bloque génensis o no --> por el nonce
            if cont != 0:
                nonce = int(bloque["nonce"])
                nuevo_bloque.nonce = nonce

                if nueva_blockchain_global.append_block(current_hash, nuevo_bloque) == False:
                    return "Invalid chain", 404
            else:
                nuevo_bloque.current_hash = current_hash
                nueva_blockchain_global.add_genesis_block(nuevo_bloque)
            
            cont = cont + 1
            
        # hay que añadir TODOS menos la propia IP
        for peer in peer_dump:
            if peer != request.host:
                peers.add(peer)
        
        # añadir el nodo que estaba en la red
        peers.add(node_ip_existente_en_la_red)
        
        for peer in peers:
            if peer != request.host:
                if peer != node_ip_existente_en_la_red:
                    data_peer = {"new_node_address": request.host}
                    headers_peer = {'Content-Type': "application/json"}

                    url = f"http://{peer}/add_peer"
                    response = requests.post(url, data=json.dumps(data_peer), headers=headers_peer)
                    
        
        blockchain_global = nueva_blockchain_global
            
        return "Registration successful", 200
    else:
        return response.content, response.status_code
        
@app.route("/add_block", methods = ['POST'])
def add_block_from_other_nodes_to_add_to_current_blockchain_global():
    global blockchain_global, peers
    
    datos = request.get_json()
    
    index = datos['index']
    transactions = datos['transactions']
    timestamp = datos['timestamp']
    previous_hash = datos['previous_hash']
    current_hash = datos['current_hash']
    
    nuevo_bloque = block.Block(index, transactions, timestamp, previous_hash)
    nuevo_bloque.nonce = datos['nonce']
    
    if blockchain_global.append_block(current_hash, nuevo_bloque):
        return "Block appended to the chain", 201
    else:
        return "Block discarded", 400
    
def announce_new_block(new_mined_block, request: Flask.request_class):
    for peer in peers:
        if peer != request.host:
            data = json.dumps(new_mined_block.__dict__,sort_keys=True)
            headers = {'Content-Type': "application/json"}
            url = f"http://{peer}/add_block"
            
            response = requests.request("POST", url, data=data, headers=headers)

def consensus():
    global blockchain_global, peers
    
    longest_chain = None
    current_chain_len = len(blockchain_global.chain)
        
    for peer in peers:
        url = f"http://{peer}/chain"
        print(url)
        data = {}
        header = {}
        response = requests.request("GET", url, headers=header, data=data)

        if response.status_code == 200:
            response_chain_length = response.json()["length"]
            response_chain = response.json()["chain"]

        # la cadena enconctrada tiene una mayor longitud
        if response_chain_length > current_chain_len:
            longest_chain = response_chain
            current_chain_len = response_chain_length
    
    
    # se ha llegado a conseenso -> hay que actualizar la cadena
    # porque no es la más larga
    if longest_chain:
        blockchain_global = longest_chain
        return True
        
    return False
    
if __name__ == '__main__':
    app.run(port=8085)