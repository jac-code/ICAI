#include <xc.h>

#define BIT_LED0 0
#define BIT_LED1 1
#define BIT_LED2 2
#define BIT_LED3 3

int main(void)
{
    // LEDs como salidas
    TRISC = ~0x0F;
    
    // variable de ayuda ya que no se puede escribir
    // el puerto C varias veces seguidas
    puerto = 0x0000;
    
    //encendidos LED 2 
    puerto |= (1 << BIT_LED0);
    puerto |= (1 << BIT_LED1);
    puerto &= ~(1 << BIT_LED2);
    puerto |= (1 << BIT_LED3);
    LATC = puerto;
    
    while(1)
        ;
    return 0;
}