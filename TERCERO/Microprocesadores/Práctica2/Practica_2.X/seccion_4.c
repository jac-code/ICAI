#include <xc.h>

#define PIN_PULSADOR 5

int main(void) 
{
    int pulsador;
    
    // LEDs como salida
    TRISC = ~0x0F;
    
    // LEDs empiezan apagados
    LATC = 0x0F;
    
    // pulsador como entrada
    TRISB = 0xFF;
    
    while(1){
    	// Se lee el estado del pulsador
        pulsador = ( PORTB >> PIN_PULSADOR ) & 1;
        // Cuando se pulsa el pulsador se enciende el LED 0, al dejar de pulsar se apagan
        if(pulsador == 0){
            LATC &= ~1;
        }else{
            LATC |= 1;
        }   
    }
    
    return 0;
}