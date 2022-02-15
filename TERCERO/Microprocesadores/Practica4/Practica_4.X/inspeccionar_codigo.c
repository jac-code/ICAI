#include <xc.h>

#define PIN_LED 0
#define PIN_PULSADOR 5
 
int main (void) {
    int valor_pulsador;
    
    // LED como salida, pulsador como entrada
    TRISC &= ~(1 << PIN_LED);
    TRISB |= (1 << PIN_PULSADOR);
    
    // LED empieza apagado
    LATC |= (1 << PIN_LED);
   
    while(1){
        valor_pulsador = ( PORTB >> PIN_PULSADOR ) & 1;
       
        // mientras el pulsador está pulsado = LED encendido
        if(valor_pulsador == 0){
            LATC &= ~(1 << PIN_LED);
        } else {
            LATC |= (1 << PIN_LED);
        }
    }
}

