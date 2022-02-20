#include <xc.h>
#include "Pic32Ini.h"

#define PIN_PULSADOR 5
#define PIN_LED0 0

int main(void) {
    int pulsador;
    
    // configurar entradas y salidas
    TRISB |= (1 << PIN_PULSADOR);
    TRISC &= ~(1 << PIN_LED0);
    
    // LED apagado
    LATC |= (1 << PIN_LED0);
    
    while(1) {
        pulsador = (PORTB >> PIN_PULSADOR) & 1;
        
        if(pulsador == 0) { // está pulsado
            LATCCLR = (1 << PIN_LED0);
            // LATC &= ~(1 << PIN_LED0)
        } else {
            LATCSET = (1 << PIN_LED0);
            // LATC |= (1 << PIN_LED0);
        }
    }
}
