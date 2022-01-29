import java.net.*;
import java.io.*;

class Conexion extends Thread
{
	DataInputStream entrada;
	DataOutputStream salida;
	Socket socketCliente;
	public Conexion (Socket unSocketCliente)
	{
		try{
			socketCliente = unSocketCliente;
			entrada = new DataInputStream(socketCliente.getInputStream());
			salida = new DataOutputStream(socketCliente.getOutputStream());
			this.start();
			}catch (IOException e) {System.out.println("Conexion: " + e.getMessage());}
	}
	
	public void run()
	{
		try{
			String datos = entrada.readUTF();
			System.out.println(datos);

			this.sleep(4000); //Esperamos 4 segundos antes de mandarlo (Al ponerlo aqui,
				// hacemos que solo afecte al hilo y no a todo el servidor)
			salida.writeUTF(datos);
			socketCliente.close();
			}
			catch (EOFException e) 
			{
				System.out.println("EOF: " + e.getMessage());
			}
			catch (IOException e)
			 {
				System.out.println("IO: " + e.getMessage());
			}
			catch(InterruptedException e)
			{
				System.out.println("Excepcion de interupccion ");
			}
	}
	
}