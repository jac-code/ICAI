import java.rmi.*;
import java.rmi.server.*;
import java.util.*;
class ClienteBanco {
	static public void main (String args[]) {
		if (args.length!=4) 
		{				
			System.err.println("Uso: ClienteBanco hostregistro numPuertoRegistro nombreTitular idTitular"); // INPUT CONTROL
			return;
		}
		if (System.getSecurityManager() == null)		//INSTANCIACIÓN DE SEGURIDAD (PERMISOS CONTROL)
			System.setSecurityManager(new SecurityManager());
		try {		

			Banco srv = (Banco) Naming.lookup("//" + args[0] + ":" + args[1] + "/Banco"); //INVOCACIÓN DE MÉTODO REMOTO POR REFERENCIA MEDIANTE EL REGISTRO DE RMI (RMIREGISTRY)
			Titular tit = new Titular(args[2], args[3]);	//CREACIÓN DE TITULAR A BASE DE ARGUMETNOS DE CONSOLA CORRESPONDIENTES A NOMBRE E ID
			Cuenta c = srv.crearCuenta(tit);		//CREACIÓN DE CUENTA DE TITUAR
			c.operacion(30);		//SUMAMOS 30 A LA CUENTA (0+30=30)
			List <Cuenta> l;
			l = srv.obtenerCuentas();	//INVOCAICÓN AL MÉTODO REMOTO DE LISTAR CUENTAS
			for (Cuenta i: l) {			//SE ITERA PARA SACARLAS E IPRIMIRAS POR PANTALLA DE CONSOLA O TERMINAL DE COMANDOS
				Titular t = i.obtenerTitular();		
				System.out.println(t + ": " + i.obtenerSaldo());	
			} 
		}catch (RemoteException e) {	//ES EXPECTION DE RMI?
			System.err.println("Error de comunicacion: " + e.toString());
		}catch (Exception e) {		//ES EXCEPTION DEL CLIENTE DEL BANCO?
			System.err.println("Excepcion en Cliente de Banco:");
			e.printStackTrace();
		}
	} 
}