
//java -Djava.security.policy=servidor.permisos ServidorEco 1234

import java.rmi.registry.*;
import java.rmi.*;
import java.rmi.server.*;

class ServidorCalculadora  {
    static public void main (String args[]) throws RemoteException{
				
	   if (args.length!=1) {
            System.err.println("Uso: ServidorCalculadora numPuertoRegistro");
            return;
        }
		
		
		//Se instancia un gestor de seguridad necesario. (necesario en la carga dinámica de clases)
        if (System.getSecurityManager() == null) {
             System.setSecurityManager(new RMISecurityManager());
         }
		
        try {
            //Crea un objeto de la clase que implementa el servicio remoto
			ServicioCalculadoraImpl srv = new ServicioCalculadoraImpl();
			//Se registra o da de alta el objeto remoto, en el rmiregistry mediante el método estático "rebind", 
			//con el nombre de objeto "Eco"
            Naming.rebind("rmi://localhost:" + args[0] + "/Calculadora", srv);
        }
        
		// Parar el rmiregistry, por programa.
		//  UnicastRemoteObject.unexportObject(registry, true);
		catch (RemoteException e) {
            System.err.println("Error de comunicacion: " + e.toString());
            System.exit(1);
        }
        catch (Exception e) {
            System.err.println("Excepcion en ServidorEco:");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
