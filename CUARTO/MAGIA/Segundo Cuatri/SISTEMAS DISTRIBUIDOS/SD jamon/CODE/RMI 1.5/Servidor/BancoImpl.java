import java.util.*;
import java.rmi.*;
import java.rmi.server.*;
class BancoImpl extends UnicastRemoteObject implements Banco {
	List<Cuenta> l;
	//////////////////// IMPLEMENTACION DE LA CLASE BANCO : LA EXTIENDE COMO REMOTA////////////////////
	BancoImpl() throws RemoteException {
		l = new LinkedList<Cuenta>(); //ESPECIFICA LA LISTA DE CUENTAS QUE SE VA A USAR COMO "LINKEDLIST"
	}

	//////////////////// CREA LA CUENTA ////////////////////////////////////////

	public Cuenta crearCuenta(Titular t) throws RemoteException {
		Cuenta c = new CuentaImpl(t);
		l.add(c); //QUEDA AÑADIDA LA CUENTA AL TITULAR DEL BANCO PROVISTO EN EL ARGUMENTO
		return c;
	}
		public List<Cuenta> obtenerCuentas() throws RemoteException { //DEVUELVE LA LISTA DE CUENTAS PARA HACER EL PRINT POR PANTALLA
		return l;
	}
} 