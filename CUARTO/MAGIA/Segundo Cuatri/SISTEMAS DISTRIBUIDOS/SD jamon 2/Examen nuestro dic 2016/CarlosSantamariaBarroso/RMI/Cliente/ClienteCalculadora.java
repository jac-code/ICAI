//CLIENTE
// java -Djava.security.policy=cliente.permisos ClienteEco 130.206.69.202 1234 hola que tal
import java.rmi.*;
import java.rmi.server.*;
import java.util.*;


class ClienteCalculadora {
    static public void main (String args[]) {
        if (args.length<2) {
            System.err.println("Uso: ClienteCalculadora hostregistro numPuertoRegistro");
            return;
        }

       if (System.getSecurityManager() == null)
           System.setSecurityManager(new RMISecurityManager());
			

        try {
			ServicioCalculadora srv = (ServicioCalculadora) Naming.lookup("//" + args[0] + ":" + args[1] + "/calculadora");
            
            System.out.println("1 - suma\n");
            System.out.println("2 - resta\n");
            System.out.println("3 - multiplicar\n");
            System.out.println("4 - dividir\n");

            System.out.println("Introduce la opcion que desees");
            
            Scanner sc = new Scanner(System.in);
            int opcion = sc.nextInt();

            System.out.println("Introduce el primer numero");
            
            Scanner sc1 = new Scanner(System.in);
            int num1 = sc1.nextInt();

            System.out.println("Introduce el segundo numero");
            
            Scanner sc2 = new Scanner(System.in);
            int num2 = sc2.nextInt();

            if(opcion == 1){
                System.out.println("\nEl resultado de la suma es" + srv.sumar(num1,num2));
            }
            
            if(opcion == 2){
                System.out.println("\nEl resultado de la resta es" + srv.restar(num1,num2));
            }

            if(opcion == 3){
                System.out.println("\nEl resultado de la multiplicacion es" + srv.multiplicar(num1,num2));
            }

            if(opcion == 4){
                System.out.println("\nEl resultado de la division es" + srv.dividir(num1,num2));
            }
            //for (int i=2; i<args.length; i++)
            //    System.out.println(srv.eco(args[i]));
        }
        catch (RemoteException e) {
            System.err.println("Error de comunicacion: " + e.toString());
        }
        catch (Exception e) {
            System.err.println("Excepcion en ClienteCalculadora:");
            e.printStackTrace();
        }
    }
}