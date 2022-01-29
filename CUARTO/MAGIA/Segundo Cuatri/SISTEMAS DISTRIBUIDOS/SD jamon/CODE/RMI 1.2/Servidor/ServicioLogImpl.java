import java.io.*;
import java.rmi.*;
import java.rmi.server.*;

class ServicioLogImpl extends UnicastRemoteObject implements ServicioLog {
 PrintWriter fd;
 ServicioLogImpl(String f) throws RemoteException {
 try {
 fd = new PrintWriter(f); //SERVIRÁ PARA ESCRIBIR EN EL .TXT A TRAVÉS DEL PRINTWRITER COMO INSTANCIA
 }
 catch (FileNotFoundException e) { //COGEMOS LAS POSIBLES EXCEPCIONES DE QUE NO ENCUENTRE EL ARCHIVO
 System.err.println(e);
 System.exit(1);
 }
 }
 public synchronized void log(String m) throws RemoteException { //EL METODO DEBE ESTAR SINCRONIZADO!
 System.out.println(m);
 fd.println(m);
 fd.flush(); // para asegurarnos de que no hay buffering
 }
} 
