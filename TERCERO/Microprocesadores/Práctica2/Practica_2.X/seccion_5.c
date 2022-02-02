#include <xc.h>

#define BIT_PULSADOR 5

int main(void)
{
    int pulsador_ant, pulsador_act;
    
    TRISC = ~0x0F;
    LATC = 0x0F;
    TRISB |= (1 << BIT_PULSADOR);
    
    //leemos el estado del pulsador
    //con PORTB --> leemos el valor del puerto
    //>> BIT_PULSADOR --> leemos valor en el campo del pulsador
    pulsador_ant = (PORTB >> BIT_PULSADOR) & 1;
    int contador = 0;
    
    while(1){
        pulsador_act = (PORTB >> BIT_PULSADOR) & 1;
        
        //si el pulsador == 0 --> está pulsado
        if((pulsador_act != pulsador_ant) && (pulsador_act == 0)){
            if(contador > 15) { // vuelve a empezar
                contador = 0;
            }
            contador = contador + 1;
            //escribimos en el puerto el valor del contador para que se enciendan los LEDs
            LATC = ~contador;
        }
        pulsador_ant = pulsador_act;
    }
    
    return 0;
}
