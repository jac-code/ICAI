import java.io.*;
import java.net.*;

class Conexion extends Thread 
{
	ObjectOutputStream salida;
	ObjectInputStream entrada;
	Socket socketCliente;
	public Conexion (Socket unSocketCliente)
	{
	 try{
		 
		 socketCliente = unSocketCliente;
		 
		 //Al igual que en el cliente nos creamos los canales para el envio y la recepcion de objetos...

		 ObjectOutputStream salida = new ObjectOutputStream(socketCliente.getOutputStream());
		 ObjectInputStream entrada = new ObjectInputStream(socketCliente.getInputStream());
		 
		 this.start(); //Ejecutamos el comando run

		}catch (IOException e) 

		{System.out.println("Conexion: " + e.getMessage());}
	}
	
	public void run() 
	{
	 try{  
			Persona p = (Persona)entrada.readObject(); //lee un objeto del stream
			
			//Ahora modificamos el atributo envios del objeto recibido
			int enviomodificado = p.getEnvios();
			p.setEnvios(enviomodificado + 1);


			salida.writeObject(p); //escribe el objeto modificado en el stream

			socketCliente.close();
			
		}catch (EOFException e) 
			{System.out.println("EOF: " + e.getMessage());}
		 catch (IOException e) 
			{System.out.println("IO: " + e.getMessage());}
	}
}
