#include <xc.h>

#define PIN_PULSADOR 5

int main (void)
{
	int pulsador_ant, pulsador_act, reinicio = 0;

	TRISC = ~0x0F;
	LATC = 0x0E;

	TRISB = 0xFF;

	pulsador_ant = (PORTB>>PIN_PULSADOR) & 1;
	while(1){
		pulsador_act = (PORTB>>PIN_PULSADOR) & 1;
		if ( ( pulsador_act != pulsador_ant) && (pulsador_act == 0)){
			if(reinicio==0){
				LATC = (LATC << 1) | 0x01;
				if((LATC & 0x0F) == 0x07){
					reinicio = 1;
				}
			}else{
				LATC = (LATC << 1)
				reinicio = 0;
			}
		}
		pulsador_ant = pulsador_act;
	}
}

/*
0000 1110
0001 1101
0011 1011
0111 0111

*/

