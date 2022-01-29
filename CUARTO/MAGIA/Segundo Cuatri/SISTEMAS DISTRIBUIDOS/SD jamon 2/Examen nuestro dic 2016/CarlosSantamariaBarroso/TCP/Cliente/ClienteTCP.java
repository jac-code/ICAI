//CLIENTE

import java.net.*;
import java.io.*;

public class ClienteTCP
{
	public static void main(String args[ ])
	{
	// los argumentos proporcionan el mensaje y el nombre del host destino
		//Como vamos a enviar objetos, y no datos, necesitaremos las cases ObjectInputStream y ObjectOutputStream
		try{ 	

			int puertoServicio = 7896;
			Socket s = new Socket(args[1], puertoServicio);
			//DataInputStream entrada = new DataInputStream(s.getInputStream());
			//DataOutputStream salida = new DataOutputStream(s.getOutputStream());
			ObjectOutputStream salida = new ObjectOutputStream(s.getOutputStream());
			ObjectInputStream entrada = new ObjectInputStream(s.getInputStream());

			Persona p = new Persona("Carlos",22,0); //Nos creamos la instancia

			salida.writeObject(p); //Metemos en la salida el objeto Persona...
			
			Object personaModificada = (Persona)entrada.readObject(); //Leemos del servidor la persona modificada
			
			
			//Aqui mostramos la informacion de ambas para ver que han cambiado los envios
			
			System.out.println(p.toString());

			System.out.println(personaModificada.toString());
			
			s.close();
			
			} catch (UnknownHostException e) 
				{System.out.println("Socket: " + e.getMessage());} 
			  catch (EOFException e) 
				{System.out.println("EOF: " + e.getMessage());}
			  catch (IOException e) 
				{System.out.println("IO: " + e.getMessage());}
	}
}	