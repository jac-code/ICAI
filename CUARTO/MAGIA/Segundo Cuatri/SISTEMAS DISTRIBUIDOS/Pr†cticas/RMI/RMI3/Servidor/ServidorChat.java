import java.rmi.*; 
import java.rmi.server.*; 
class ServidorChat  { 
    static public void main (String args[]) { 
       if (args.length!=1) { 
            System.err.println("Uso: Servidor numPuertoRegistro"); 
            return; 
        } 
        if (System.getSecurityManager() == null) { 
            System.setSecurityManager(new RMISecurityManager()); 
        } 
        try { 
          // SE DEFINE EL SERVICIO DE CHAT. (ServicioChatImpl  srv ) 
          // a ServicioChatImpl se le pasa como argumento de entrada, el nombre del 
          // fichero sobre el que se escribe 
          //... 
            ServicioChatImpl srv = new ServicioChatImpl(); 
            Naming.rebind("rmi://localhost:" + args[0] + "/Chat", srv); 

        } 
        catch (RemoteException e) { 
            System.err.println("Error de comunicacion: " + e.toString()); 
            System.exit(1); 
        } 
        catch (Exception e) { 
            System.err.println("Excepcion en ServidorLog:"); 
            e.printStackTrace(); 
            System.exit(1); 
        } 
    } 
} 