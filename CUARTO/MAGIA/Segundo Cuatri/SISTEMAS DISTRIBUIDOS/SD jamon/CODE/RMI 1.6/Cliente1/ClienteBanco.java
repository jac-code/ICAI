import java.rmi.*;
import java.rmi.server.*;
import java.util.*;
class ClienteBanco {
	static public void main (String args[]) {
		if (args.length!=5) 
		{				
			System.err.println("Uso: ClienteBanco hostregistro numPuertoRegistro nombreTitular idTitular tutor"); //CONTROL DEL INPUT
			return;
		}
		if (System.getSecurityManager() == null)		//INSTANCIAC DE SEGURIDAD
			System.setSecurityManager(new SecurityManager());
		try {		

			Banco srv = (Banco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Banco");  //OBTENERMOS LA REFERNCIA AL SERVICIO DE BANCO
			Titular tit = new TitularMenor(args[2], args[3], args[4]);	//SE CREA EL OBJETO DE TITULAR MENOR
			Cuenta c = srv.crearCuenta(tit);		//SE CREA LA CUENTA DEL TITULAR MENOS
			c.operacion(20);		//SUMAMOS 20 EUROS A LA CUENTA INICIALIZADA CON 0 PARA INICIALIZARLA CON 20
			List <Cuenta> l;
			l = srv.obtenerCuentas();	//SE OBTIENE LA LISTA DE CUENTAS
			//SE VAN ITERANDO Y HACIENDO EL PRINT POR PANTALLA DE LA TERMINAL O CONSOLA DE COMANDOS
			for (Cuenta i: l) {			
				Titular t = i.obtenerTitular();		
				System.out.println(t + ": " + i.obtenerSaldo());	
			} 
			////////////////////RECOGIDA DE EXCEPTIONS ////////////////////

		}catch (RemoteException e) {	//SI ES PROBLEMA DE LA INVOCACIÓN REMOTA
			System.err.println("Error de comunicacion: " + e.toString());
		}catch (Exception e) {		//SI ES PROBLEMA DE OTRA COSA
			System.err.println("Excepcion en ClienteChat:");
			e.printStackTrace();
		}
	} 
}