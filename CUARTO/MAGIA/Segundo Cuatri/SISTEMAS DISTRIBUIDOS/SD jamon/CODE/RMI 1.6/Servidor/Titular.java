import java.io.*;
public class Titular implements Serializable {
	//LA CLASE DE LA QUE HEREDARA EL TITULAR MENOR ES SERIALIZABLE
	//ATRIBUTOS PRIVADOS PRECISAN DE UN GETTER
	private String nombre;
	private String iD;

	Titular(String n, String i) {
		nombre = n;
		iD = i;
	}
	////////////////////GETTERS////////////////////
	////////////////////////////////////////
	public String obtenerNombre() {
		return nombre;
	}
	public String obtenerID() {
		return iD;
	}
	//SOBREESCRIBE EL toString INICIAL
	public String toString() {
		return nombre + " | " + iD;
	}
} 