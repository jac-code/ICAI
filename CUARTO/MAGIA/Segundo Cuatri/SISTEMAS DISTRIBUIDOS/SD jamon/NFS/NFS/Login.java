import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.lang.Integer;
//import SistemaDistribuido.java;

public class Login 
{
    public static void main(String args[]) {
    String fichero;
 	String departamento;
    Process p;
    //String ipServer = args[0];
    String serverIP ="192.168.1.7";
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
			System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Comercial de la empresa!");
			departamento = "Departamento_Comercial";
		break;

		case 2:
			System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Tecnologico!");
			departamento = "Departamento_Comercial";

		break;

		case 3:
			System.out.println("\nBienvenido,tu IP "+ip+" pertenece al Departamento Desarrollo!");
			departamento = "Departamento_Comercial";
		break;

		default:
			System.out.println("\nBuenos días Usuario, tu IP "+ip+" no se encuentra asociada a ningun departamento!");
			departamento = "Generic";

		break;
		}
			try
			{
				System.out.println("\nComprobando carpeta de departmento..");
				p = Runtime.getRuntime().exec("sudo mkdir -p /mnt/nfs/"+departamento);
				p.waitFor();
				p.destroy();
				System.out.println("\n Asignando permisos..");
				p = Runtime.getRuntime().exec("sudo chmod -R 777 /mnt/nfs/"+departamento);
				p.waitFor();
				System.out.println("Montando el Sistema Distribuido..");
				p.destroy();
				p = Runtime.getRuntime().exec("sudo mount "+serverIP+":/"+departamento+" /mnt/nfs/"+departamento);
				p.waitFor();
				p.destroy();


			}

			catch(Exception e)
			{
				e.printStackTrace();
			}
			System.out.println("departamento del creador: "+departamento);
			SistemaDistribuido sd = new SistemaDistribuido(departamento);
		
	

		/*
		   System.out.println("\nCrear Archivo Remoto")
		   fichero = br.readLine();
		   p = Runtime.getRuntime().exec("touch /mnt/nfs/Generic/"+fichero);
		   p.waitFor();
		   p.destroy();
		*/
    }
}

