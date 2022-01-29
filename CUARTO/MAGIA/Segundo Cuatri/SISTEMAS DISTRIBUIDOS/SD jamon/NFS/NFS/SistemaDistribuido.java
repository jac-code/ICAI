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

import java.io.BufferedReader;
import java.io.InputStreamReader;


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
	Font fntLabel = new Font("Arial", Font.BOLD, 20);

	Process p;

	Container c;
	JButton btnUpload;
	JButton btnShare;
	JButton btnNewFile;
	JButton btnCreate;	
	JPanel pnlSouth;
	JLabel lblError;
	JLabel lblUpload;
	JLabel lblCreate;
	JTextField buscarArchivo;
	JTextField crearArchivo;
	String departamento;


	//////////////////////////////////////////////////////////////////////////
	/*public static void main(String args[])
	{
		new SistemaDistribuido(departamento);
	}*/

	//////////////////////////////////////////////////////////////////////////
	public SistemaDistribuido(String departamento)
	{
		departamento = this.departamento;
		Container c = this.getContentPane();
		c.setLayout(new BorderLayout());

		//////////////////////////////////////////////////////////////////////////
		//SE CREAN Y AGREGAN LOS COMPONENTES//
		/////////////////////////////////////////////////////////////////////////
		this.setSize(1080,800);
		lblError = new JLabel("Error!");
		lblUpload = new JLabel("Introduzca nombre y extension del fichero que quiere subir: ");
		lblCreate = new JLabel("Introduzca fichero a Crear: ");
		btnUpload = new JButton("Upload");
		btnCreate = new JButton("Create");
		buscarArchivo = new JTextField(20);
		crearArchivo = new JTextField(20);

		btnShare = new JButton(new ImageIcon("ShareFile.png"));
		btnNewFile = new JButton(new ImageIcon("CreateFile.png"));
		
		ImageIcon imgMain = new ImageIcon("interCloud.jpg");
		c.add(new JLabel("",imgMain,JLabel.CENTER), BorderLayout.CENTER);

		JPanel pnlNorth = new JPanel(new FlowLayout());
		pnlSouth = new JPanel(new FlowLayout());

	    //PANEL NORTE//
		pnlNorth.add(btnShare);
		pnlNorth.add(btnNewFile);
		c.add(pnlNorth, BorderLayout.NORTH);

		//PANEL DE CAMBIO DE CLAVE//
		pnlSouth.add(lblCreate);
		pnlSouth.add(lblUpload);

		pnlSouth.add(crearArchivo);
		pnlSouth.add(buscarArchivo);
		pnlSouth.add(btnUpload);	
		pnlSouth.add(btnCreate);		
		pnlSouth.add(lblError);

		c.add(pnlSouth, BorderLayout.SOUTH);

		pnlSouth.setVisible(false);


		//DEFINICION DE FUENTES//
		////////////////////////////////////////////////////
		btnCreate.setFont(fntButton);
		btnUpload.setFont(fntButton);
		btnShare.setFont(fntButton);
		btnNewFile.setFont(fntButton);

		lblCreate.setFont(fntButton);
		lblUpload.setFont(fntLabel);

		buscarArchivo.setFont(fntLabel);
		crearArchivo.setFont(fntLabel);

		lblError.setFont(fntError);
		lblError.setForeground(Color.RED);

		c.setBackground(Color.WHITE);
		pnlSouth.setBackground(Color.WHITE);
		pnlNorth.setBackground(Color.WHITE);
		btnShare.setBackground(Color.WHITE);
		btnNewFile.setBackground(Color.WHITE);

		////////////////////////////////////////////////////

		//OPCIONES DE VENTANA//
		////////////////////////////////////////////////////
		this.events();
		this.setVisible(true);
		this.setTitle("interCloud");
		this.setLocationRelativeTo(null);
		this.setSize(1000,1000);
		this.setExtendedState(this.MAXIMIZED_BOTH); 
		this.setResizable(true);
		this.setIconoDeVentana("Main");

		////////////////////////////////////////////////////
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	private void setIconoDeVentana(String imagen)
	{
		ImageIcon imgAdmin = new ImageIcon("interCloud.jpg");
		SistemaDistribuido.this.setIconImage(imgAdmin.getImage());
	}



	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////GESTOR DE EVENTOS/////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void events()
	{
		btnShare.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{	
				buscarArchivo.setVisible(true);
				crearArchivo.setVisible(false);
				pnlSouth.setVisible(true);
				btnUpload.setVisible(true);
				btnCreate.setVisible(false);
				lblUpload.setVisible(true);
				lblCreate.setVisible(false);
				lblError.setVisible(false);

			}
		});
		btnNewFile.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				pnlSouth.setVisible(true);
				buscarArchivo.setVisible(false);
				crearArchivo.setVisible(true);
				btnUpload.setVisible(false);
				btnCreate.setVisible(true);
				lblError.setVisible(false);
				lblUpload.setVisible(false);
				lblCreate.setVisible(true);
			}
		});	
		btnUpload.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				//System.out.println(buscarArchivo.getText());
				try
				{
					p = Runtime.getRuntime().exec("sudo cp "+buscarArchivo.getText()+" /mnt/nfs/"+departamento);
					p.waitFor();
					System.out.println("\n Se Subió el Archivo "+buscarArchivo.getText());
					p.destroy();
				}
				catch(Exception e1)
				{
					e1.printStackTrace();
					lblError.setVisible(true);
				}
				

				/*if((buscarArchivo.getText()).equals("pass"))
				{
					SistemaDistribuido.this.setVisible(false);
				}
				else
				{
					lblError.setVisible(true);
				}*/
			}
		});
		btnCreate.addActionListener(new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				try
				{
					p = Runtime.getRuntime().exec("sudo touch "+crearArchivo.getText()+" /mnt/nfs/"+departamento+"/"+crearArchivo.getText());
					p.waitFor();
					System.out.println("\n Se Subió creó el Archivo "+crearArchivo.getText());
					p.destroy();

				}

				catch(Exception e2)
				{
					e2.printStackTrace();
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


