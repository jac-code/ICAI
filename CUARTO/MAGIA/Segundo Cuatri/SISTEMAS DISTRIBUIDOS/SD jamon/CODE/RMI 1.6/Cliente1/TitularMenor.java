import java.io.*;
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////DEFINIMOS LA CLASE TITULAR MENOR (DE DESCARGA DINÁMICA)////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
class TitularMenor extends Titular {
	private String nombreTutor; //ATRIBUTOS PRIVADOS NECESITARÁN DE UN GETTER
	TitularMenor(String n, String i, String t) {
		/////CONTRUCTOR//
		super(n, i); //CONSTRUCTOR RELACIONADO CON SU PADRE "TITULAR" POR HERENCIA
		nombreTutor = t; //AÑADE EL NOMBRE DEL TUTOR AL FINAL

	}
	////////////////////
	/////// GETERS //////
	////////////////////
	public String obtenerTutor() { //GET NOMBRETUTOR
	return nombreTutor;
	}
	//REEMPLAZA EL toString ORIGINAL 
	////////////////////////////////////////
	public String toString() {
		return super.toString() + " | " + nombreTutor;
	}
} 