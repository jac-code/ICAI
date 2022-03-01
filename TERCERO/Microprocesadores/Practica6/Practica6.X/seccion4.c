#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_RB7 7

/*********** CÁLCULO DE UxBRG ***********/
/* UxBRG = (f_reloj / (16 * Baud Rate)) - 1 */
/* U1BRG = (5 mHz / (16 * 9600 baudios)) - 1 = 31,55 = 32 */
/****************************************/

/******* REVISAR EL VALOR CALCULADO *****/
/* Baud rate = f_reloj / (16 * (UxBRG + 1)) */
/* Baud rate = 5 mHz / (16 * (32 + 1)) = 9469,7 */
/* error = (9600 - 9469,7) / 9600 = 1,36% < 2% asi que BIEN*/
#define BAUDIOS 32

int main (void)
{
    int pulsador_ant, pulsador_act;
    char texto [] = "Hola mundo\r\n";
    char *punt; // tiene que ser puntero para ser de tamaño variable
    
    ANSELB &= ~(1 << PIN_RB7); // Se configura RB7 como digital
    TRISB &= ~(1 << PIN_RB7);
    TRISB |= (1 << PIN_PULSADOR);  // pulsador como entrada
    LATB = 0; // 1 = transmisor inhabilitado | 0 = habilitado

    SYSKEY=0xAA996655;
	SYSKEY=0x556699AA;
	RPB7R = 1;  // pin para rb7
	SYSKEY=0x1CA11CA1;
	U1BRG = BAUDIOS;

	// Por defecto trabaja con el formato 8N1
    U1MODEbits.BRGH = 0;
    U1MODEbits.PDSEL = 0;
    U1MODEbits.STSEL = 0;
    
	U1STAbits.UTXEN = 0; // Se inhabilita el transmisor 
	U1MODE = 0x8000; // Se arranca la UART

	pulsador_ant = (PORTB>>PIN_PULSADOR) & 1;

    while(1){
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
