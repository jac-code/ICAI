import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.lang.Integer;

public class CrearArchivoRemoto(String departamento) 
{

        String fichero;
 	String Departamento;
        Process p;
	InputStreamReader isr = new InputStreamReader(System.in);
	BufferedReader br = new BufferedReader (isr);	
	InetAddress addr = null;

        try
	{
        	addr = InetAddress.getLocalHost();

	}
	catch(Exception e)
	{
		System.out.println("\n ERROR! Tiene que permitir al programa ver su dirección IP!");
	}
	

	   String ip = addr.getHostAddress();
	   int depID= Integer.parseInt(ip.substring(6,7));
	 

	   switch (depID) 
	   {
		case 1:
			System.out.println("Bienvenido, Departamento Comercial");
			Departamento = "Departamento_Comercial";
			try
			{
				p = Runtime.getRuntime().exec("sudo mkdir -p /mnt/nfs/Departamento_Comercial");
				p.waitFor();
				p.destroy();

			}
			catch(Exception e)
			{
				e.printStackTrace();
			}


	
		break;

		case 2:
			System.out.println("Bienvenido, Departamento Tecnologico");
			Departamento = "Departamento_Comercial";
			try
			{
				p = Runtime.getRuntime().exec("sudo mkdir -p /mnt/nfs/Departamento_Tecnologico");
				p.waitFor();
				p.destroy();

			}
			catch(Exception e)
			{
				e.printStackTrace();
			}


		break;

		case 3:
			System.out.println("Bienvenido, Departamento Desarrollo");
			Departamento = "Departamento_Comercial";
			try
			{
				p = Runtime.getRuntime().exec("sudo mkdir -p /mnt/nfs/Departamento_Desarrollo");
				p.waitFor();
				p.destroy();

			}
			catch(Exception e)
			{
				e.printStackTrace();
			}

		break;

		default:
			System.out.println("Buenos días Usuario!");
			Departamento = "Generic";
			try
			{
				p = Runtime.getRuntime().exec("sudo mkdir -p /mnt/nfs/Generic");
				p.waitFor();
				p.destroy();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}

		break;
		}
		
		try
		{
			p = Runtime.getRuntime().exec("sudo chmod -R 777 /mnt/nfs");
			p.waitFor();
			p.destroy();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}

	


		/*
		   System.out.println("\nCrear Archivo Remoto")
		   fichero = br.readLine();
		   p = Runtime.getRuntime().exec("touch /mnt/nfs/Generic/"+fichero);
		   p.waitFor();
		   p.destroy();
		*/
    
}

