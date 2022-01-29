import java.rmi.*;
import java.rmi.server.*;
class BancoImpl extends UnicastRemoteObject implements Banco {
	BancoImpl() throws RemoteException {}

	public Cuenta crearCuenta(String nombre) throws RemoteException { //CREAMOS UNA CUENTA INICALMENTE CON 30 EUROS 
		return new CuentaImpl(nombre);
	}
} 