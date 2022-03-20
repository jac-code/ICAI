/******************** PLANTILLA PARA HEADERS *********************/
#ifndef PIC32INI_H
#define	PIC32INI_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarReloj(void);

#ifdef	__cplusplus
}
#endif

#endif	/* PIC32INI_H */

/************************* INICIALIZAR LEDS ************************/
#define PIN_LED0 0
#define PIN_LED1 1
#define PIN_LED2 2
#define PIN_LED3 3

int puerto = 0x0000;

// todos apagados
puerto |= (1 << PIN_LED0);
puerto |= (1 << PIN_LED1);
puerto |= (1 << PIN_LED2);
puerto |= (1 << PIN_LED3);

// NO ESTOY SEGURO DE ESTO --> pero creo que si
TRISC &= ~puerto;
LATC |= puerto;

// todos encendidos
puerto &= ~(1 << PIN_LED0);
puerto &= ~(1 << PIN_LED1);
puerto &= ~(1 << PIN_LED2);
puerto &= ~(1 << PIN_LED3);

TRISC &= ~(1 << PIN_LED0);
TRISC &= ~(1 << PIN_LED1);
TRISC &= ~(1 << PIN_LED2);
TRISC &= ~(1 << PIN_LED3);

/************************** TIMER 2 ********************************/
void InicializarTimer2(int tiempo, int valor_prescaler) {
    T2CON = 0;
    TMR2 = 0;
    IFS0bits.T2IF = 0;
    PR2 = tiempo;

    T2CON = 0x8000;
    // PRESCALER = [0, 1, 2, 3, 4, 6, 7]
    T2CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}

/************************ TIMER 2 - INTERRUPCIONES ***************/
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

/************************** TIMER 3 ********************************/
void InicializarTimer3(int tiempo, int valor_prescaler) {
    T3CON = 0;
    TMR3 = 0;
    IFS0bits.T3IF = 0;
    PR3 = tiempo;
    
    T3CON = 0x8000; // Timer3 --> ON = 1 + reloj interno seleccionado
    // #define BITS_PRESCALER 4 
    T3CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}

/************************ TIMER 3 - INTERRUPCIONES ***************/
void InicializarTimer3(int tiempo, int prioridad, int subprioridad, int valor_prescaler) {
    T3CON = 0;
    TMR3 = 0;
    IFS0bits.T3IF = 0;
    PR3 = tiempo;
    IEC0bits.T3IE = 1;  // enable = 1
    IPC3bits.T3IP = prioridad;  // prioridad = 4
    IPC3bits.T3IS = subprioridad;  // subprioridad = 0
    
    T3CON = 0x8000; // Timer3 --> ON = 1 + reloj interno seleccionado
    // #define BITS_PRESCALER 4 
    T3CON |= (valor_prescaler << BITS_PRESCALER);   // añadimos el prescaler correspondiente
}

/***************** TIMER 2,3 - RETARDO ELEVADO *********************/
void InicializarTimers() {
    T2CON = 0; // Se para el temporizador 2
    T3CON = 0; // y el 3
    T2CON = 8; // Se pone en modo 32 bits
    TMR2 = 0; // Cuenta a 0
    IFS0bits.T3IF = 0; // Se borra el bit de fin de cuenta
    PR2 = 24999999; // Periodo de 5 s con divisor a 1
    T2CON = 0x8008; // Timer 2 on, div. a 1, 32 bits y reloj interno

    // IMPORTANTE QUE ES EL FLAG --> TEMPORIZADOR 3
    while(IFS0bits.T3IF == 0)
    ; // Espera el fin del temporizador
}

/***************** TIMER 3 - TEMPORIZADOR CON PULSADOR *********************/

// Pines del pulsador y del LED como digitales
ANSELB &= ~(1 << PIN_PULSADOR);
ANSELC &= ~(1 << PIN_LED);

LATA = 0; // En el arranque dejamos todas las salidas a 0
LATB = 0;
LATC |= (1 << PIN_LED); // Excepto el LED, que es activo a 0

