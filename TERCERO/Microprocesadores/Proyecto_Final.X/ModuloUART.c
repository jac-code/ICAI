#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloUART.h"
#include <string.h>
#include <stdio.h>

#define PIN_RB13 13 // recepción
#define PIN_RB7 7   // transmisión

/*********** CÁLCULO DE UxBRG ***********/
/* UxBRG = (f_reloj / (16 * Baud Rate)) - 1 */
/* U1BRG = (5 mHz / (16 * 9600 baudios)) - 1 = 31,55 = 32 */
/****************************************/

/******* REVISAR EL VALOR CALCULADO *****/
/* Baud rate = f_reloj / (16 * (UxBRG + 1)) */
/* Baud rate = 5 mHz / (16 * (32 + 1)) = 9469,7 */
/* error = (9600 - 9469,7) / 9600 = 1,36% < 2% asi que BIEN*/
#define BAUDIOS 32

void InicializarUART1() {
    ANSELB &= ~((1 << PIN_RB13)|(1 << PIN_RB7)); // digitales
    TRISB |= (1 << PIN_RB13);
    
    SYSKEY = 0xAA996655;
	SYSKEY = 0x556699AA;
	U1RXR = 3;  // pin de recepción de la UART al RB13
	RPB7R = 1;  // pin para RB7
	SYSKEY = 0x1CA11CA1;
	U1BRG = BAUDIOS;

	// Por defecto trabaja con el formato 8N1
    U1MODEbits.BRGH = 0;
    U1MODEbits.PDSEL = 0;
    U1MODEbits.STSEL = 0;
    
	U1STAbits.URXEN = 1; // Se habilita el receptor
	U1STAbits.UTXEN = 0; // Se inhabilita el receptor 
	U1MODE = 0x8000; // Se arranca la UART
}

void EnviarCadena(char cadena[]) {
    char *punt;
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = cadena;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
}

void EnviarSalto() {
    char salto [] = "\n";
    EnviarCadena(salto);
}

void EnviarPadding() {
    char padding [] = "================================";
    EnviarCadena(padding);
}

void ConfiguracionGaraje() {
    char seleccion [] = "Seleccione como desea usar el garaje: ";
    char opcion_manual [] = "De manera manual (M)";
    char opcion_automatica [] = "De manera automatica (A)";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(seleccion);
    EnviarSalto();
    
    EnviarCadena(opcion_manual);
    EnviarSalto();
    
    EnviarCadena(opcion_automatica);
    EnviarSalto();
    
    //EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeBienvenida() {
    char mensaje [] = "BIENVENIDO AL PARKING DE ICAI";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeAbrirBarrera() {
    char mensaje [] = "Abriendo la barrera...";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeDenegarAcceso() {
    char mensaje [] = "Acceso denegado!!";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeCocheEntrada() {
    char mensaje_detectar [] = "Se ha detectado un coche en la entrada.";
    char mensaje_abrir [] = "¿Desea abrir la barrera?";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje_detectar);
    EnviarSalto();
    
    EnviarCadena(mensaje_abrir);
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeCocheSalida() {
    char mensaje_detectar [] = "Se ha detectado un coche en la salida.";
    char mensaje_abrir [] = "¿Desea abrir la barrera?";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje_detectar);
    EnviarSalto();
    
    EnviarCadena(mensaje_abrir);
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeParkingCompleto() {
    char mensaje [] = "ACTUALMENTE EL PARKING ESTÁ COMPLETO";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeParkingVacio() {
    char mensaje [] = "ACTUALMENTE EL PARKING ESTÁ VACÍO";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeModoAutomaticoSeleccionado() {
    char mensaje [] = "HA SELECCIONADO EL MODO AUTOMATICO";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeModoManualSeleccionado() {
    char mensaje [] = "HA SELECCIONADO EL MODO MANUAL";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje);
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeInfoPlazas(int contador_plazas, int max_plazas) {
    char numero_plazas[10];
    char mensaje_libres [] = "PLAZAS LIBRES: ";
    char mensaje_ocupadas [] = "PLAZAS OCUPADAS: ";
    char mensaje_total [] = "TOTAL PLAZAS GARAJE: ";
    
    EnviarPadding();
    EnviarSalto();
    
    EnviarCadena(mensaje_libres);
	
	sprintf(numero_plazas, "%d", max_plazas-contador_plazas);
    EnviarCadena(numero_plazas);
    EnviarSalto();
    
    EnviarCadena(mensaje_ocupadas);
    
    sprintf(numero_plazas, "%d", contador_plazas);
    EnviarCadena(numero_plazas);
    EnviarSalto();
    
    EnviarCadena(mensaje_total);
    
    sprintf(numero_plazas, "%d", max_plazas);
    EnviarCadena(numero_plazas);
    EnviarSalto();
    
    EnviarPadding();
    EnviarSalto();
}

char RecibirComando() {
    char c = '0';
    
    if(U1STAbits.URXDA == 1){
        c = U1RXREG;
    }
    return c;
}