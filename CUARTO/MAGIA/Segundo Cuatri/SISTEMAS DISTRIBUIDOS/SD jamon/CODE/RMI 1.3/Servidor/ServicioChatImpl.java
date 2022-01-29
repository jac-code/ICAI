import java.util.*; 
import java.io.*; 
import java.rmi.*; 
import java.rmi.server.*; 
class ServicioChatImpl extends UnicastRemoteObject 
implements ServicioChat { 
//Inicialmente se inicializa una lista en la que se almacenaran los clientes
    List<Cliente> l; 
    ServicioChatImpl() throws RemoteException { 
        l = new LinkedList<Cliente>();  //AL INICIALIZAR EL SERVICOR DE SE INVOCA ESTE MÉTODO REMOTO (MÉTODO DE UN UNOCASTEMOTEOBJECT) QUE CREA E INICIALIZA EL LINNKEDLIST DE CLIENTES
    } 
    public void alta(Cliente c) throws RemoteException {   //AL DAR DE ALTA SE AÑADE A LA LISTA
        l.add(c); 
    } 
    public void baja(Cliente c) throws RemoteException {  //AL DAR DE BAJA SE ELIMINA DE LA LISTA
        l.remove(l.indexOf(c)); 
    } 
    //PARA ENVIAR EL MENSAJEPRIERO SE BUSCA EN LA LISTA
    public void envio(Cliente esc, String apodo, String m) 
      throws RemoteException { 
        for (Cliente c: l)  
            if (!c.equals(esc)) 
                c.notificacion(apodo, m); 
    } 
} 
