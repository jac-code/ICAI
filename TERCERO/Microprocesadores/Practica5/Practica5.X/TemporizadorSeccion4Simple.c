#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define BITS_PRESCALER 4

void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler) {
    T2CON = 0;  // se para el temporizador
    TMR2 = 0;   //se pone la cuenta a 0
    IFS0bits.T2IF = 0;  // borrar bit fin de cuenta (flag)
    PR2 = tiempo;
    IEC0bits.T2IE = 1;  // enable = 1
    IPC2bits.T2IP = prioridad;  // prioridad = 2
    IPC2bits.T2IS = subprioridad;  // subprioridad = 1
    
    T2CON = 0x8000; // Timer2 --> ON = 1 + reloj interno seleccionado
    T2CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}

// variable global compartida que cuenta las pulsaciones
static uint16_t num_pulsaciones = 0;

__attribute__((vector(_TIMER_2_VECTOR), interrupt(IPL2SOFT), nomips16))
void InterrupcionTimer2(void) {
    // Se borra el flag de interrupción para no volver a
    // entrar en esta rutina hasta que se produzca una nueva
    // interrupción.
    IFS0bits.T2IF = 0;
    
    // rutina de atención interrupción
    // se ponen a 0 las pulsaciones al saltar la interrupción
    num_pulsaciones = 0;
}