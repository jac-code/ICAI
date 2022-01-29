import java.rmi.*;
interface Cliente extends Remote {
 void notificacion(String apodo, String m) throws RemoteException; //SE NOTIFICA DE FORMA REMOTA , ENE ESTE FICHERO SOLO SE DECLARA EL MÉTODO REMOTO,LUEGO SE PROGRAMA EN EL "CLIENTEIMPLEMENTADO"
} 
