#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"

void InicializarServos() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPB15R = 5; // OC1 conectado a RB15
    //RPC8R = 5; // OC2 conectado a RC8
    RPC4R = 5; // OC3 conectado a RC4
    // RPA9R = 5;
    SYSKEY=0x1CA11CA1;
    
    OC1CON = 0;
    OC1R = 2500; // Tiempo en alto de 1 ms inicial
    OC1RS = 2500;
    OC1CON = 0x800E; // OC ON, modo PWM sin faltas, utilizamos timer 3
    
    OC3CON = 0;
    OC3R = 2500;     // Tiempo en alto de 1 ms inicial
    OC3RS = 2500;
    OC3CON = 0x800E; // OC ON, modo PWM sin faltas
    // OC2CON = 0x8006;    // TIMER 2
    
    T3CON = 0;
    TMR3 = 0;
    PR3 = 49999; // Periodo de 20 ms
    T3CON = 0x8010; // T3 ON, Div = 2
}

void bajar_barrera_entrada() {
    OC1RS = 2500;
}

void subir_barrera_entrada() {
    OC1RS = 5000;
}

void bajar_barrera_salida() {
    OC3RS = 2500;
}

void subir_barrera_salida() {
    OC3RS = 5000;
}