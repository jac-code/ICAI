import java.rmi.*;
//INTERFACE QUE ESPECIFICA LOS MÉTODOS QUE SE VAN A UTILIZAR
interface ServicioChat extends Remote {
	
 void alta(Cliente c) throws RemoteException; //da de alta al cliente 
 void baja(Cliente c) throws RemoteException; //da de baja el cliente
 void envio(Cliente c, String apodo, String m) throws RemoteException; //envia un mensaje 
} 
