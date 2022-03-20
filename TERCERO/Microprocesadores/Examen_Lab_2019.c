/********************* ENSAMBLADOR APAGAR LED ************************/
#include <xc.h> 
.text
.global Apagar
.ent Apagar
Apagar:
    sltu t0, a0, zero   # si pin_led < 0 --> t0 = 1
    bne t0, zero, Fin

    slti t0, a0, 4  # si pin_led < 4 --> t0 = 1
    beq t0, zero, Fin

    SLL T0, A0, 2   # T0 = 4*led
    LUI V0, -16504
    LW V0, 25136(V0)
    OR T1, T0, V0
    LUI V0, -16504
    SW T1, 25136(V0)

    #######################

    la t0, LATC

	// Para apagarlo LATC &= ~(1 << a0)

	lw t1, 0(t0) // Cargar valor de t0
	ori t2, zero, 1 // 1
	sllv t2, t2, a0 // (1 << a0)
	nor t2, t2, zero // ~(1 << a0)
	and t2, t1, t2 // LATC & ~(1 << a0)
	sw t2, 0(t0) // LATC = LATC &Â ~(1<<a0)

Fin:
    jr ra
    .end Apagar
    

/********************* ENSAMBLADOR ENCENDER LED ************************/
#include <xc.h> 
.text
.global Encender
.ent Encender
Encender:
    sltu t0, a0, zero   # si pin_led < 0 --> t0 = 1
    bne t0, zero, Fin

    SLL T0, A0, 2   # T0 = 4*led
    LUI V0, -16504
    LW V0, 25136(V0)
    AND T1, T0, V0
    LUI V0, -16504
    SW T1, 25136(V0)

    #######################

    la t0, LATC
	// Para encenderlo LATC |= 1 << a0
	lw t1, 0(t0) // Cargar valor de t0
	ori t2, zero, 1 // 1
	sllv t2, t2, a0 // 1 << a0
	or t2, t1, t2 // LATC | (1 << a0)
	sw t2, 0(t0) // LATC = LATC |Â (1<<a0)
Fin:
    jr ra
    .end Encender

/********************* APAGAR LED ************************/
void apagar_led(int led) {
    if(led >= 0) {
        LATC |= (1 << led);
        LATCSET = (1 << led);
    }
}
/********************* ENCENDER LED ************************/
void encender_led(int led) {
    if(led >= 0) {
        LATC &= ~(1 << led);
        LATCCLR = (1 << led);
    }
}

/********************** DESPLAZAR LED CON PULSADOR *********************/
#include <xc.h>
#include "PicIni.h"
#include <stdint.h>

#define PIN_PULSADOR 5
#define PIN_LED0 0
#define PIN_LED1 1
#define PIN_LED2 2
#define PIN_LED3 3

#define NUM_LEDS 4

void apagarLED(int led);
void encenderLED(int led);

int main(int argc, char const *argv[])
{
    int puls_act, puls_ant, cont;
    int puerto = 0x0000;
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED1);
    puerto |= (1 << PIN_LED2);
    puerto |= (1 << PIN_LED3);

    TRISB |= (1 << PIN_PULSADOR);   // ENTRADA
    TRISC = ~puerto;
    
    for (int i = 0; i < NUM_LEDS; i++){
        apagarLED(i);
    }

    encenderLED(0);

    cont = 0;

    puls_ant = (PORTB >> PIN_PULSADOR) & 1;
    while (1) {
        puls_act = (PORTB >> PIN_PULSADOR) & 1;
        if ((puls_act != puls_ant) && (puls_act == 0)) {
            cont ++;
            switch (cont)
            {
            case 1:
                apagarLED(0)
                apagarLED(3)
                apagarLED(2)
                encenderLED(1)
                break;
            case 2:
                apagarLED(0)
                apagarLED(1)
                apagarLED(3)
                encenderLED(2)
                break;
            case 3:
                apagarLED(0)
                apagarLED(1)
                apagarLED(2)
                encenderLED(3)
                break;
            case 4: // vuelve a la inicial
                apagarLED(3)
                apagarLED(1)
                apagarLED(2)
                encenderLED(1)
                cont = 0;
                break;
            
            default:
                break;
            }
            
        }
        puls_ant = puls_act;
    }
    
    return 0;
}


/********************** DESPLAZAR LED CON PULSADOR + PARPADEO *********************/
#include <xc.h>
#include "PicIni.h"

#define PIN_PULSADOR 5
#define PIN_LED0 0
#define PIN_LED1 1
#define PIN_LED2 2
#define PIN_LED3 3

#define NUM_LEDS 4

#define T_PARPADEO 500  // en ms --> 0.5 seg encendido
#define PR2 2499
#define PRIORIDAD_TIMER2 2
#define SUBPRIORIDAD_TIMER2 1
#define PRESCALER 0

void apagarLED(int led);
void encenderLED(int led);
void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler);

int main(int argc, char const *argv[])
{
    int puls_act, puls_ant, cont;
    uint16_t ticks_ant, ticks_act;

    int puerto = 0x0000;
    puerto |= (1 << PIN_LED0);
    puerto |= (1 << PIN_LED1);
    puerto |= (1 << PIN_LED2);
    puerto |= (1 << PIN_LED3);

    TRISB |= (1 << PIN_PULSADOR);   // ENTRADA
    TRISC = ~puerto;
    
    for (int i = 0; i < NUM_LEDS; i++){
        apagarLED(i);
    }

    encenderLED(0);

    cont = 0;

    // llamamos a la función para inicializar Timer2
    InicializarTimer2(PR2, PRIORIDAD_TIMER2, SUBPRIORIDAD_TIMER2, PRESCALER);
    
    // activamos las interrupciones
    INTCONbits.MVEC = 1;
    asm(" ei");

    ticks_ant = TicksDesdeArr();

    puls_ant = (PORTB >> PIN_PULSADOR) & 1;

    while (1) {
        ticks_act = TicksDesdeArr();
        if((ticks_act - ticks_ant) > T_PARPADEO) {  // con la resta medimos el tiempo transcurrido
            if ((cont == 0) || (cont == 4)) {
                ticks_ant = ticks_act;
                LATCINV = (1 << 0); // invertimos el valor de LED
            } else if (cont == 1) {
                ticks_ant = ticks_act;
                LATCINV = (1 << 1); // invertimos el valor de LED
            } else if (cont == 2) {
                ticks_ant = ticks_act;
                LATCINV = (1 << 2); // invertimos el valor de LED
            } else if (cont == 3) {
                ticks_ant = ticks_act;
                LATCINV = (1 << 3); // invertimos el valor de LED
            }
        }

        puls_act = (PORTB >> PIN_PULSADOR) & 1;
        if ((puls_act != puls_ant) && (puls_act == 0)) {
            cont ++;
            switch (cont) {
            case 1:
                apagarLED(0)
                apagarLED(3)
                apagarLED(2)
                encenderLED(1)
                break;
            case 2:
                apagarLED(0)
                apagarLED(1)
                apagarLED(3)
                encenderLED(2)
                break;
            case 3:
                apagarLED(0)
                apagarLED(1)
                apagarLED(2)
                encenderLED(3)
                break;
            case 4: // vuelve a la inicial
                apagarLED(3)
                apagarLED(1)
                apagarLED(2)
                encenderLED(1)
                cont = 0;
                break;
            
            default:
                break;
            }
        }
        puls_ant = puls_act;
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