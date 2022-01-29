//CLIENTE//

public class ClienteTCP
{
	public static void main(String args[])
	{
		try
		{
			inicializo canal (ip, puerto)
			entrada = Socket.getInputStream()
			salida = Socket.getOutputStream()

			salida.writeUTF(MENSAJE)==> Envia mensaje
			entrada.readUTF() ==> Obtiene mensaje
		}
	}


public class ServidorTCP{

	public static void main(String args[]){
	
	try
	{
		inicializo canal de escucha(puerto)

		while (true)
		{
			Socket canalCliente = canalDeEscucha.accept();
			Conexion c = new Conexion(canalCliente);
		}
	}

	catch (IOException e)
	{
		System.out.println("Escuchando: " + e.getMessage());
	}
	
	}

}

