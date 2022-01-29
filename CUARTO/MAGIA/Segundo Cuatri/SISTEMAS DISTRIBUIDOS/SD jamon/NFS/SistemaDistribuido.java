/*package PracticaFinal.swing;
import PracticaFinal.swing.JAdmin;
import PracticaFinal.swing.JUser;
import PracticaFinal.logica.Gestor;
import PracticaFinal.dominio.Sala;
import PracticaFinal.io.Ficheros;*/

import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JTextField;
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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Collection;

import java.io.IOException;
import java.lang.NumberFormatException;

public class SistemaDistribuido extends JFrame
{
	     //SE DEFINEN LAS FUENTES Y LOS COMPONENTES//
	///////////////////////////////////////////////////////
	Font fntPassword = new Font("Arial", Font.BOLD, 25);
	Font fntError = new Font("Arial", Font.BOLD, 30);
	Font fntButton = new Font("Arial", Font.BOLD, 35);

	Container c;
	JButton btnEnter;
	JButton btnUser;
	JButton btnAdmin;
	JPanel pnlSouth;
	JLabel lblError;
	JLabel lblUpload;
	JLabel lblCreate;
	JTextField pssPassword;

	//////////////////////////////////////////////////////////////////////////
	public static void main(String args[])
	{
		new SistemaDistribuido();
	}

	//////////////////////////////////////////////////////////////////////////
	public SistemaDistribuido()
	{
		Container c = this.getContentPane();
		c.setLayout(new BorderLayout());

		//////////////////////////////////////////////////////////////////////////
		//SE CREAN Y AGREGAN LOS COMPONENTES//
		/////////////////////////////////////////////////////////////////////////
		this.setSize(1024,768);
		lblError = new JLabel("Error!");
		lblUpload = new JLabel("Introduzca nombre y extension del fichero que quiere subir: ");
		lblCreate = new JLabel("Introduzca fichero a Crear: ");
		btnEnter = new JButton("Upload");
		pssPassword = new JTextField(20);
		btnUser = new JButton(new ImageIcon("upload.png"));
		btnAdmin = new JButton(new ImageIcon("Create.png"));
		
		ImageIcon imgMain = new ImageIcon("cloud.jpeg");
		c.add(new JLabel("",imgMain,JLabel.CENTER), BorderLayout.CENTER);

		JPanel pnlNorth = new JPanel(new FlowLayout());
		pnlSouth = new JPanel(new FlowLayout());

	    //PANEL NORTE//
		pnlNorth.add(btnUser);
		pnlNorth.add(btnAdmin);
		c.add(pnlNorth, BorderLayout.NORTH);

		//PANEL DE CAMBIO DE CLAVE//
		pnlSouth.add(lblCreate);
		pnlSouth.add(pssPassword);
		pnlSouth.add(btnEnter);		
		pnlSouth.add(lblError);

		c.add(pnlSouth, BorderLayout.SOUTH);

		pnlSouth.setVisible(false);

		//DEFINICION DE FUENTES//
		////////////////////////////////////////////////////
		btnEnter.setFont(fntButton);
		btnUser.setFont(fntButton);
		btnAdmin.setFont(fntButton);
		lblCreate.setFont(fntPassword);
		pssPassword.setFont(fntPassword);
		lblError.setFont(fntError);
		lblError.setForeground(Color.RED);

		c.setBackground(Color.WHITE);
		pnlSouth.setBackground(Color.WHITE);
		pnlNorth.setBackground(Color.WHITE);
		btnUser.setBackground(Color.WHITE);
		btnAdmin.setBackground(Color.WHITE);

		////////////////////////////////////////////////////

		//OPCIONES DE VENTANA//
		////////////////////////////////////////////////////
		this.events();
		this.setVisible(true);
		this.setTitle("JMAIN");
		this.setLocationRelativeTo(null);
		this.setSize(1000,1000);
		this.setExtendedState(this.MAXIMIZED_BOTH); 
		this.setResizable(false);
		this.setIconoDeVentana("Main");
		btnUser.setPreferredSize(100,100);
		btnAdmin.setSize(100,100);
		////////////////////////////////////////////////////
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	private void setIconoDeVentana(String imagen)
	{
		ImageIcon imgAdmin = new ImageIcon("cloud.jpeg");
		SistemaDistribuido.this.setIconImage(imgAdmin.getImage());
	}



	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////GESTOR DE EVENTOS/////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void events()
	{
		btnUser.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{	
				SistemaDistribuido.this.setVisible(false);
				lblCreate.setVisible(true);
				//new JUser();
			}
		});
		btnAdmin.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				pnlSouth.setVisible(true);
				lblError.setVisible(false);
			}
		});	
		btnEnter.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				if((pssPassword.getText()).equals("pass"))
				{
					SistemaDistribuido.this.setVisible(false);
					//new JAdmin();
				}
				else
				{
					lblError.setVisible(true);
				}
			}
		});

		this.addWindowListener(new WindowAdapter()
		{
			public void windowClosing(WindowEvent e)
			{
				System.exit(0);
			}
		});
	}
}


