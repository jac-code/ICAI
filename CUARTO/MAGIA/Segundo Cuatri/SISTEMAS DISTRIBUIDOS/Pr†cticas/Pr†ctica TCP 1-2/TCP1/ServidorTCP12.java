import java.net.*;
import java.io.*;
import java.io.DataInputStream;

public class ServidorTCP12
{
	public static void main(String args[])
	{
	if(args.length==1)
	{	
		try{
			int puertoServicio = Integer.parseInt(args[0]);
			ServerSocket escuchandoSocket = new ServerSocket(puertoServicio);
			while(true)
			{
				Socket socketCliente = escuchandoSocket.accept();//escucha peticiones conexion
				Conexion c = new Conexion(socketCliente);
				
				//========EL MENSAJE SE MUESTRA EN LA CLASE CONEXION=========
				
			}
		}catch (IOException e) {System.out.println("Escuchando: " + e.getMessage());}
	}else{
		System.out.println("Por favor, introduce el puerto de trabajo");
	}
}
}