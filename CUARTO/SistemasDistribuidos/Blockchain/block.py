import json
import hashlib

class Block():
    def __init__(self, index, transactions, timestamp, previous_hash):
        """
        Constructor for the class Block
        index --> unique ID number for the block
        transaction --> LIST of transaction
        timestamp --> creation time of the Block
        previous_hash --> hash value of the previous Block

        """
        self.index = index
        self.transactions = transactions
        self.timestamp = timestamp
        self.previous_hash = previous_hash
        
    
    def compute_hash(self):
        """
        calculate hash --> hash sobre toda la información del bloque
        """
        # creamos un json del bloque 
        block_string = json.dumps(self.__dict__, sort_keys = True)
        
        # creamos hash del json creado
        hashed_block_string = hashlib.sha256(block_string.encode('utf-8')).hexdigest()
        
        return hashed_block_string