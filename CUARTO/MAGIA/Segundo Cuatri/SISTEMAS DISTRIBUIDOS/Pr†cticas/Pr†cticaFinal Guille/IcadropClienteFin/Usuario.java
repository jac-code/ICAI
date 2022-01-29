

import java.io.*;
import java.util.*;

public class Usuario implements Serializable
{
	

	public String nombre;
	public String password;
	public Collection carpetas = new ArrayList();

	
	public Usuario(String nombre, String password,String carpeta)
	{

		this.nombre=nombre;
		this.password=password;
		carpetas.add(carpeta);

	}

	public void setNombre(String nombre)
	{
		this.nombre=nombre;
	}

	public void setPassword(String password)
	{
		this.password=password;
	}

	public void addCarpeta(String carpeta)
	{
		carpetas.add(carpeta);
	}

	public void removeCarpeta(String carpeta)
	{
		carpetas.remove(carpeta);
	}

	public String getNombre()
	{
		return nombre;
	}

	public String getPassword()
	{
		return password;
	}

	public Collection getCarpetas()
	{
		return carpetas;
	}

	


	public String toString()
	{
		StringBuilder sb = new StringBuilder();

		sb.append("\n");
		sb.append("User:"+nombre);
		sb.append("\t");
		sb.append("Contraseña:"+password);
		sb.append("\t");
		sb.append("Carpetas compartidas:"+carpetas);
		sb.append("\n");

		return sb.toString();

	}

	public int hashCode()
	{
		return this.nombre.charAt(0);
	}

	public boolean equals(Object o)
	{
		if(o instanceof Usuario)
		{
			Usuario p = (Usuario) o;
			if(nombre.equals(p.getNombre()))
				return true;	
			else
				return false;
		}
		else
			return false;
	
	}


}