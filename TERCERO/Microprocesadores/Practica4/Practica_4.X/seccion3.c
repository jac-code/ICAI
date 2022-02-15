#include <xc.h>
#include "Pic32Ini.h"

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
            //LATC &= ~1;
            asm("  lui $v0, 0xBF88");   // 0xBF88 = -16504
            asm("  lw $v1, 25136($v0)");
            asm("  addiu $a0, $zero, -2");  // -2 = 0xFFFE
            asm("  and $v1, $v1, $a0");
            asm("  sw $v1, 25136($v0)");
           
        } else {
            LATC |= (1 << PIN_LED);
        }
    }
}
