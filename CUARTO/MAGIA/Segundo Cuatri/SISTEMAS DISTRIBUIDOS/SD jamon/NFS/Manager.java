/*import PracticaFinal.dominio.Sala;
import PracticaFinal.logica.Gestor;
import PracticaFinal.io.Ficheros;*/
/////////////////////////////
///////////IMPORTS///////////
/////////////////////////////
import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ImageIcon;
import java.awt.Container;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Color;
import java.awt.Font;

import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.KeyAdapter;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;

import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Collection;
import java.util.Collections;
import java.io.IOException;

///////////////////////////////////////////////////////////
public class Manager extends JFrame
{
	//VARIABLES QUE SE VAN A USAR//
	JLabel lblPelicula;
	JComboBox cbPeliculas;
	JButton btnEnter;
	JLabel lblPeli[];
	JLabel lblInfoVentana[];
	JLabel lblduracion;
	JLabel lblNombre;
	Container c;
	ImageIcon imgPelicula;
	JLabel lblDefault;
	ArrayList lista;
	Manager jwInfo;

	////////////FUENTES QUE SE VAN A USAR///////////////
	Font fntDuracion = new Font("Arial", Font.BOLD, 25);
	Font fntTexto = new Font("Arial", Font.BOLD, 20);
	Font fntTitle = new Font("Arial", Font.BOLD, 30);

				        ////MAIN////
	public static void main(String args[])
	{
		Manager w = new Manager();//VENTANA PRINCIPAL DEL PROGAMA
	}
	
	public Manager(ArrayList infoAvanzadaPelicula)
	{
	
		int tam = infoAvanzadaPelicula.size();//NUMERO DE SALAS DISPONIBLES

		///DECLARACION DEL ONTAINER DEFINICION LAYOUT//
		Container cont = this.getContentPane();
		cont.setLayout(new BorderLayout());

		////////////////////////CREACION DE JPANELS//////////////////
		JPanel pnlNorteAvanzado = new JPanel(new GridLayout(2,1));
		JPanel pnlCentroAvanzado = new JPanel(new GridLayout(tam,2));

		///////////////////////////ATRIBUTOS A DEFINIR PARA CREAR LOS COMPONENTES////////////////////////////////

		////////////////////////////////////////////////////////////////////////////////////////////////////////
		//	AQUI SE AJUSTA EL MENSAJE PARA QUE LA VENTANA DIGA CORRECTAMENTE LA DURACION DE LA PELICULA 	  //


	////////////////////////////////////////////////////////////////////////////////////////////////////////


		///////////SE CREAN LOS COMPONENTES NO DINAMICOS/////////////
		JLabel lblNombrePelicula = new JLabel("salaCom.getPelicula()");
		JLabel lblDuracion = new JLabel("Duracion: ");

		//////////DEFINICION DE FUENTES///////////
		lblNombrePelicula.setFont(fntTitle);
		lblDuracion.setFont(fntDuracion);

		////////AGREGACION DE COMPONENTES NO DINAMICOS//////////
		pnlNorteAvanzado.add(lblNombrePelicula);
		pnlNorteAvanzado.add(lblDuracion);

		////////CREACION Y AGREGACION AL PANEL DE LOS COMPONENTES DINAMICOS//////////

		/*lblInfoVentana= new JLabel[tam];
		for(int i=0; i<tam;i++)
		{
			Object o =infoAvanzadaPelicula.get(i);
			Sala s = (Sala) o;
			int numSala = s.getNumeroSala();
			lblInfoVentana[i] = new JLabel("Hora: "+(int) s.getHora()+":"+(int)(60*(s.getHora() - (int)(s.getHora())))+" Sala "+numSala); //SE HA PASADO LA HORA EN FORMATO DOUBLE A SISTEMA SEXAGESIMAL DE LA MISMA FORMA QUE CON LA DURACION
			lblInfoVentana[i].setFont(fntTexto);
			pnlCentroAvanzado.add(lblInfoVentana[i]);
		}*/

		////SE AGREGAN AL CONTAINER LOS PANELES YA CREADOS////
		cont.add(pnlNorteAvanzado, BorderLayout.NORTH);
		cont.add(pnlCentroAvanzado, BorderLayout.CENTER);

		////DEFINICIÓN DEL COMPORTAMIENTO DEL Manager AL CERRARSE////
		this.addWindowListener(new WindowAdapter()
		{
		    public void windowClosing(WindowEvent e) 
		    {
		    	Manager.this.dispose();
		    }			
		});

		////CARACTERISTICAS DE LA Manager////
		if(tam<3)
		{
			this.setSize(400,200*tam);
		}
		else	
		{
			this.setSize(400,100*tam);
		}
		
		this.setLocationRelativeTo(null);
		this.setTitle("INFO DE PELICULA");
		this.setVisible(true);
		this.setResizable(false);
		this.setIconoDeVentana("info");
	}

