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

void EnviarSalto() {
    char *punt;
    char salto [] = "\n";
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = salto;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
}

void EnviarPadding() {
    char *punt;
    char padding [] = "================================";
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = padding;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
}

void EnviarMensajeBienvenida() {
    char *punt;
    char mensaje [] = "BIENVENIDO AL PARKING DE ICAI";
    
    EnviarPadding();
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeParkingCompleto() {
    char *punt;
    char mensaje [] = "ACTUALMENTE EL PARKING ESTÁ COMPLETO";
    
    EnviarPadding();
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeParkingVacio() {
    char *punt;
    char mensaje [] = "ACTUALMENTE EL PARKING ESTÁ VACÍO";
    
    EnviarPadding();
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    
    EnviarSalto();
    EnviarPadding();
    EnviarSalto();
}

void EnviarMensajeInfoPlazas(int contador_plazas, int max_plazas) {
    char *punt;
    char numero_plazas[10];
    char mensaje_libres [] = "PLAZAS LIBRES: ";
    char mensaje_ocupadas [] = "PLAZAS OCUPADAS: ";
    char mensaje_total [] = "TOTAL PLAZAS GARAJE: ";
    
    EnviarPadding();
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje_libres;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
	
	sprintf(numero_plazas, "%d", max_plazas-contador_plazas);
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = numero_plazas;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje_ocupadas;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    
    sprintf(numero_plazas, "%d", contador_plazas);
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = numero_plazas;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    EnviarSalto();
    
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = mensaje_total;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    
    sprintf(numero_plazas, "%d", max_plazas);
    U1STAbits.UTXEN = 1;    // habilitar transmisor
    
    punt = numero_plazas;   // escribir frase
    while (*punt != '\0'){  // iteramos hasta la final de la cadena
        U1TXREG = *punt;    // enviamos caracter
        while(U1STAbits.TRMT == 0)
            ; 
        punt++;
    }
    
    U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
    EnviarSalto();
    
    EnviarPadding();
    EnviarSalto();
}
    
