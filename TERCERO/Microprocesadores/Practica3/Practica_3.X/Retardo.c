#include <xc.h>

#define NUM_MAX_16BITS 65535
#define BITS_PRESCALER 4

int Retardo(uint16_t retardo_ms)
{
	int prescaler[] = {1, 2, 4, 8, 16, 32, 64, 256};
	int i = -1;
	int prescaler_ok = 1;
    float res;
    
    // primero vamos a comprobar el valor del retardo
    if(retardo_ms <= 0) {
        // no entramos en el bucle while
        i = 8;
    }
    
    // iteramos por cada valor de prescaler posible
	while ((i < 7) && (prescaler_ok == 1)){
		i++;
        res = (retardo_ms / (prescaler[i] * 0.0002)) - 1;
		if(res <= NUM_MAX_16BITS){
            // PR2 correcto nos salimos del bucle while
			prescaler_ok = 0;
		}
	}
    
    // solo si se ha conseguido generar el retardo 
    // se configura el temporizador
    if(prescaler_ok == 0) {
        T2CON = 0; // Se para el temporizador 2
        TMR2 = 0; // Cuenta a 0
        IFS0bits.T2IF = 0; // Se borra el bit de fin de cuenta
        PR2 = (uint16_t)res;
        T2CON = 0x8000; // Timer 2 encendido --> ON = 1
        T2CON |= (prescaler << BITS_PRESCALER);

        while(IFS0bits.T2IF == 0){
            ;// Espera el fin del temporizador
        }
        
        T2CON = 0;
        TMR2 = 0;
        IFS0bits.T2IF = 0; // Se borra el bit de fin de cuenta
    }

	return prescaler_ok;
}