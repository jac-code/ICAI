import java.net.*;
import java.io.*;
public class MiembroMulticast{
	public static void main(String args[]){
	//args[0] es el mensaje enviado al grupo y args[1] es la direccion del grupo
	try{
		InetAddress grupo = InetAddress.getByName(args[1]);
		MulticastSocket socket = new MulticastSocket(6789);
		//Se une al grupo
		socket.joinGroup(grupo);
		//envia el mensaje
		byte[] m = args[0].getBytes();
		DatagramPacket mensajeSalida = new DatagramPacket(m,m.length,grupo,6789);
		socket.send(mensajeSalida);

		byte[] bufer = new byte[1000];
		String linea;
		//Se queda a la espera de mensajes al grupo, hasta recibir "adios"
		while(true)
		{
			DatagramPacket mensajeEntrada = new DatagramPacket(bufer,bufer.length);
			socket.receive(mensajeEntrada);
			linea = new String(mensajeEntrada.getData(),0,mensajeEntrada.getLength());
			System.out.println("Recibido: "+linea);
			if(linea.equals("Adios")) break;
		}
		//Si recibe "adios" abandona el grupo
		socket.leaveGroup(grupo);


	}catch(SocketException e){
		System.out.println("Socket: " + e.getMessage());

	}catch(IOException e){
		System.out.println("IO: " + e.getMessage());
	}
	}
}