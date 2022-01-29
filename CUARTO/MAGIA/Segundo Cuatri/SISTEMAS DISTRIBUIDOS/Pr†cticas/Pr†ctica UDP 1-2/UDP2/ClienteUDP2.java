import java.net.*;
import java.io.*;
import java.util.Calendar;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class ClienteUDP2
{
	//Los argumentos proporcionan el mensaje y el nombre del servidor
	public static void main(String args[])
	{
		if(args.length==3)
		{
			
			
			try{
				DatagramSocket socketUDP = new DatagramSocket();
				byte[] mensaje = args[0].getBytes();
				InetAddress hostServidor = InetAddress.getByName(args [1]);
				int puertoServidor = Integer.parseInt(args[2]);

				//Construimos un datagrama para enviar el mensaje al servidor
				DatagramPacket peticion = new DatagramPacket(mensaje,args[0].length(),hostServidor,puertoServidor);

				//Enviamos el datagrama
				socketUDP.setSoTimeout(5000);   // Establecemos el timeout en milisegundos.
				socketUDP.send(peticion);
				

				//Construimos el datagramPacket que contendrá la respuesta
				byte[] bufer = new byte[1000];
				DatagramPacket respuesta = new DatagramPacket(bufer,bufer.length);
				socketUDP.receive(respuesta);

				//Enviamos la respuesta del servidor a la salida estandar
				System.out.println("Respuesta: " + new String(respuesta.getData()));
				
				try{
					DateFormat dateformat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					String fecharemota = new String(respuesta.getData());
					Date dateServidor = dateformat.parse(fecharemota);
					Date date = new Date();
					long dif = date.getTime()-dateServidor.getTime();
					System.out.println("Respuesta:" + dif+"ms");
					
						
					//Cerramos el socket
					socketUDP.close();
				}catch(ParseException e){System.out.println("No es posible parsear la fecha");}
				
			}catch(SocketException e) {System.out.println("Socket: " + e.getMessage());
			}catch(IOException e) {System.out.println("IO: " + e.getMessage());
			}	 
		}else{	

			System.out.println("Debe introducir como argumentos el mensaje la direccion y el puerto ");
		
		}
	}
}
