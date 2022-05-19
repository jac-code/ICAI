import block
import json
import time

class Blockchain():
    def __init__(self, difficulty=2):
        """
        difficulty --> para que solo ponga dos ceros en el hash
        """
        self.unconfirmed_transactions = []
        self.chain = []
        self.create_genesis_block()
        self.difficulty = difficulty
        
    def create_genesis_block(self):
        genesis_block = block.Block(0, [], time.time(), "0")
        genesis_block.current_hash = genesis_block.compute_hash()
        self.chain.append(genesis_block)
        
    def add_genesis_block(self, genesis_block):
        # borramos el bloque de geneisis incicial y metemos el del otro nodo
        self.chain[0] = genesis_block
    
    def proof_of_work(self, bloque_nuevo):
        bloque_nuevo.nonce = 0 # añadimos atributo nonce
        while(True):
            hash_del_bloque = bloque_nuevo.compute_hash()
            first_caracters = hash_del_bloque[0 : (self.difficulty)]

            if first_caracters != "0"*self.difficulty:
                bloque_nuevo.nonce += 1
            else:
                break
        return hash_del_bloque
    
    def is_valid_proof(self, nuevo_hash, bloque):
        # hash del bloque = nuevo_hash
        
        if bloque.compute_hash() == nuevo_hash:
            hash_del_bloque = nuevo_hash
            first_caracters = hash_del_bloque[0 : (self.difficulty)]
            if first_caracters == "0"*self.difficulty:
                return True
            else:
                return False
        else:
            return False
    
    def append_block(self, nuevo_hash, bloque):
        if bloque.previous_hash == self.last_block.current_hash:
            if self.is_valid_proof(nuevo_hash, bloque):
                bloque.current_hash = nuevo_hash
                self.chain.append(bloque)
                return True
            else:
                return False
        else:
            return False
    
    def add_new_transaction(self, transaction):
        self.unconfirmed_transactions.append(transaction)
            
    @property
    def last_block(self):
        return self.chain[-1]
    
    # validar bloque con transaccion sin confirmar
    def mine(self):
        if len(self.unconfirmed_transactions) == 0:
            return False
        else:
            new_block = block.Block(index = self.last_block.index + 1, transactions = self.unconfirmed_transactions, timestamp = time.time(), previous_hash = self.last_block.current_hash)
            new_hash = self.proof_of_work(new_block)
            if self.append_block(new_hash, new_block):
                self.unconfirmed_transactions = []
                return new_block.index
            else:
                return False
    
    def check_chain(self, blockchain):
        cont = 0
        for block in blockchain:
            if cont != 0:
                block_anterior = blockchain[cont-1]
                current_hash_check = block.current_hash
                delattr(block, "current_hash")

                if self.is_valid_proof(current_hash_check, block):
                    if block.previous_hash == block_anterior.current_hash:
                        block.current_hash = current_hash_check
                        return True
                    else:
                        False
                else:
                    False
            cont = cont + 1