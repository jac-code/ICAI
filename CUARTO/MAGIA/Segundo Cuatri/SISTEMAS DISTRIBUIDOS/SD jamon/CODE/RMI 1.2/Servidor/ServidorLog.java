import java.rmi.*;
import java.rmi.server.*;
class ServidorLog {
 static public void main (String args[]) {
 if (args.length!=2) {
 System.err.println("Uso: ServidorLog numPuertoRegistro ficheroLog"); //CONTROL DE ARGUMENTOS DE ENTRADA
 return;
 }
		 if (System.getSecurityManager() == null) {
		 System.setSecurityManager(new RMISecurityManager());
		 }
 try {
		ServicioLogImpl srv = new ServicioLogImpl(args[1]); //SE INICIALIZA EL SERVICIO DE LOG EN EL SERVIDOR EN FUNCIÓN DEL ARGUMENTO 1 CORRESPONDIENTE AL NOMBRE DEL FICHERO QUE SE VA A USAR PARA GUARDAR EL LOG EN TXT
		 Naming.rebind("rmi://localhost:" + args[0] + "/Log", srv); //SE GUARDA LA REFERENCIA AL SERVICIO EN EL REGISTRO REMOTO (RMIREGISTERT)

 }
 ////////////////////REGOGIDA DE EXECPTIONS////////////////////

 catch (RemoteException e) { //EXEPTIONS DE RMI
 System.err.println("Error de comunicacion: " + e.toString());
 System.exit(1);
 }
 catch (Exception e) { //OTRS EXCEPTIONS
 System.err.println("Excepcion en ServidorLog:");
 e.printStackTrace();
 System.exit(1);
 }
 }
} 