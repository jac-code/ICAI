import java.rmi.*;
import java.rmi.server.*;
class ClienteBanco {
	static public void main (String args[]) {
		if (args.length!=3) 
		{				//Control del número de eargumentos
			System.err.println("Uso: ClienteChat hostregistro numPuertoRegistro nombreCuenta");
			return;
		}
		if (System.getSecurityManager() == null)		//Control de permisos
			System.setSecurityManager(new SecurityManager());
		try {		
			//Invocamos al método remoto
			Banco srv = (Banco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Banco");
			Cuenta c = srv.crearCuenta(args[2]); //Creamos cuenta
			c.operacion(30);	//Sumamos 30 Euros
			System.out.println(c.obtenerNombre() + ": " + c.obtenerSaldo()); 
		}catch (RemoteException e) {	//Capturamos error remoto
			System.err.println("Error de comunicacion: " + e.toString());
		}catch (Exception e) {		//Capturamos otros tipos de error
			System.err.println("Excepcion en ClienteChat:");
			e.printStackTrace();
		}
	} 
}