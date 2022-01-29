import java.rmi.*;
import java.rmi.server.*;;



class ServicioCalculadoraImpl extends UnicastRemoteObject implements ServicioCalculadora {
    
	
	ServicioCalculadoraImpl() throws RemoteException 
	{
    super(); // no es necesario declararlo
	}
	
    public int sumar(int a, int b) throws RemoteException 
	{
		return (a + b);
    }

    public int restar(int a, int b) throws RemoteException 
	{
		return (a - b);
    }

    public int multiplicar(int a, int b) throws RemoteException 
	{
		return (a * b);
    }

    public int dividir(int a, int b) throws RemoteException 
	{
		return (a / b);
    }
}
