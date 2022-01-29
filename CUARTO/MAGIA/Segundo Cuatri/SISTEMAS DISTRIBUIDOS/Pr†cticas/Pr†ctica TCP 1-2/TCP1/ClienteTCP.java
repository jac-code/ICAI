import java.net.*;
import java.io.*;
import java.io.DataInputStream;
import java.io.DataOutputStream;
public class ClienteTCP
{
	public static void main(String args[])
	{
	//los argumentos proporcionan el mensaje
	try{
		int puertoServicio = 7896;
		Socket s = new Socket(args[1],puertoServicio);
		DataInputStream entrada = new DataInputStream(s.getInputStream());
		DataOutputStream salida = new DataOutputStream(s.getOutputStream());

		salida.writeUTF(args[0]); //UTF es una condicion de strings, ir a Sec. 4.3
		String datos = entrada.readUTF();
		System.out.println("Recibido: " + datos);
		s.close();
	}catch ( UnknownHostException e)
		{System.out.println("Socket: " + e.getMessage());
	}catch ( EOFException e)
		{System.out.println("EOF: " + e.getMessage());
	}catch ( IOException e)
		{System.out.println("IO: " + e.getMessage());
	}
}
}		

