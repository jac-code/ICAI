import java.net.*;
import java.io.*;
 
class Cliente2
{
	 public static void main (String[] args)
	 {

	 	String file;
	 	byte[] receivedData;
	 	ServerSocket server;
		BufferedInputStream bis;
		BufferedOutputStream bos;
		int in;
		byte[] byteArray;
	
		//final String filename = "fichero1.txt";
		try{
				Socket serv = new Socket("localhost", 1234);
	 			DataOutputStream salida= new DataOutputStream(serv.getOutputStream());

	 			System.out.println("Escribe la instrucción:  ");
				InputStreamReader isr = new InputStreamReader(System.in);
				BufferedReader br = new BufferedReader (isr);
				String mensaje = br.readLine();
				if (mensaje.startsWith("get"))
				{


				mensaje =mensaje.substring(4);
				salida.writeUTF(mensaje); //UTF es una codificacion de Strings

                receivedData = new byte[1024];
                bis = new BufferedInputStream(serv.getInputStream());
                DataInputStream dis=new DataInputStream(serv.getInputStream());
            
                //recibimos el nombre del fichero
                file = dis.readUTF();
                System.out.println(file);
                System.out.println("Nombre fichero recibido: "+ file);
 
                //escribimos el fichero en el directorio del servidor
				bos = new BufferedOutputStream(new FileOutputStream("/home/labcom/cliente/"+file));
                while ((in = bis.read(receivedData)) != -1)
				{
                    bos.write(receivedData,0,in);
                }
                
                bos.close();
                dis.close();   
            }
            else
            {
	 			serv.close();
	 		}
			} 
			catch ( Exception e ) {
				System.err.println(e);
			}	
	}
}