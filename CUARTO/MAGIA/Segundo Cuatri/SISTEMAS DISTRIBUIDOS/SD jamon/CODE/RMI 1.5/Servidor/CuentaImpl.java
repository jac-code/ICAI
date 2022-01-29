import java.rmi.*;
import java.rmi.server.*;
class CuentaImpl extends UnicastRemoteObject implements Cuenta {
	private Titular tit; //Arrancamos el titular, con sus atributos
	private float saldo = 0;
	CuentaImpl(Titular t) throws RemoteException {
		tit = t;
	}
	public Titular obtenerTitular() throws RemoteException {
		return tit; //Getters
	}
	public float obtenerSaldo() throws RemoteException {
		return saldo; //Getters
	}
	public float operacion(float valor) throws RemoteException {
		saldo += valor; //Operaciones
		return saldo;
	}
} 