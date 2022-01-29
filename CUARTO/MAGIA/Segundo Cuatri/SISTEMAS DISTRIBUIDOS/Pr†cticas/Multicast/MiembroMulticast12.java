import java.net.*;
import java.io.*;
import java.util.Scanner;

public class MiembroMulticast12{
	public static void main(String args[]){
	//args[0] es el mensaje enviado al grupo y args[1] es la direccion del grupo
	try{
		InetAddress grupo = InetAddress.getByName(args[1]);
		MulticastSocket socket = new MulticastSocket(6789);
		//Se une al grupo
		socket.joinGroup(grupo);
		//envia el mensaje
		//byte[] m = (args[0].getBytes());
		//DatagramPacket mensajeSalida = new DatagramPacket(m,m.length,grupo,6789);
		//socket.send(mensajeSalida);

		byte[] bufer = new byte[1000];
		String linea;
		String nombre = args[0];
		Escucha c = new Escucha(socket);
		//Se queda a la espera de mensajes al grupo, hasta recibir "adios"
		while(true)
		{	
			
			Scanner sc = new Scanner(System.in);
			String cadena = sc.nextLine();
			
			if(cadena.equals("quit"))
			{
				socket.leaveGroup(grupo);
				socket.close();
				System.out.println(nombre + " ha abandonado el grupo.");				
			}

			String total = nombre + ": " + cadena;
			byte[] mens = total.getBytes();
			
			DatagramPacket mensajeSalida = new DatagramPacket(mens,mens.length,grupo,6789);
			socket.send(mensajeSalida);



			//DatagramPacket mensajeEntrada = new DatagramPacket(bufer,bufer.length);
			//socket.receive(mensajeEntrada);
			//linea = new String(mensajeEntrada.getData(),0,mensajeEntrada.getLength());
			//System.out.println("Recibido: "+linea);
			//if(linea.equals("Quit")) break;
		}
		//Si recibe "Quit" abandona el grupo
		//socket.leaveGroup(grupo);


	}catch(SocketException e){
		System.out.println("Socket: " + e.getMessage());

	}catch(IOException e){
		System.out.println("IO: " + e.getMessage());
	}
	}
}