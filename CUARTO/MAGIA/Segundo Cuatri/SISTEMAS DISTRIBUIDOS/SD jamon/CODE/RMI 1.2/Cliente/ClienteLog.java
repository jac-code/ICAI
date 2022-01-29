import java.rmi.*;
import java.rmi.server.*;
class ClienteLog {
 static public void main (String args[]) {
 if (args.length!=3) {
 System.err.println("Uso: ClienteLog hostregistro numPuertoRegistro nombreCliente"); //CONTROL DEL INPUT
 return;
 }
 if (System.getSecurityManager() == null) //INSTANCIA DE SEGURIDAD
 System.setSecurityManager(new SecurityManager());
 try {
 
 ServicioLog srv = (ServicioLog) Naming.lookup("//" + args[0] +":" + args[1] + "/Log");  //RECUPERAMOS LA INSTACIA DEL SERVICIO


 for (int i=0; i<10000; i++)
 srv.log(args[2] + " " + i); //SE EJECUTA EN BUCLE 9999 VECES
 }
 //CATCH DE EXCEPCIONES//
 catch (RemoteException e) {
 System.err.println("Error de comunicacion: " + e.toString());
 }
 catch (Exception e) {
 System.err.println("Excepcion en ClienteLog:");
 e.printStackTrace();
 }
 }
} 