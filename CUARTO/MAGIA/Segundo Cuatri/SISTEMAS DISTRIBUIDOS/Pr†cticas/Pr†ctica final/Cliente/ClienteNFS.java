
import java.net.*;
import java.io.*;
import java.util.*;

public class ClienteNFS
{
	public static void main(String args[])
	{	
		
		String command ;
    	Process proc ;
    	String carpetaCompartida;
    	String carpetaEliminar;
    	String usuarioCompartir;
    	Scanner sc;
    	int opcion;

		try
		{
			//Pedimos al cliente su nombre. El programa funciona como un cliente único.
			//Si se quiere acceder con otro se debe desconectar y acceder de nuevo.

			System.out.println("\nIntroduce tu nombre: ");
			sc = new Scanner(System.in);
			String nombre = sc.nextLine();
			
			//Bienvenida al programa...
			System.out.println("\nBienvenido a DropboxICAI " + nombre);

			//Creamos las carpetas para compatir y la montamos

				command = "mkdir -p /mnt/nfs/compartido";
				proc = Runtime.getRuntime().exec(command);
				command = "chmod -R 777 /mnt/nfs";
				proc = Runtime.getRuntime().exec(command);	
				//La carpeta /compartido del servidor en 192.168.82.37 estará compartida con /mnt/nfs/compartido del cliente
				command = "mount 192.168.82.37:/compartido /mnt/nfs/compartido";
				proc = Runtime.getRuntime().exec(command);	

			do
			{
				//MENÚ....
				
				System.out.println("\n1)Crear y compartir carpeta");
				System.out.println("\n2)Eliminar perfil o carpeta");
				System.out.println("\n3)Obtener información sobre carpetas compartidas");
				System.out.println("\n4)Compartir carpeta con otros usuarios");
				System.out.println("\n5)Crear archivo");
				System.out.println("\n6)Eliminar archivo");
				System.out.println("\n0)Desconectar\n");

				System.out.println("\nIntroduce la opción deseada:");

				opcion = Integer.parseInt(sc.nextLine());

				switch(opcion)
				{
						case 1:	//CREAR Y COMPARTIR CARPETA
							
							System.out.println("\n\nIntroduce el nombre de la carpeta: ");
							sc = new Scanner(System.in);
							String carpetaNueva = sc.nextLine();
							command = "mkdir -p /mnt/nfs/compartido/"+nombre+"/"+carpetaNueva;
							proc = Runtime.getRuntime().exec(command);	
							System.out.println("\nCarpeta creada.");

												
							break;
						case 2: //ELIMINAR PERFIL COMPLETO O CARPETA

							do{

								System.out.println("\n1) Eliminar perfil:");
								System.out.println("\n2) Eliminar carpeta del perfil:");

								sc = new Scanner(System.in);
								opcion = Integer.parseInt(sc.nextLine());
								
								if(opcion==1) //Eliminar perfil...
								{
									command = "rm -r -f /mnt/nfs/compartido/"+nombre;
									proc = Runtime.getRuntime().exec(command);
									System.out.println("\nPerfil eliminado.");
								}
								else{
									if(opcion == 2) //Eliminar carpeta del perfil...
									{
										System.out.println("\n\nIntroduce el nombre de la carpeta a eliminar: ");
										sc = new Scanner(System.in);
										carpetaEliminar = sc.nextLine();
										File fRutaeliminar = new File("/mnt/nfs/compartido/"+nombre+"/"+carpetaEliminar);

									    if (fRutaeliminar.isDirectory()) //Comprobamos si la carpeta a eliminar realmente existe....
									    {
									    	command = "rm -r -f /mnt/nfs/compartido/"+nombre+"/"+carpetaEliminar;
											proc = Runtime.getRuntime().exec(command);
											System.out.println("\nCarpeta eliminada.");
									    }else{ //Si la carpeta a eliminar no existe...
									    	System.out.println("\n\nLa carpeta a eliminar no existe. ");
									    }
										
									}else{
										System.out.println("\nLo siento. Opción no válida");
									}
								}
							}while(opcion != 1 && opcion != 2);

							break;

						case 3: //Mostrar los archivos del perfil o de una carpeta...

							LeerArchivos leer = new LeerArchivos();//Clase para leer archivos...
							System.out.println("\n¿Quieres leer los archivos del raiz? \n1) Si \n2) No");
							sc = new Scanner(System.in);
							opcion = Integer.parseInt(sc.nextLine());
							if(opcion == 1)//Leemos los archivos de la carpeta raíz del cliente...
							{
								String resultado = leer.execute("ls /mnt/nfs/compartido/"+nombre);
								System.out.println(resultado);
							}else{//Leemos archivos de alguna carpeta dentro del raiz del cliente...

								System.out.println("\nIntroduce la carpeta que deseas ver");
								sc = new Scanner(System.in);
								String carpeta = sc.nextLine();
								File fRuta = new File("/mnt/nfs/compartido/"+nombre+"/"+carpeta);

							    if (fRuta.isDirectory()) //Vemos si existe dicha carpeta....
							    {
							    	String resultado = leer.execute("ls /mnt/nfs/compartido/"+nombre+"/"+carpeta);
									System.out.println(resultado);
							    }else{ //Si no...
							      System.out.println("La carpeta no existe.");
							    }
							}
							

							break;
						case 4: //Compartimos carpeta con otro usuario...

							System.out.println("\n\nIntroduce el nombre de la carpeta a compartir");
							sc = new Scanner(System.in);
							carpetaCompartida  = sc.nextLine();

							System.out.println("\n\nIntroduce el nombre del usuario con quien quieres compartir");
							sc = new Scanner(System.in);
							usuarioCompartir  = sc.nextLine();
							
							//La carpeta del usuario con el que queramos compartir debe estar creada...
							//Si no existe, no tiene sentido compartir con otro cliente
							command = "mkdir -p /mnt/nfs/compartido/"+nombre+"/Compartido con"+usuarioCompartir+"/";
							proc = Runtime.getRuntime().exec(command);

							//La IP del servidor la suponemos conocida...
							command = "sudo mount 192.168.82.37:/compartido/"+usuarioCompartir+" /mnt/nfs/compartido/"+"Compartido con"+usuarioCompartir+"/"+nombre;
							proc = Runtime.getRuntime().exec(command);
							
							
							break;
						case 5: //Crear archivo...

							System.out.println("\n\nIntroduce el nombre del archivo a crear: ");
							sc = new Scanner(System.in);
							String archivo  = sc.nextLine();

							System.out.println("\n\nIntroduce la carpeta donde deseas crear el archivo: ");
							sc = new Scanner(System.in);
							String carpeta  = sc.nextLine();
							
							File fRuta = new File("/mnt/nfs/compartido/"+nombre+"/"+carpeta);

						    if (fRuta.isDirectory())//Si la carpeta donde queremos crearlo existe, lo creamos...
						    {
						    	command = "touch /mnt/nfs/compartido/"+nombre+"/"+carpeta+"/"+archivo;
								proc = Runtime.getRuntime().exec(command);
						    
						    }else{ //Si no existe dicha carpeta...

						      System.out.println(" La carpeta no existe. ¿Deseas crearla?\n 1) Si \n 2) No");
						      sc = new Scanner(System.in);
							  opcion = Integer.parseInt(sc.nextLine());
							  
							  if(opcion == 1) //Decidimos crear dicha carpeta...
							  {
							  	command = "mkdir -p /mnt/nfs/compartido/"+nombre+"/"+carpeta;
								proc = Runtime.getRuntime().exec(command);
								System.out.println("\nCarpeta creada.");

								//intentamos crear ahora el archivo...
								System.out.println("¿Ahora deseas crear el archivo? \n 1) Si \n 2) No");
								sc = new Scanner(System.in);
							  	opcion = Integer.parseInt(sc.nextLine());
							  	if(opcion == 1) //Si se decide crearlo...
							  	{
							  		command = "touch /mnt/nfs/compartido/"+nombre+"/"+carpeta+"/"+archivo;
									proc = Runtime.getRuntime().exec(command);
									System.out.println("Archivo creado!");
							  	}else{ //Si no...
							  		System.out.println("Archivo no creado.");
							  	}
							  	
							  }else{ //No se crea...
							  	System.out.println("Archivo no creado. La carpeta no existe");
							  }
						    }

							break;	

						case 6:	//Eliminar archivo...
							System.out.println("\n\nIntroduce el nombre del archivo: ");
							sc = new Scanner(System.in);
							archivo = sc.nextLine();
							//Lo eliminamos...
							command = "rm -r -f /mnt/nfs/compartido/"+nombre+"/"+archivo;
							proc = Runtime.getRuntime().exec(command);			
							break;							
						case 0:
							break;
						default:
							System.out.println("Lo sentimos. La opcion marcada no está disponible");
							break;
				}

			}while(opcion != 0); ///Fin del do while...

		//Excepciones...
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
			System.out.println("AVISO: Error al lanzar el programa");
		}
	}
}