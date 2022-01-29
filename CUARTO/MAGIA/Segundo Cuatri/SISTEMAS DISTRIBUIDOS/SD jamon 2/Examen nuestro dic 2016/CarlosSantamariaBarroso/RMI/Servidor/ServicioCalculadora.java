import java.rmi.*;
import java.rmi.server.*;

interface ServicioCalculadora extends Remote{
	int sumar (int a, int b) throws RemoteException;
	int restar (int a, int b) throws RemoteException;
	int multiplicar (int a, int b) throws RemoteException;
	int dividir (int a, int b) throws RemoteException;
}


