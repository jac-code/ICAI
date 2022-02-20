#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define BITS_PRESCALER 4

void InicializarTimer3(int tiempo, int prioridad, int subprioridad, int valor_prescaler) {
    T3CON = 0;
    TMR3 = 0;
    IFS0bits.T3IF = 0;
    PR3 = tiempo;
    IEC0bits.T3IE = 1;  // enable = 1
    IPC3bits.T3IP = prioridad;  // prioridad = 4
    IPC3bits.T3IS = subprioridad;  // subprioridad = 0
    
    T3CON = 0x8000; // Timer3 --> ON = 1 + reloj interno seleccionado
    T3CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente

}

// variable contador que se irá iterando
static uint32_t ticks = 0;

__attribute__((vector(_TIMER_3_VECTOR), interrupt(IPL4SOFT), nomimps16))
void InterrupcionTimer3(void) {
    // Se borra el flag de interrupción para no volver a
    // entrar en esta rutina hasta que se produzca una nueva
    // interrupción.
    IFS0bits.T3IF = 0;
    
    // rutina de atención a la interrupcion
    ticks++;
}

uint32_t TicksDesdeArrTimer3(void) {
    uint32_t temp;  // variable para hacer copia atomica
    
    asm(" di");  // inhabilitar interrupción
    temp = ticks;
    asm(" ei");  // habilitar
    
    return temp;
}
