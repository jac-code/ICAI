import java.net.*;
import java.io.*;
import java.util.Scanner;

//TIENE QUE SER COMO LA CLASE CONEXION
//HAY QUE ESTAR CONTINUAMENTE ESCUCHANDO.

class Escucha extends Thread 
{
	InetAddress grupo;
 	DatagramPacket mensajeEntrada;
 	byte[] bufer = new byte[1000];
 	MulticastSocket socket;
 	String cadena;
 	String nombre;

 		
 	public Escucha(MulticastSocket unSocket)
 	{
 		try{
 			socket = unSocket;
 			
			this.start();

 		}catch (Exception e) {System.out.println("Excepcion: " + e.getMessage());}
 	}
		
 	
	
 	public void run()
 	{
 		try{
 			while(true)
 			{
 				mensajeEntrada = new DatagramPacket(bufer,bufer.length);
 				socket.receive(mensajeEntrada);
				String linea = new String(mensajeEntrada.getData(),0,mensajeEntrada.getLength());
				System.out.println("Recibido: "+linea);
			}
			
 			}catch(SocketException e){
				System.out.println("Socket: " + e.getMessage());

			}catch(IOException e){
				System.out.println("IO: " + e.getMessage());
			}

 	}
 }
