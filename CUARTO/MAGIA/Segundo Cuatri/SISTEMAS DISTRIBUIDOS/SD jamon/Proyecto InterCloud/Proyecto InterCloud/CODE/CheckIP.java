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
	       addr = InetAddress.getLocalHost(); //SE OBTIENE LA DIRECCION DEL HOST
		   String ip = addr.getHostAddress(); //SE OBTIENE LA IP 
		   int depID = Integer.parseInt(ip.substring(6,7)); //SE OBTIENE EL DIGITO 7 PARA DIFERENCIAR LA RED APLICANDO LA MASCARA
		  
		   /*
			   ESTO ES , SI ES UN 192.168.1.1 LA RED SERA EL PRIMER UNO Y EL NUMERO DE HOST EL SEGUNDO
			   CADA RED ESTARA ASOCIADA A UN DEPARTAMENTO, ESTANDO EL X.X.1.X ASOCIADA AL COMERCIAL, X.X.2.X AL TECNOLOGICO Y X.X.3.X AL DE DESARROLLO
			   CUALQUIER OTRO PERTENECERA AL GENERIC
		   */
		 
		   switch (depID) //SEGUN EL TIPO D RED SE ACSOCIA A UN DEPARTAMENTO U A OTRO
		   {
			case 1:
				System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Comercial de la empresa!");
				this.departamento = "Departamento_Comercial";
			break;

			case 2:
				System.out.println("\nBienvenido, tu IP "+ip+" pertenece al Departamento Tecnologico!");
				this.departamento = "Departamento_Tecnologico";

			break;

			case 3:
				System.out.println("\nBienvenido,tu IP "+ip+" pertenece al Departamento Desarrollo!");
				this.departamento = "Departamento_Desarrollo";
			break;

			default:
				System.out.println("\nBuenos días Usuario, tu IP "+ip+" no se encuentra asociada a ningun departamento!");
				this.departamento = "Generic";

			break;
			}
		}
		catch(Exception e)
		{
			System.out.println("\n ERROR! Tiene que permitir al programa ver su dirección IP!");
		}


		}
		public String getDepartamento()
		{
			return this.departamento;
		}
}