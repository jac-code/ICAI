import java.io.*;

class Titular implements Serializable { //ES IMPRESCINDIBLE QUE SEA UN OBJETO SERIALIZABLE

	//SON ATRIBUTOS PRIVADOS (PRIVATE) POR LO QUE REQUIEREN DE GETTERS PARA OBTENERLOS
	////////////////////////////////////////////////////////////////////////////////

	private String nombre;
	private String iD;


	//////////////////////CONSTRUCTOR DEL OBJETO////////////////////
	////////////////////////////////////////////////////////////
	Titular(String n, String i) {
		
		nombre = n;
		iD = i;
	}
		//GETTERS//
	////////////////////
	public String obtenerNombre() { //DEVUELVE EL NOMBRE
		return nombre;
	}
	public String obtenerID() { //DEVUELVE EL ID
		return iD;
	}
	//SE SOBREESCRIBE EL toString() ORIGINAL PARA CAMBIAR EL FORMATO
	public String toString() {
		return nombre + " | " + iD;
	}
} 