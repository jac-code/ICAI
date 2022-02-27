#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_LED0 0
#define PIN_LED1 1
#define PIN_LED2 2
#define PIN_LED3 3
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

int main (void) {
	int c;
    int pulsador_ant, pulsador_act;
    char texto [] = "Hola mundo";
    char *punt;
    
    int puerto = 0x0000;
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED1);
    puerto |= (1 << PIN_LED2);
    puerto |= (1 << PIN_LED3);
    
    ANSELC &= ~0xF; // Pines de los LEDs como digitales
    // ANSELC &= ~puerto;
    ANSELB &= ~((1 << 13)|(1 << 7)); // Se configura RB13 como digital
    
	TRISB |= (1<<13) | (1<<PIN_PULSADOR);   // pulsador como entrada
    TRISC &= ~(1 << PIN_LED0);   // LEDs como salida
    TRISC &= ~(1 << PIN_LED1);
    TRISC &= ~(1 << PIN_LED2);
    TRISC &= ~(1 << PIN_LED3);
    
    LATC = puerto;  // LEDs apagados

    SYSKEY=0xAA996655;
	SYSKEY=0x556699AA;
	U1RXR = 3;  // pin de recepción de la UART al RB13
	RPB7R = 1;  // pin para rb7
	SYSKEY=0x1CA11CA1;
	U1BRG = BAUDIOS;

	// Por defecto trabaja con el formato 8N1

	U1STAbits.URXEN = 1; // Se habilita el receptor
	U1STAbits.UTXEN = 0; // Se inhabilita el receptor 
	U1MODE = 0x8000; // Se arranca la UART
    
	while(1){ 
		// RECEPTOR
		if(U1STAbits.URXDA == 1){
			c = U1RXREG;
			LATC = ~(c & 0x0F);
            // LATC = ~(C & puerto);
		}

		// TRANSMISOR
		pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
        if ((pulsador_act != pulsador_ant) && (pulsador_act == 0)){
        	U1STAbits.UTXEN = 1;    // habilitar transmisor

        	punt = texto;   // escribir frase
			while (*punt != '\0'){  // iteramos hasta la final de la cadena
				U1TXREG = *punt;    // enviamos caracter
	            while(U1STAbits.TRMT == 0)
					; 
				punt++;
			}
            U1STAbits.UTXEN = 0;    // inhabilitar transmisión al terminar
        }
        pulsador_ant = pulsador_act;

	}
}
