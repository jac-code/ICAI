import java.net.*;
import java.io.*;
 
class Servidor2
{
    public static void main (String[] args)
	{
        
        BufferedInputStream bis;
        BufferedOutputStream bos;
        byte[] byteArray;
        int in;
        ServerSocket server;
        Socket connection;
        
        
        try
		{
            server = new ServerSocket( 1234 );
            while ( true ) 
			{
                connection = server.accept();
                DataInputStream entrada = new DataInputStream(connection.getInputStream());
                String archivo= entrada.readUTF();
                System.out.println(archivo);
                
                final String filename = "/home/labcom/" + archivo;

                final File localFile = new File( archivo);
                bis = new BufferedInputStream(new FileInputStream(localFile));
                bos = new BufferedOutputStream(connection.getOutputStream());
     
                //enviamos el nombre del archivo            
                DataOutputStream dos=new DataOutputStream(connection.getOutputStream());
                dos.writeUTF(localFile.getName());
     
                byteArray = new byte[8192];
                while ((in = bis.read(byteArray)) != -1)
                {
                    bos.write(byteArray,0,in);
                }
                
                bis.close();
                bos.close();      
            }
        }
		catch (Exception e ) 
		{
            System.err.println(e);
        }
    }
}