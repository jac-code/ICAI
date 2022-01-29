public class Login 
{
    public static void main(String args[]) 
    {
    	//INICIALIZO LAS VARIABLES QUE EMPLEARE//
	    Process p;
	    String serverIP;
		CheckIP chckIp = new CheckIP();

	    //COMPRUEBO LA ENTRADA DEL TERMINAL SI SE HA ESPECIFICADO LA IP DEL SERVIDOR

	    if (args.length!=0)
	    {
	    	serverIP = args[0];
	    }
	    else
	    {
	    	serverIP ="192.168.1.7";
	    }

		//obtengo localizacion del host//
		String departamento = chckIp.getDepartamento();

		//CREO LOS PUNTOS DE MONTAJE Y ASIGO LOS PERMISOS //
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
				//GESTIONO TRAZA DE EXCEPCIÓN EN CASO DE ERROR //

				catch(Exception e)
				{
					e.printStackTrace();
				}
				
				//INICIALIZO EL INTERFAZ //
				Interfaz software = new Interfaz();
		
	
    }
}

