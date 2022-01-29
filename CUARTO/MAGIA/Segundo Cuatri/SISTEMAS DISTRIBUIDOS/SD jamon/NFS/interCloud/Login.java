import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.lang.Integer;
//import SistemaDistribuido.java;

public class Login 
{
    public static void main(String args[]) {
    Process p;
    //String ipServer = args[0];
    String serverIP ="192.168.1.7";
	InputStreamReader isr = new InputStreamReader(System.in);
	BufferedReader br = new BufferedReader (isr);	
	InetAddress addr = null;
	CheckIP chckIp = new CheckIP();
	String departamento = chckIp.getDepartamento();

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
			SistemaDistribuido sd = new SistemaDistribuido();
		
	
    }
}

