import java.rmi.*;
import java.util.*;
////////////////////DECLARA EL INTERFACE REMOTO CON LOS METODOS DE LA CLASE BANCO ////////////////////////////////////////
interface Banco extends Remote {
	Cuenta crearCuenta(Titular t) throws RemoteException;
	List<Cuenta> obtenerCuentas() throws RemoteException;
} 