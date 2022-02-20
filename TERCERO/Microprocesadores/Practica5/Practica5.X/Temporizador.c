#include <xc.h>
#include <stdio.h>
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

// variable contador que se irá iterando
static uint32_t ticks = 0;

__attribute__((vector(_TIMER_2_VECTOR), interrupt(IPL2SOFT), nomimps16))
void InterrupcionTimer2(void) {
    // borrar flag para que no vuelve a entrar 
    // solo entrar cuando se produzca interrupción
    IFS0bits.T2IF = 0;
    
    // rutina de atención a la interrupcion
    ticks++;
}

uint32_t TicksDesdeArr(void) {
    uint32_t temp;  // variable para hacer copia atomica
    
    asm(" di");  // inhabilitar interrupción
    temp = ticks;
    asm(" ei");  // habilitar
    
    return temp;
}
