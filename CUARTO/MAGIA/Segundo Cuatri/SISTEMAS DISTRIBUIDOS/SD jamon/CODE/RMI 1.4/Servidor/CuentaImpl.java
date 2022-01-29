import java.rmi.*;
import java.rmi.server.*;

class CuentaImpl extends UnicastRemoteObject implements Cuenta {
	private String nombre;
	private float saldo = 0;	//De inicio una cuenta tiene 0€ pero se le sumaran 30 posteriormetne

	//CREAMOS LA CUENTA ON UN NOMBRE DADO COMO ARGUMENTO
	CuentaImpl(String name) throws RemoteException {
		nombre = name;	   
	}

	// DEVUELVE EL NOMBRE DE LA CUENTA PARA EL SYSTEM.OUT.PRINTLN //

	public String obtenerNombre() throws RemoteException 
	{
		return nombre;
	}
		// DEVULEVE EL SALDO DE LA CUENTA PARA EL SYSTEM.OUT.PRITLN //

	public float obtenerSaldo() throws RemoteException 	
	{
		return saldo;
	}
	// SE SUMA EL ARGUMENTO DE LA OPERACION A LA CUENTA DESDE DONDE SE INVOCA //

	public float operacion(float valor) throws RemoteException 
	{
		saldo += valor;	   
		return saldo;
	}
} 
