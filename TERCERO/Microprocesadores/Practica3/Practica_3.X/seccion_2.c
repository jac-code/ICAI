#include <xc.h>
#include "Pic32Ini.h"

#define BIT_LED0 0
#define BIT_LED1 1
#define BIT_LED2 2
#define BIT_LED3 3

int main(void) {
    //configuramos LED 0 como salida
    TRISC &= ~(1 << BIT_LED0);
    
    // configuramos LED 0 para que esté apagado
    LATC |= (1 << BIT_LED0);
    LATC |= (1 << BIT_LED1);
    LATC |= (1 << 2);
    LATC &= ~(1 << BIT_LED3);
    LATC |= (1 << BIT_LED3);
    
    T2CON = 0; // se para el temporizador 2
    TMR2 = 0; // se pone la cuenta a 0
    IFS0bits.T2IF = 0; // se borra el bit de fin de cuenta
    
    /* CALCULO DEL VALOR PR2 */
    // 1 Hz = periodo completo, por lo tanto,
    // LED encendido 0.5 seg
    // LED apagado 0.5 seg
    // PR2 = (retardo / (div * 200 ns)) - 1 --> <= 65535
    // en este caso tenemos PR2 = (0.5 seg / (64 * 200 ns)) - 1 = 39061
    
    PR2 = 39061;
    T2CON = 0x8060; // Timer 2 --> ON = 1 + reloj interno + prescaler = 64
    
    while(1) {
        if(IFS0bits.T2IF == 1) {
            // invertimos el valor del LED 0
            LATC ^= 1;
            // borramos el flag del Timer 2
            IFS0bits.T2IF = 0;
        }
    }
    
    return 0;
}

void apagar_led(int led) {
    if(led >= 0) {
        LATC |= (1 << led);
    }
}

void encender_led(int led) {
    if(led >= 0) {
        LATC &= ~(1 << led);
    }
}