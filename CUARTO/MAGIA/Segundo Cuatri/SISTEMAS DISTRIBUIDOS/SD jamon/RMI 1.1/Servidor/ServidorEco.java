import java.rmi.*;
import java.rmi.server.*;
class ServidorEco {
 static public void main (String args[]) {
		 if (args.length!=1) {
		 System.err.println("Uso: ServidorEco numPuertoRegistro"); //Control ejecucióm
		 return;
		 }
		 if (System.getSecurityManager() == null) {
		 System.setSecurityManager(new RMISecurityManager());
 }
 try {
		 ServicioEcoImpl srv = new ServicioEcoImpl();
		 Naming.rebind("rmi://localhost:" + args[0] + "/Eco", srv); //Se invoca el métoodo rmi
		 }
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
