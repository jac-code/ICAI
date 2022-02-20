#include <xc.h>
#include <stdint.h>
#include "Temporizador.h"
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_LED0 0
#define PIN_LED3 3

// se encienda y apague 2 seg = 1 seg apagado + 1 seg encendido
#define T_PARPADEO 1000 // en ms

/* CÁLCULO DE PR2 */
// PR2 = (retardo / (divisor * 200 ns)) - 1 <= 65535
// PR2 = (1 ms / (1 * 200 ns)) - 1 = 4999
#define PERIODO_TIMER2 4999 // valor de PR2
#define PRIORIDAD_TIMER2 2
#define SUBPRIORIDAD_TIMER2 1
#define PRESCALER 0

int main(void) {
    int pulsador, puerto;
    uint32_t ticks_ant, ticks_act;
    
    // configurar entradas y salidas
    TRISB |= (1 << PIN_PULSADOR);
    TRISC &= ~(1 << PIN_LED0);
    TRISC &= ~(1 << PIN_LED3);
    
    // LED 0 y LED 3 empiezan apagados
    puerto = 0x0000;
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED3);
    LATC |= puerto;
    
    // llamamos a la función para inicializar Timer2
    InicializarTimer2(PERIODO_TIMER2, PRIORIDAD_TIMER2, SUBPRIORIDAD_TIMER2, PRESCALER);
    
    // activamos las interrupciones
    INTCONbits.MVEC = 1;
    asm(" ei");
    
    ticks_ant = TicksDesdeArr();
    
    while(1) {
        ticks_act = TicksDesdeArr();
        if((ticks_act - ticks_ant) > T_PARPADEO) {  // con la resta medimos el tiempo transcurrido
            ticks_ant = ticks_act;
            LATC ^= (1 << PIN_LED3); // invertimos el LED 0
        }
        
        pulsador = (PORTB >> PIN_PULSADOR) & 1;
        
        if(pulsador == 0) { // está pulsado
            LATC &= ~(1 << PIN_LED0); // ponemos el LED = 0 --> endencendido
        } else {
            LATC |= (1 << PIN_LED0); // ponemos el LED = 1 --> apagado
        }
    }
}

