import java.net.InetAddress;

public class CheckIP 
{
    Process p;	
	InetAddress addr = null;
	String departamento;
	public CheckIP()
	{
	    try
		{
	        addr = InetAddress.getLocalHost();

		}
		catch(Exception e)
		{
			System.out.println("\n ERROR! Tiene que permitir al programa ver su dirección IP!");
		}

		   String ip = addr.getHostAddress();
		   int depID = Integer.parseInt(ip.substring(6,7));

		 
		   switch (depID) 
		   {
			case 1:
				System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Comercial de la empresa!");
				this.departamento = "Departamento_Comercial";
			break;

			case 2:
				System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Tecnologico!");
				this.departamento = "Departamento_Comercial";

			break;

			case 3:
				System.out.println("\nBienvenido,tu IP "+ip+" pertenece al Departamento Desarrollo!");
				this.departamento = "Departamento_Comercial";
			break;

			default:
				System.out.println("\nBuenos días Usuario, tu IP "+ip+" no se encuentra asociada a ningun departamento!");
				this.departamento = "Generic";

			break;
			}


		}
		public String getDepartamento()
		{
			return this.departamento;
		}
}