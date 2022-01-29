import java.rmi.*;
import java.rmi.server.*;
class CuentaImpl extends UnicastRemoteObject implements Cuenta {
	private Titular tit; //INICIALIZAMOS LOS ATRIBUTOS DE CADA CUENTA COMO TITULAR Y SALDO INICIALIZADO A 0
	private float saldo = 0;
	CuentaImpl(Titular t) throws RemoteException {
		tit = t;
	}
	////////////////////////////////////////
	////////////////////GETTERS////////////////////
	////////////////////////////////////////////////////////////
	public Titular obtenerTitular() throws RemoteException {
		return tit;
	}
	public float obtenerSaldo() throws RemoteException {
		return saldo;
	}
	////////////////////MÉTODO REMOTO DE OPERACION////////////////////

	public float operacion(float valor) throws RemoteException {
		saldo += valor;
		return saldo;
	}
} 