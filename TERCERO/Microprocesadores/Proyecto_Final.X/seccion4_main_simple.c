#include <xc.h>
#include <stdint.h>
#include "TemporizadorSeccion4Simple.h"
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_LED 1

#define MAX_PULSACIONES 5

/* CÁLCULO DE PR2 */
// PR2 = (retardo / (divisor * 200 ns)) - 1 <= 65535
// PR2 = (1 seg / (256 * 200 ns)) - 1 = 19531
#define PERIODO_TIMER2 19531 // le damos al jugador 1 seg para pulsar x5 veces el pulsador
#define PRIORIDAD_TIMER2 2
#define SUBPRIORIDAD_TIMER2 1
#define PRESCALER 256

#define RETARDO 4

int main(void) {
    int puls_ant, puls_act;
    
    // configurar entradas y salidas
    TRISB |= (1 << PIN_PULSADOR);
    TRISC &= ~(1 << PIN_LED);
    
    LATCSET = (1 << PIN_LED);  // poner a 1 --> apagado
    
    // llamamos a la función para inicializar Timer2
    InicializarTimer2(PERIODO_TIMER2, PRIORIDAD_TIMER2, SUBPRIORIDAD_TIMER2, PRESCALER);
    
    INTCONbits.MVEC = 1; // ponemos la CPU en modo multivector
    asm(" ei"); // activamos las interrupciones
    
    puls_ant = (PORTB >> PIN_PULSADOR) & 1;
    
    while(1) {
        puls_act = (PORTB >> PIN_PULSADOR) & 1;
        
        if((puls_ant != puls_act) && (puls_act == 0)) { // detectar flanco bajada pulsador
            asm( "di");  // desactivamos interupciones
            num_pulsaciones++;
            asm(" ei");  // activamos interrupciones
            
            if(num_pulsaciones >= MAX_PULSACIONES) {
                fin_partida = 1;
                LATCCLR = (1 << PIN_LED);  // poner a 0 --> encendido
            }
        }
        puls_ant = puls_act;
    }
}


