#include <xc.h>
#include "Pic32Ini.h"
#include "Retardo.h"

#define BIT_LED0 0
#define MAX_TEMP 20 // 20 ms

int main (void) {
    // configuramos LED como salida
    TRISC &= ~(1 << BIT_LED0);
    
    // configuramos LED a 1 para que esté apagado
    LATC |= (1 << BIT_LED0);
    
    int cont, j;
    
    while(1) {
		for(j = 0; j <= MAX_TEMP; j++){ // tiempo retardo ascendiendo
			cont = Retardo(20-j); // retardo de 20-j ms
			if(cont == 0) {
                LATC ^= 1;
            }
			cont = Retardo(j); // retardo de j ms
			if(cont == 0) {
                LATC ^= 1;
            }
		}
		for(j = MAX_TEMP-1;j >= 0; j--){ // tiempo retardo descendiendo
			LATC ^= 1;
			cont = Retardo(j); // retardo de j ms
			if(cont == 0) {
                LATC ^= 1;
            }

            // para j != 0 generamos un retardo de 20-j ms
            // cuando j == 0 saltará a primer bucle for 
            // para empezar secuencia de nuevo
			if(j != 0){
				cont = Retardo(20-j);
 			}
 		}
	}
    
    return 0;
}