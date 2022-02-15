#include <xc.h>

#define BIT_PULSADOR 5
#define BIT_LED0 0
#define BIT_LED1 1
#define BIT_LED2 2
#define BIT_LED3 3

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
    
    int puerto = 0x0000;
    //encendemos solo el LED 2
    puerto &= ~(1 << BIT_LED0);
    puerto |= (1 << BIT_LED1);
    puerto |= (1 << BIT_LED2);
    puerto |= (1 << BIT_LED3);
    LATC = puerto;
    
    while(1){
        pulsador_act = (PORTB >> BIT_PULSADOR) & 1;
        
        //si el pulsador == 0 --> está pulsado
        if((pulsador_act != pulsador_ant) && (pulsador_act == 0)){
            //ponemos todos los campos a 0 --> se encienden los LEDs
            contador = contador + 1;
            
            if(contador < 5){
            	//desplazamos un 0 a la derecha y ponemos un 0 en la posicion anterior
                LATC &= ~(1 << contador);
                //tenemos que hacer un 
                asm(" NOP");
                LATC |= (1 << (contador - 1));
            }
            //si llegamos al final de la secuencia resetear al valor incial
            if(contador == 4) {
                contador = 0;
                LATC = 14;
            }
        }
        
        pulsador_ant = pulsador_act;
    }
    
    return 0;
}
