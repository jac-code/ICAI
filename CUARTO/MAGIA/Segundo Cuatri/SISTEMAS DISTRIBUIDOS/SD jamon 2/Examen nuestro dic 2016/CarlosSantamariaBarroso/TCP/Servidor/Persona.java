import java.io.*;

//Como tiene que poder ser empaquetado, implementamos la caracteristica serializable
public class Persona implements Serializable
{
	String nombre;
	int edad;
	int envios;

	//Constructor

	public Persona (String _nombre, int _edad, int _envios)
	{

	 this.nombre=_nombre;
	 this.edad=_edad;
	 this.envios=_envios;

	}
	
	public String getNombre() 
	{
	 	return nombre;
	}

	public void setNombre(String _nombre) 
	{
	 	this.nombre=_nombre;
	}

	public int getEdad() 
	{
	 	return edad;
	}

	public void setEdad(int _edad) 
	{
	 	this.edad=_edad;
	}

	public int getEnvios() 
	{
	 	return envios;
	}

	public void setEnvios(int _envios) 
	{
	 	this.envios=_envios;
	}

	public String toString() 
	{
	 	return "\nNombre:" + nombre + "\nEdad: " + edad + "\nEnvios" + envios;
	}
}
