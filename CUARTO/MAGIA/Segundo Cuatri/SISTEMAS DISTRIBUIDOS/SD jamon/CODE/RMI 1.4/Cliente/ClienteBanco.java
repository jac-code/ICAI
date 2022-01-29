import java.rmi.*;
import java.rmi.server.*;
class ClienteBanco {
	static public void main (String args[]) {
		if (args.length!=3) 
		{				
			System.err.println("Uso: ClienteChat hostregistro numPuertoRegistro nombreCuenta"); //NOS ASEGURAMOS DE QUE LOS ARGUMENTOS SON LOS CORRECTOS
			return;
		}
		//INSTANCIAMOS LA SEGURIDAD
		if (System.getSecurityManager() == null)		
			System.setSecurityManager(new SecurityManager());
		try {		
			//SE INVOCA EL MÉTODO REMOTO
			Banco srv = (Banco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Banco"); //busca el sevicios de banca en el rmiresgistrry 
			Cuenta c = srv.crearCuenta(args[2]); //Creamos cuenta inicialmente con 30 euros
			c.operacion(30);	//+ 30 Euros
			System.out.println(c.obtenerNombre() + ": " + c.obtenerSaldo()); 
		}catch (RemoteException e) {	//HACEMOS EL CATCH DEL REMOTE ERROR
			System.err.println("Error de comunicacion: " + e.toString());
		}catch (Exception e) {		//HACEMOS LOS CATCHs DE LAS EXCEPTIONS
			System.err.println("Excepcion en ClienteChat:");
			e.printStackTrace();
		}
	} 
}