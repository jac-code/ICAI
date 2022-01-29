import java.rmi.*;
interface ServicioLog extends Remote { //SERVICIO REMOTO
 void log (String m) throws RemoteException;
} 
