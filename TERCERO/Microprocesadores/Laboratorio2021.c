/***************************** EJERCICIO 1 / 2 ****************************/
#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PR2 19530  // cada segundo --> 1 seg
#define PRESCALER 7 // 256 --> 7
#define PRIORIDAD 2
#define SUB_PRIORIDAD 0
#define PERIODO_PARPADEO 1  // parpadeo de 2 seg --> 1 seg encendido

int main(int argc, char const *argv[]) {
    uint32_t ticks_ant, ticks_act;

    ANSELC &= ~(1 << 0);
    TRISC &= ~(1 << 0);
    LATC |= (1 << 0);

    InicializarTimer2(PR2, PRIORIDAD, SUB_PRIORIDAD, PRESCALER);

    INTCON.MVEC = 1;
    asm(" ei");

    ticks_ant = TicksDesdeArrTimer2();

    while(1) {
        ticks_act = TicksDesdeArrTimer2();

        if ((ticks_act - ticks_ant) > PERIODO_PARPADEO) {
            LATCINV = (1 << 0);
            ticks_ant = ticks_act;
        }
    }
    
    return 0;
}


void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler) {
    T2CON = 0;
    TMR2 = 0;
    IFS0bits.T2IF = 0;
    PR2 = tiempo;
    IEC0bits.T2IE = 1;  // enable = 1
    IPC2bits.T2IP = prioridad;  // prioridad = 2
    IPC2bits.T2IS = subprioridad;  // subprioridad = 1
    
    T2CON = 0x8000; // Timer2 --> ON = 1 + reloj interno seleccionado
    // PRESCALER = [0, 1, 2, 3, 4, 6, 7]
    // #define BITS_PRESCALER 4 
    T2CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}

// variable contador que se irá iterando
static uint32_t ticks = 0;

__attribute__((vector(_TIMER_2_VECTOR), interrupt(IPL2SOFT), nomimps16))
void InterrupcionTimer2(void) {
    // Se borra el flag de interrupción para no volver a
    // entrar en esta rutina hasta que se produzca una nueva
    // interrupción.
    IFS0bits.T2IF = 0;
    
    // rutina de atención a la interrupcion
    ticks++;
}

uint32_t TicksDesdeArrTimer2(void) {
    uint32_t temp;  // variable para hacer copia atomica
    
    asm(" di");  // inhabilitar interrupción
    temp = ticks;
    asm(" ei");  // habilitar
    
    return temp;
}

/************************** EJERCICIO 3 ***********************/
#include <xc.h>
#include "Pic32Ini.h"

#define PR2 19530  // cada segundo --> 1 seg
#define PRESCALER 7 // 256 --> 7
#define PRIORIDAD 2
#define SUB_PRIORIDAD 0
#define PERIODO_PARPADEO 1  // parpadeo de 2 seg --> 1 seg encendido

#define PIN_LED0 0
#define PIN_LED1 1
#define PIN_LED2 2
#define PIN_LED3 3

#define PIN_PULSADOR 5

int main(int argc, char const *argv[])
{
    int puerto = 0x0000;
    int puls_ant, puls_act;
    uint32_t ticks_ant, ticks_act, ticks_puls_ant, ticks_puls_act;

    // todos apagados
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED1);
    puerto |= (1 << PIN_LED2);
    puerto |= (1 << PIN_LED3);

    TRISB |= (1 << PIN_PULSADOR);
    TRISC &= ~puerto;

    LATC |= puerto;

    InicializarTimer2(PR2, PRIORIDAD, SUB_PRIORIDAD, PRESCALER);

    INTCON.MVEC = 1;
    asm(" ei");

    ticks_ant = TicksDesdeArrTimer2();
    puls_ant = (PORTB >> PIN_PULSADOR) & 1;

    while(1) {
        ticks_act = TicksDesdeArrTimer2();

        if ((ticks_act - ticks_ant) > PERIODO_PARPADEO) {
            LATCINV = (1 << PIN_LED0);
            ticks_ant = ticks_act;
        }

        /******************** OPCIÓN 1 - AL SOLTAR EL PULSADOR, SALE LA CUENTA ******************/

        // Se lee el estado del pulsador
        puls_act = (PORTB >> PIN_PULSADOR) & 1;
        
        // cuando se pulsa se empieza a contar
        if((puls_ant != puls_act) && (puls_act == 0)) { // PULSADO
            ticks_puls_ant = TicksDesdeArrTimer2();
        }

        ticks_puls_act = TicksDesdeArrTimer2();
        // 0xFFF 1110 --> máscara para LEDS 1,2,3
        // LATC = ~contador; --> PARA METER VALOR EN PUERTO
        // LATC = ~((ticks_puls_act-ticks_puls_ant) & 0xFFFE);
        LATCCLR = ((ticks_puls_act-ticks_puls_ant) & 0xFFFE);

        ticks_puls_ant = ticks_puls_act;
        puls_ant = puls_act;
    }

    return 0;
}


