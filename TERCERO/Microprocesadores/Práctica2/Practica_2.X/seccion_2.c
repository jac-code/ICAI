#include <xc.h>

int main(void) 
{
    // se ponen los LEDs como salida
    TRISC = ~0x0F;
    
    // los LEDs son activos a nivel bajo
    LATC = ~0x0F;
    
    while(1)
        ;
    return 0;
}
