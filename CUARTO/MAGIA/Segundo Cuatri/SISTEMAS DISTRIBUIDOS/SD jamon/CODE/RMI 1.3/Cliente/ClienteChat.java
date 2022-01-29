	import java.util.*;
import java.rmi.*;
import java.rmi.server.*;

class ClienteChat {
	 static public void main (String args[]) {
			
			// CONTROLA EL INPUT // 			 
				if (args.length!=3) 
				 {
				 System.err.println("Uso: ClienteChat hostregistro numPuertoRegistro apodo"); //Modo de funcionamiento
				 return;
				 }
			 if (System.getSecurityManager() == null) 
				 System.setSecurityManager(new SecurityManager()); //INSTANCIA LA SEGURIDAD
			 try {

			//recoge el srv del rmiregystry, el srv contiene los metodos de dar de alta, de baja y enviar mensajes//
				 ServicioChat srv = (ServicioChat) Naming.lookup("//" + args[0] + ":" + args[1] + "/Chat");  //SE OBTIENE LA REFERENCIA A LA ISNTANCIA DE SERVICIO REMOTO DEL CHAT

				 ClienteImpl c = new ClienteImpl();//instancia el cliente cuyo único método es "notificar"
				 srv.alta(c); //da de alta el nuuevo cliente 
				 Scanner ent = new Scanner(System.in); // SE OBTIENE EL MENSAJ
				 String apodo = args[2]; //SE OBTIENE EL APDO

				//IMPRIME POR PANTALLA//
				 System.out.print(apodo + "> ");
				 while (ent.hasNextLine())
				 {
					 srv.envio(c, apodo, ent.nextLine()); //SE ENVIA EL MENSAJE
					 System.out.print(apodo + "> ");//imprime por pantalla el apodo
				 }
				 srv.baja(c);   //da de baja el cliente
				 System.exit(0);//finaliza
				 }

	//RECOGE LAS EXCEPTIONS//	
	 catch (RemoteException e) {
		 System.err.println("Error de comunicacion: " + e.toString());
		 }
		 catch (Exception e) {
		 System.err.println("Excepcion en ClienteChat:");
	 e.printStackTrace();
	 }
 } 
}
