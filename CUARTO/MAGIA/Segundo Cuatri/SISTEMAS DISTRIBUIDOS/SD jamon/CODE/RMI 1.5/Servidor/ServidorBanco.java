import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
class ServidorBanco {
	static public void main (String args[]) {
		if (args.length!=1) 
		{			
			System.err.println("Uso: Servidor numPuertoRegistro "); // CONTROL DEL INPUT
			return;
		}
		if (System.getSecurityManager() == null) 	//INSTANCIA DE PERMISOS DE SEGURIDAD
			System.setSecurityManager(new RMISecurityManager());

		try {	
			
			//////////////////// INICIALIZACIÓN DEL RMIREGISTRY ////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////
			Registry registry = LocateRegistry.createRegistry(Integer.parseInt(args[0]));
			////////////////////////////////////////////////////////////////////////////////

			BancoImpl srv = new BancoImpl(); //INICIALIZA EL SERVICIO REMOTO IMPLEMENTADO DEL BANCO
			Naming.rebind("rmi://localhost:" + args[0] + "/Banco", srv);  //GUARDA LA REFERENCIA EN EL RMIREGISTRY MEDIAANTE EL NAMING

			////////////////////CAPTURAMOS LAS EXCEPTIONES ////////////////////
			//////////////////////////////////////////////////////////////////

		}catch (RemoteException e) {	//EXCEPTIONS REMOTAS
			System.err.println("Error de comunicacion: " + e.toString());
			System.exit(1);
		}catch (Exception e) {		//EXCEPTIONS EGNERICAS
			System.err.println("Excepcion en ServidorChat");
			e.printStackTrace();
			System.exit(1);
		}
	}
} 