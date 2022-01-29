import java.rmi.*;
import java.rmi.server.*;
class ClienteEco 
{
	 static public void main (String args[]) 
	 {
	 	if (args.length<2) 
	 	{
	 		System.err.println("Uso: ClienteEco hostregistro numPuertoRegistro "); //Se comprueba la correcta ejecución
	 		return;
	 	}
		if (System.getSecurityManager() == null)
	        System.setSecurityManager(new SecurityManager());  //Control de permisos de ejecución
		try 
	 	{
	 		ServicioEco srv = (ServicioEco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Eco"); //Se instancia el servicio Eco
		 	for (int i=2; i<args.length; i++)
		 		System.out.println(srv.eco(args[i])); // Se imprime el resultado
		}
	 	catch (RemoteException e) 
	 	{
	 		System.err.println("Error de comunicacion: " + e.toString());
	 	}
	 catch (Exception e)
	 	{
	 		System.err.println("Excepcion en ClienteEco:");
	 		e.printStackTrace();
	 	}
	 }
} 