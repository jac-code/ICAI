#include <xc.h>
#include <stdint.h>
#include "TemporizadorTimer2.h"   // Timer2
#include "TemporizadorTimer3.h"  // Timer3
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_LED0 0
#define PIN_LED2 2
#define PIN_LED3 3

#define T_PARPADEO_LED3 1000 // en ms
#define T_PARPADEO_LED2 500 // en ms

/* CÁLCULO DE PR2 */
// PR2 = (retardo / (divisor * 200 ns)) - 1 <= 65535
// PR2 = (1 ms / (1 * 200 ns)) - 1 = 4999
#define PERIODO_TIMER2 4999 // valor de PR2
#define PRIORIDAD_TIMER2 2
#define SUBPRIORIDAD_TIMER2 1
#define PRESCALER_TIMER2 0

/* CÁLCULO DE PR3 */
// PR3 = (retardo / (divisor * 200 ns)) - 1 <= 65535
// PR3 = (1 ms / (1 * 200 ns)) - 1 = 4999
#define PERIODO_TIMER3 4999 // valor de PR3
#define PRIORIDAD_TIMER3 4
#define SUBPRIORIDAD_TIMER3 0
#define PRESCALER_TIMER3 0

int main(void) {
    int pulsador, puerto;
    uint32_t ticks_ant, ticks_act, ticks_ant2, ticks_act2;
    
    // configurar entradas y salidas
    TRISB |= (1 << PIN_PULSADOR);
    TRISC &= ~(1 << PIN_LED0);
    TRISC &= ~(1 << PIN_LED2);
    TRISC &= ~(1 << PIN_LED3);
    
    // LEDs empiezan apagados
    puerto = 0x0000;
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED2);
    puerto |= (1 << PIN_LED3);
    LATC |= puerto;
    
    // llamamos a las funciones para inicializar los timers
    InicializarTimer2(PERIODO_TIMER2, PRIORIDAD_TIMER2, SUBPRIORIDAD_TIMER2, PRESCALER_TIMER2);
    InicializarTimer3(PERIODO_TIMER3, PRIORIDAD_TIMER3, SUBPRIORIDAD_TIMER3, PRESCALER_TIMER3);
    
    INTCONbits.MVEC = 1; // ponemos CPU en modo multvector
    asm(" ei"); // activamos interrupciones
    
    ticks_ant = TicksDesdeArrTimer2();
    ticks_ant2 = TicksDesdeArrTimer3();
    
    while(1) {
        // para el LED3 se utiliza el TIMER2
        ticks_act = TicksDesdeArrTimer2();
        if( (ticks_act - ticks_ant) > T_PARPADEO_LED3){ // con la resta medimos el tiempo transcurrido
              ticks_ant = ticks_act;
              LATCINV = (1 << PIN_LED3);
        }
        
        // para el LED2 se utiliza TIMER3
        ticks_act2 = TicksDesdeArrTimer3();
        if( (ticks_act2 - ticks_ant2) > T_PARPADEO_LED2){
              ticks_ant2 = ticks_act2;
              LATCINV = (1 << PIN_LED2);
        }
        
        pulsador = (PORTB >> PIN_PULSADOR) & 1;
        
        if(pulsador == 0) { // está pulsado
            LATCCLR = (1 << PIN_LED0);  // LED = 0 --> encendido
        } else {
            LATCSET = (1 << PIN_LED0);  // LED = 1 --> apagado
        }
    }
}
