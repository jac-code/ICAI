#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "TemporizadorTimer2.h"

#define BITS_PRESCALER 4

void InicializarTimer2(int tiempo, int valor_prescaler) {
    T2CON = 0;
    TMR2 = 0;
    PR2 = tiempo;
    
    T2CON = 0x8000; // Timer2 --> ON = 1 + reloj interno seleccionado
    T2CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}
