//SERVIDOR

import java.net.*;
import java.io.*;
public class ServidorTCP
{
	public static void main(String args[ ])
	{
	 try{
		 int puertoServicio = 7896;
		 ServerSocket escuchandoSocket = new ServerSocket(puertoServicio);
		 while (true)
			{
				Socket socketCliente = escuchandoSocket.accept(); //eschuca peticiones conexión
				Conexion c = new Conexion(socketCliente);
			}
		}catch (IOException e) 
			{System.out.println("Escuchando: " + e.getMessage());}
	}
}