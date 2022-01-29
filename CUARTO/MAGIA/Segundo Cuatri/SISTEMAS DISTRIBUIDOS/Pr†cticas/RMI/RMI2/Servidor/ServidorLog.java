import java.rmi.*; 
import java.rmi.server.*; 
class ServidorLog  { 
    static public void main (String args[]) { 
       if (args.length!=2) { 
            System.err.println("Uso: ServidorLog numPuertoRegistro ficheroLog"); 
            return; 
        } 
        if (System.getSecurityManager() == null) { 
            System.setSecurityManager(new RMISecurityManager()); 
        } 
        try { 
          // SE DEFINE EL SERVICIO DE LOG. (ServicioLogImpl  srv ) 
          // a ServicioLogImpl se le pasa como argumento de entrada, el nombre del 
          // fichero sobre el que se escribe 
          //... 
            ServicioLogImpl srv = new ServicioLogImpl(args[1]); 
            Naming.rebind("rmi://localhost:" + args[0] + "/Log", srv); 

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