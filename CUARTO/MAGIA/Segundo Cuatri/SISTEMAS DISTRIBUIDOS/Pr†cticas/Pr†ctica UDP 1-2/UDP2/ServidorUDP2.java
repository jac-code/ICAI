import java.net.*;
import java.io.*;
import java.util.Calendar;
import java.util.Date;

public class ServidorUDP2 {

	public static void main (String args[]) {
		
		try{

			int puerto = Integer.parseInt(args[0]);
			DatagramSocket socketUDP = new DatagramSocket(puerto);
			byte[] bufer = new byte[1000];
	
			while(true)
			{
				Date fecha = new Date();
				byte[] fecha2 =new byte[1000];
				fecha2 = fecha.toString().getBytes();

				//Construimos el DatagramPacket para recibir peticiones
				DatagramPacket peticion = new DatagramPacket(bufer,bufer.length);

				//Leemos una peticion de datagramSocket
				socketUDP.receive(peticion);

				System.out.print("Datagrama recibido del host: " + peticion.getAddress());
				System.out.println("desde el puerto remoto: " + peticion.getPort());
	
				//Construimos el DatagramPacket para enviar la respuesta
				DatagramPacket respuesta = new DatagramPacket(fecha2,fecha2.length,peticion.getAddress(),peticion.getPort());
			
				
				//Sacamos por pantalla la respuesta
				System.out.println("Respuesta: " + new String(respuesta.getData()));

				//Enviamos la respuesta, que es un eco
				socketUDP.send(respuesta);
			
			}

			}catch(SocketException e) { System.out.println("Socket:"+e.getMessage());
			}catch(IOException e) { System.out.println("IO:"+e.getMessage());
}
		
}
}
