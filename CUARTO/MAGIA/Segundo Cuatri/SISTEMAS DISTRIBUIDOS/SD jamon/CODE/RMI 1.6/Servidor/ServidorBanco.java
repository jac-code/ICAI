import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
class ServidorBanco {
	static public void main (String args[]) {
		if (args.length!=1) 
		{			
			System.err.println("Uso: Servidor numPuertoRegistro "); //CONTROL DEL INPUT
			return;
		}
		if (System.getSecurityManager() == null) 	//INSTANCIA DE SEGURIDAD
			System.setSecurityManager(new RMISecurityManager());
		try {		
			Registry registry = LocateRegistry.createRegistry(Integer.parseInt(args[0])); //INICIALIZO EL RMIREGISTRY EN FUNCIÓN AL PUERTO ESTABLECIDO COMO ARGUMENTO EN LA CONSOLA

			BancoImpl srv = new BancoImpl(); //INICIALIZO EL SERVICIO REMOTO IMPLEMENTADO DEL BANCO
			Naming.rebind("rmi://localhost:" + args[0] + "/Banco", srv); //GUARDO LA REFERENCIA REMOTA DEL SERVICIO DE BANCO EN EL RMIREGISTRY

			//HAGO LOS CATCHS PRECISOS PARA CAPTURAR EXCEPTIONS//
		}catch (RemoteException e) {	//CAPTURO EXPEPCIONES DERIVADAS DEL SISTEMA REMOTO
			System.err.println("Error de comunicacion: " + e.toString());
			System.exit(1);
		}catch (Exception e) {		//CAPTUR EXCEPCIONES DERIVADAS DEL SERVIDOR (DE BANCA)  
			System.err.println("Excepcion en Servidor de Banco");
			e.printStackTrace();
			System.exit(1);
		}
	}
} 