import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
class ServidorBanco {
	static public void main (String args[]) {
		if (args.length!=1) 
		{			//Control del número de argumentos
			System.err.println("Uso: Servidor numPuertoRegistro ");
			return;
		}
		if (System.getSecurityManager() == null) 	//Seguridad requerida
			System.setSecurityManager(new RMISecurityManager());
		try {		//Try catch para capturar los posibles errores
			Registry registry = LocateRegistry.createRegistry(Integer.parseInt(args[0]));  //Arrancamos rmiregistry 
			BancoImpl srv = new BancoImpl();
			Naming.rebind("rmi://localhost:" + args[0] + "/Banco", srv);  //METEMOS LA REFERENCIA DEMOTA DEL SERVICIO DE BANCO IMPLEMENTADO EN EL RMIREGISTRY QUE LUEGO USARÁ EL CLIENTE 
			//Hacemos uso de Naming
		}catch (RemoteException e) {	//Capturamos error de RMI
			System.err.println("Error de comunicacion: " + e.toString());
			System.exit(1);
		}catch (Exception e) {		//Capturamos otros tipos de error
			System.err.println("Excepcion en ServidorChat");
			e.printStackTrace();
			System.exit(1);
		}
	}
} 