// Pin del pulsador como entrada y el resto como salidas
TRISA = 0;
TRISB |= (1 << PIN_PULSADOR);
TRISC = 0;

SYSKEY = 0xAA996655; // Se desbloquean los registros
SYSKEY = 0x556699AA; // de configuración.
T3CKR = 1; // T3CK conectado al PB5.
SYSKEY = 0x1CA11CA1; // Se vuelven a bloquear.

T3CON = 0; // Se para el temporizador 3
TMR3 = 0; // Cuenta a 0
IFS0bits.T3IF = 0; // Se borra el bit de fin de cuenta
PR3 = 6; // Periodo de 7 ciclos (el 0 cuenta)
T3CON = 0x8002; // Timer 3 on, div. a 1 y reloj externo

while(1) {
    while(IFS0bits.T3IF == 0)
        ; // Espera el fin del temporizador

    IFS0bits.T3IF = 0;
    LATC ^= (1 << PIN_LED); // Se invierte el LED
}

/********************* TICKS TIMER 3 **********************/
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

/*************************** TICKS TIMER 2 ********************/
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

/***************************** EXAMEN LAB 2019 ***********************/
#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "Temporizador.h"

static int LED = 0; // Led que tiene que parpadear

void SetupTimer2(void) {
	// Configurar timer
	T2CON = 0x0000; // Apagar timer
	PR2 = 39062; // Configurar Timer2 para que cuente hasta 500ms
	TMR2 = 0x0000; // Reiniciar la cuenta interna
    
	// Configurar interrupciones
	IPC2bits.T2IP = 2; // Prioridad de la interrupción
	IPC2bits.T2IS = 0; // SubPrioridad de la interrupción
	IFS0bits.T2IF = 0; // Bajar el flag
	IEC0bits.T2IE = 1; // Se permite la interrupción

	// Encender timer
	T2CON = 0x8000 | (0x6<<4); // Encender el timer con preescalado 6 (64)
}

void __attribute__((vector(_TIMER_2_VECTOR), interrupt(IPL2SOFT), nomips16)) 
	InterruptionTimer2(void) {
	IFS0bits.T2IF = 0; // Resetear flag
    
    // Cada 500 ms, invertir LED
    LATCINV = 1 << LED;
}

void setLED(unsigned int led) {
    asm("di");
    LED = led;
    asm("ei");
    
    // Apagar los LEDs que no están siendo utilizados
    for (int i = 0; i < 4; i++) {
        if (i != led) {
            LATCSET = 1 << i;
        }
    }
}

#include<xc.h>
#include"Pic32Ini.h"
#include"encenderLED.h"
#include"apagarLED.h"

#define BUTTON 5

int main(void) {
    
    ANSELC &= ~0xF;
    ANSELB &= (1<<BUTTON);
    
    TRISC &= ~0xF; // 0utput
    TRISB |= (1<<BUTTON); // 1nput
    
    LATC |= 0xF; // Apagar todos los LED
    
    int button_act, button_prev;
    button_prev = (PORTB >> BUTTON) & 1;
    
    // Configurar TIMER
    SetupTimer2();
    
    // Activar interrupciones
    INTCONbits.MVEC = 1;
    asm("ei");
    
    // Empezar con LED0
    int contador = 0;
    setLED(contador);
    
    while (1) {
        button_act = (PORTB >> BUTTON) & 1;
        
        // Flanco de bajada, activo a nivel bajo
        if ((button_act != button_prev) && (button_act == 0))  {
            // Overflow
            contador++;
            if (contador == 4) {
                contador = 0;
            }
            
            // Lógica
            // APARTADO 4
            setLED(contador);
            
            // APARTADO 3
            /*
            for (int i = 0; i < 4; i++) {
                if (i == contador) {
                    encenderLED(contador);
                } else {
                    apagarLED(contador);
                }
            }
             * */
        }
        
        // Actualizar valores
        button_prev = button_act;
    }
   
    return 0;
}