	public Manager()
	{
		
		
		cbPeliculas = new JComboBox(); //LISTA DESPLEGABLE DE PELICULAS
		lblPeli = new JLabel[cartelera.size()];//COLECCION DE JLABELS CON LAS PELICULAS


		//CREACION DE JPANELS PARA LA MAQUETACION DE LA VENTANA//
		JPanel pnlSouth = new JPanel(new FlowLayout());
		JPanel pnlNorth = new JPanel(new FlowLayout());
		JPanel pnlCenter = new JPanel(new FlowLayout());

		//DEFINICION DEL CONTAINER Y LAYOUT PRINCIPAL//
		c = this.getContentPane();
		c.setLayout(new BorderLayout());
		pnlCenter.setBackground(Color.BLACK);
		pnlSouth.setBackground(Color.BLACK);
		pnlNorth.setBackground(Color.BLACK);

		//BUCLE PARA RELLENAR COLECCIONES JLABEL Y COMBOBOX//
		for(int i = 0; i<cartelera.size();i++)
		{
			String p = (String) cartelera.get(i);
			cbPeliculas.addItem(p);	
			imgPelicula = new ImageIcon("PracticaFinal/images/"+(String) cartelera.get(i)+".jpg");
			lblPeli[i]= new JLabel("",imgPelicula,JLabel.CENTER);
			pnlCenter.add(lblPeli[i], BorderLayout.CENTER);
			lblPeli[i].setVisible(false);
		}
		
		//////////////////////////CREACION DE COMPONENTES////////////////////////
		lblDefault = new JLabel("", new ImageIcon("PracticaFinal/images/JCinema.jpg"), JLabel.CENTER);
		lblPelicula  = new JLabel("Seleccione Pelicula Que Desea Ver: ");
		btnEnter = new JButton(new ImageIcon("PracticaFinal/images/imgEnter.jpg"));

		//AGREGACION DE COMPONENTES A LOS PANELES//////
		pnlCenter.add(lblDefault, BorderLayout.CENTER);
		pnlNorth.add(lblPelicula);
		pnlNorth.add(cbPeliculas);	
		pnlSouth.add(new JLabel(""));
		pnlSouth.add(btnEnter);
		pnlSouth.add(new JLabel(""));

		//////AGREGACION DE PANELES AL CONTAINER///////
		c.add(pnlSouth, BorderLayout.SOUTH);
		c.add(pnlCenter, BorderLayout.CENTER);
		c.add(pnlNorth, BorderLayout.NORTH);

		this.events();//GESTION DE LOS EVENTOS


		///////AJUSTE DE FUENTES//////
		btnEnter.setVisible(false);
		lblPelicula.setFont(fntTexto);
		cbPeliculas.setFont(fntTexto);
		lblPelicula.setForeground(Color.WHITE);
		btnEnter.setBackground(Color.BLACK);


		///////CARACTERISTICAS DE LA Manager////////
		this.setVisible(true);
		this.setTitle("JMOVIE MANAGER");
		this.pack();
		this.setSize(1000,1000);
		this.setBackground(Color.BLACK);
		this.setLocationRelativeTo(null);
		this.setExtendedState(this.MAXIMIZED_BOTH); 
		this.setResizable(false);
		this.setIconoDeVentana("user");
	}

	//////////////////////////////////////////////////////////
    //////////////METODOS EMPLEADOS EN LA Manager/////////////
    //////////////////////////////////////////////////////////
/*
	private void infoAvanzadaPelicula(String pelicula)
	{
		
		ArrayList infoAvanzadaPelicula = new ArrayList();
		Iterator it = lista.iterator();
		while(it.hasNext())
		{
			Object o = it.next();
			Sala s = (Sala) o;
			if(s.getPelicula().equals(pelicula))
			{
				infoAvanzadaPelicula.add(s);
			}
		}

		Collections.sort((List)infoAvanzadaPelicula); //ORDENO LA LISTA DE MENOR A MAYOR SEGUN EL HORARIO PARA ELLO IMPLEMENTO "Comparable" Y CREO EL METODO "CompareTo" EN LA CLASE SALA

		Manager jwInfo = new Manager(infoAvanzadaPelicula);

	}*/
	///SUSTITUYE LAS IMAGENES DE LAS PELICULAS/////
	/*private void sustitutoImagenes(int pos) 
	{
		lblDefault.setVisible(false);
		for(int i =0; i<lblPeli.length;i++)
			{
				lblPeli[i].setVisible(false);
			}
		lblPeli[pos].setVisible(true);
	}*/
	
	///////////////METODO PARA EVITAR DRY//////////////////////////////
	private void setIconoDeVentana(String imagen)
	{
		ImageIcon imgAdmin = new ImageIcon("PracticaFinal/images/"+imagen+".png");
		Manager.this.setIconImage(imgAdmin.getImage());
	}


	/////////////////////////////////////////////////////////////////////////////
	//////////////////////////////GESTOR DE EVENTOS//////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	
	private  void events()
	{/*
		/////GESTOR DEL COMPORTAMIENTO DE LA LISTA DESPLEGABLE/////
		cbPeliculas.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				btnEnter.setVisible(true);			
				int posFilm = cbPeliculas.getSelectedIndex();
				sustitutoImagenes(posFilm);
			}
		});
		///////////////GESTOR DEL COMPORTAMIENTO DEL BOTON ENTER///////////////////
		btnEnter.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				String selectedFilm = cbPeliculas.getSelectedItem().toString();
				Manager.this.infoAvanzadaPelicula(selectedFilm);
			}
		});*/

		/////GESTOR DEL COMPORTAMIENTO DE LA VENTANA PRINCIPAL/////
		this.addWindowListener(new WindowAdapter()
		{
		    public void windowClosing(WindowEvent e) 
		    {
		    	Manager.this.dispose();
				System.exit(0);	
		    }			
		});
	}
}