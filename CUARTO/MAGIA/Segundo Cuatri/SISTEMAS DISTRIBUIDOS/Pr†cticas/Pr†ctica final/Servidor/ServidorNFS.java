import java.net.*;
import java.io.*;
import java.util.*;

public class ServidorNFS
{
	public static void main(String args[])
	{	
		
		String command ;
    	Process proc ;

		try
		{
			//Después de instalar NFS, creamos una carpeta donde se van a compartir todos nuestros archivos
			command = "sudo mkdir /compartido";

			proc = Runtime.getRuntime().exec(command);

			//Damos permisos...
	    	command = "sudo chown nobody:nogroup /compartido";

			proc = Runtime.getRuntime().exec(command);

			command = "sudo chmod -R 777 /compartido";

		
			proc = Runtime.getRuntime().exec(command);

			command = "sudo /etc/init.d/nfs-kernel-server restart";

			proc = Runtime.getRuntime().exec(command);

		}catch (Exception e)
		{
			/* Lanzamos una excepción genérica en caso de error de ejecución */
			System.out.println("ERROR");
		}
	}
}