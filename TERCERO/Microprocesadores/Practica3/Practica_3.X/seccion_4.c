#include <xc.h>
#include "Pic32Ini.h"
#include "Retardo.h"

#define BIT_LED0 0

int main(void) {
    
    //configuramos LEC 0 como salida
    TRISC &= ~(1 << BIT_LED0);
    
    //configuramos LED 0 a 1 para que esté apagado
    LATC |= (1 << BIT_LED0);
    
    // retardo en ms
    uint16_t retardo = 500;
    
    while(1) {
        int k = Retardo(retardo);
        // si la función crea correctamente el retardo
        // devuelve un 0
        if(k == 0) {
            LATC ^= 1;
        }
    }
    
    return 0;
}