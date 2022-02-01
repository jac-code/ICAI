#include <xc.h>

#define BIT_LED0 0
#define BIT_LED1 1
#define BIT_LED2 2
#define BIT_LED3 3

int main(void)
{
    TRISC = ~0x0F;
    
    puerto = 0x0000;
    //encendidos LED 2 y LED 3
    puerto |= (1 << BIT_LED0);
    puerto |= (1 << BIT_LED1);
    puerto &= ~(1 << BIT_LED2);
    puerto &= ~(1 << BIT_LED3);
    LATC = puerto;
    
    while(1)
        ;
    return 0;
}
