#include <xc.h>
#include "Retardo.h"
#include "Pic32Ini.h"

#define PIN_LED 0

int main(void) {
	// LED como salida
    TRISC &= ~(1 << PIN_LED);
    
    // LED empieza apagado
    LATC |= (1 << PIN_LED);

	while(1){
		Retardo(500);

		LATC ^= (1 << PIN_LED);
	}
}
