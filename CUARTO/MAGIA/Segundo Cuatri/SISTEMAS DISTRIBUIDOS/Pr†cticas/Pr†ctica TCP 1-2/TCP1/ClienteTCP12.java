import java.net.*;
import java.io.*;
import java.util.Scanner;
import java.io.DataInputStream;
import java.io.DataOutputStream;

public class ClienteTCP12
{
	public static void main(String args[])	
	{
	if(args.length==2)
	{
		//los argumentos proporcionan el mensaje
		try{

			int puertoServicio = Integer.parseInt(args[1]);
			String cadena=null;
			String fin="exit";
			

			do{
				Socket s = new Socket(args[0],puertoServicio);
				DataInputStream entrada = new DataInputStream(s.getInputStream());
				DataOutputStream salida = new DataOutputStream(s.getOutputStream());
				System.out.println("Por favor, introduzca el mensaje que desee: ");
				Scanner sc = new Scanner(System.in);
				cadena = sc.nextLine();

				salida.writeUTF(cadena); //UTF es una condicion de strings, ir a Sec. 4.3
				//En vez de args[0], debe ir el mensaje
				String datos = entrada.readUTF();
				System.out.println("Recibido: " + datos);
				s.close();
			}while(cadena.compareTo(fin) != 0);
			

			
		}catch ( UnknownHostException e)
			{System.out.println("Socket: " + e.getMessage());
		}catch ( EOFException e)
			{System.out.println("EOF: " + e.getMessage());
		}catch ( IOException e)
			{System.out.println("IO: " + e.getMessage());
		}
	}else{
		System.out.println("Por favor, introduce el servidor y el puerto");
	}
}
}		

