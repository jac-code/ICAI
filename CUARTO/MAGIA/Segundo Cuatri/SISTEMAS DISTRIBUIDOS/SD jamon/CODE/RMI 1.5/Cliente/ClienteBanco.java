import java.rmi.*;
import java.rmi.server.*;
import java.util.*;
class ClienteBanco {
	static public void main (String args[]) {
		if (args.length!=4) 
		{				
			System.err.println("Uso: ClienteBanco hostregistro numPuertoRegistro nombreTitular idTitular"); //CONTROLA QUE EL NÚMERO DE ARGUMENTOS PROVISTOS SEA EL CORRECTO
			return;
		}
		if (System.getSecurityManager() == null)		//SE INSTANCIA LA SEGURIDAD
			System.setSecurityManager(new SecurityManager());
		try {		

			Banco srv = (Banco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Banco"); //SE INVOCA EL MÉTODO REMOTO DEL BANCO
			Titular tit = new Titular(args[2], args[3]);	//SE CREA UN TITULAR DE LA CUENTA A PARTIR DE LOS ARGUMENTOS PASADOS POR LA CONSOLA DE COMANDOS
			Cuenta c = srv.crearCuenta(tit);		//SE CREA UNA CUENTA A PARTIR DEL TITULAR
			c.operacion(30);		//INCIALIZAMOS LA CUENTA A 30 EUROS (0 + 30)
			List <Cuenta> l;
			l = srv.obtenerCuentas();	//A PARTIR DEL SERVICIO "BANCO" LLAAMOS AL MÉTODO REMOTO "OBTENER CUENTAS" QUE LAS LISTARÁ Y ALMACENARÁ EN EL LIST "l"
			for (Cuenta i: l) { //SE LLEVAN A CABO LAS ITERACIONES NECESARIAS (EN FUNCIÓN DEL NÚMERO DE CUENTAS) PARA OBTENER LOS NOMBRES DE LOS TITULARES
				Titular t = i.obtenerTitular();		//SE OBTENDRÁN LOS NOMBRES DE LOS TITULARES DE CADA CUENTA
				System.out.println(t + ": " + i.obtenerSaldo());	//SE HACE EL PRINTLN POR PANTALL DEL TERMINAL DE COMANDOS DEL NOMBRE DEL TITULAR DE LA CUENTA JUNTO CON SU SALDO
			} 
			//SE RECOGEN LAS EXCEPTIONS (CATCH)

		}catch (RemoteException e) {	//EXCEPTION REMOTA
			System.err.println("Error de comunicacion: " + e.toString());
		}catch (Exception e) {		//EXCEPTION GENÉRICA (PARA HACER EL CATCH DE RECOGIDA DE LAS DEMÁS EXCEPTIONS)
			System.err.println("Excepcion en ClienteChat:");
			e.printStackTrace();
		}
	} 
}