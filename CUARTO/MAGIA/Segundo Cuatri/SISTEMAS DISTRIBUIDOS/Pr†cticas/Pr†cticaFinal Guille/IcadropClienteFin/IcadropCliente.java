

import java.net.*;
import java.io.*;
import java.util.*;

public class IcadropCliente
{
	public static void main(String args[])
	{	
		
		String command ;
    	Process proc ;
    	String carpetaCompartida;
    	String carpetaCrear;
    	String carpetaEliminar;
    	String usuarioCompartir;

		try
		{
			/* Al lanzar el cliente le paso como primer argumento el servidor */
			InetAddress hostServidor = InetAddress.getByName("10.211.55.3");
			/* y como segundo el puerto */
			//int puertoServicio = Integer.parseInt(args[1]); 
			/* Creamos el socket */
			//Socket s = new Socket(hostServidor, puertoServicio);
			Socket s = new Socket(hostServidor, 5678);
			DataOutputStream salida;
			DataInputStream entrada;
			/* Usamos la clase Scanner para que el usuario introduzca el mensaje por teclado */
			String datos;
			Usuario usuario = null;
			ObjectInputStream oi = new ObjectInputStream(s.getInputStream());
			Scanner teclado = new Scanner(System.in);
			int opcion;

			//LOGIN

			do
			{	
				
				System.out.println("\nIntroduce tu user:\n");
				String user = teclado.nextLine();
				System.out.println("\nIntroduce tu password:\n");
				String password = teclado.nextLine();


				entrada = new DataInputStream(s.getInputStream()); // Lo que te llega del servidor
				salida = new DataOutputStream(s.getOutputStream()); // Lo que escribe el cliente
				
                

				
				/* Mandamos el mensaje introducido al servidor */
				salida.writeUTF(user+"-"+password);
				

				/* Leemos lo que nos llega de respuesta */
				datos = entrada.readUTF();
				System.out.println("\nAUNTENTICACIÓN : " + datos);

				if(datos.equals("Usuario correcto")){
					usuario =(Usuario) oi.readObject();
					//String infoUsuario = usuario.toString();
					//System.out.println(infoUsuario);
				}
				
			}while(!datos.equals("Usuario correcto"));

			

			//MONTAMOS LAS CARPETAS DEL CLIENTE
			Collection <String> carpetasMontar = usuario.getCarpetas();
 
			for(String i: carpetasMontar){
				command = "sudo mkdir -p /icadrop/"+i;

				proc = Runtime.getRuntime().exec(command);

				command = "sudo chmod -R 777 /icadrop";

				proc = Runtime.getRuntime().exec(command);

				command = "sudo mount 10.211.55.3:/icadrop/"+i+" /icadrop/"+i;

				proc = Runtime.getRuntime().exec(command);


				//command = "touch /icadrop/"+i+"/ej1";

				//proc = Runtime.getRuntime().exec(command);
			}
			
			System.out.println("\n\n----------------MONTANDO CARPETAS----------------\n\n");
			Thread.sleep(3000);

			//MENU
			System.out.println("\n\n----------------Bienvenido a ICADROP "+usuario.getNombre()+"----------------");

			do{

			System.out.println("\n\nIntroduce la opción deseada:");
			System.out.println("\n1)Añadir carpeta");
			System.out.println("\n2)Eliminar carpeta");
			System.out.println("\n3)Obtener información sobre carpetas compartidas");
			System.out.println("\n4)Compartir carpeta");
			System.out.println("\n5)Crear archivo");
			System.out.println("\n0)Desconectar\n");

			opcion = Integer.parseInt(teclado.nextLine());

			switch(opcion){
					case 1:	

						System.out.println("\n\nIntroduce el nombre de la carpeta a crear:");
						carpetaCrear = teclado.nextLine();
						command = "sudo mkdir -p /icadrop/"+carpetaCrear;
						proc = Runtime.getRuntime().exec(command);
						//Añadirla al usuario en el servidor
						salida = new DataOutputStream(s.getOutputStream());
						salida.writeUTF("1-"+carpetaCrear);
											
						break;
					case 2:

						System.out.println("\n\nIntroduce el nombre de la carpeta a eliminar:");
						carpetaEliminar = teclado.nextLine();
						command = "sudo rm -r -f /icadrop/"+carpetaEliminar;
						proc = Runtime.getRuntime().exec(command);
						
						//Borrarla del usuario en el servidor
						salida = new DataOutputStream(s.getOutputStream());
						salida.writeUTF("2-"+carpetaEliminar);
						
						break;
					case 3:
						System.out.println("\nActualmente tienes las siguientes carpetas compartidas en ICADROP\n(si has hecho algun cambio en esta sesión no saldrá reflejado en esta lista):");
						int l = 0;
						for(String i: carpetasMontar){
							l++;
							System.out.println("\n"+l+")-"+i);
						}

						break;
					case 4:

						System.out.println("\n\nIntroduce el nombre de la carpeta a compartir");
						carpetaCompartida  = teclado.nextLine();
						System.out.println("\nIntroduce el usuario con quien la quieres compartir");
						usuarioCompartir = teclado.nextLine();
						//Añadir carpeta a lista de carpetas de ese usuario en el servidor
						salida = new DataOutputStream(s.getOutputStream());
						salida.writeUTF("4-"+carpetaCompartida+"-"+usuarioCompartir);
						
						break;
					case 5:

						System.out.println("\n\nIntroduce el nombre del archivo a crear (poner path dentro de /icadrop/ ):");
						command = "touch /icadrop/"+ teclado.nextLine();
						proc = Runtime.getRuntime().exec(command);

						break;					
					case 0:
						salida = new DataOutputStream(s.getOutputStream());
						salida.writeUTF("0");
						System.out.println("\nSALIENDO DEL PROGRAMA");
						break;
					default:
						System.out.println("OPCION NO DISPONIBLE");
						break;

					}
			}while(opcion!=0);

		//cerramos el socket
		s.close();

			
		}
		catch(UnknownHostException e)
		{
			System.out.println("Socket: " + e.getMessage());
		}
		catch (EOFException o)
		{
			System.out.println("EOF: " + o.getMessage());
		}
		catch (IOException e)
		{
			System.out.println("IO: " + e.getMessage());
		}
		catch (Exception e)
		{
			/* Lanzamos una excepción genérica en caso de error de ejecución */
			System.out.println("AVISO: No lo has lanzado de manera correcta");
		}
	}
}