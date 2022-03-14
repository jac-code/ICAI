#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "UART1.h"

#define BAUDIOS 9600

int main (void) {
    char c[] = "12";
    InicializarUART1(BAUDIOS);
    
    INTCONbits.MVEC = 1;  // activar interrupciones
    asm(" ei");
    
    while(1){
       c[0] = getcUART();
       c[1] = '\0';
       putsUART(c);
    }
    
    return 0;
}

