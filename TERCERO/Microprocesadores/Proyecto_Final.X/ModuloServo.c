#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"

void InicializarServoSalida() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPC8R = 5; // OC2 conectado a RC8
    SYSKEY=0x1CA11CA1;
    /*
    OC2CON = 0;
    OC2R = 2500;     // Tiempo en alto de 1 ms inicial
    OC2RS = 2500;
    OC2CON = 0x8006; // OC ON, modo PWM sin faltas
    
    T2CON = 0;
    TMR2 = 0;
    PR2 = 50000; // Periodo de 20 ms
    T2CON = 0x8010; // T2 ON, Div = 2
    */
    OC2CON = 0;
    OC2R = 2500; // Tiempo en alto de 1 ms inicial
    OC2RS = 2500;
    OC2CON = 0x800E; // OC ON, modo PWM sin faltas, utilizamos timer 3
    
    T3CON = 0;
    TMR3 = 0;
    PR3 = 49999; // Periodo de 20 ms
    T3CON = 0x8010; // T3 ON, Div = 2
}

void InicializarServoEntrada() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPB15R = 5; // OC1 conectado a RB15
    SYSKEY=0x1CA11CA1;

    OC1CON = 0;
    OC1R = 2500; // Tiempo en alto de 1 ms inicial
    OC1RS = 2500;
    OC1CON = 0x800E; // OC ON, modo PWM sin faltas, utilizamos timer 3
    
    T3CON = 0;
    TMR3 = 0;
    PR3 = 49999; // Periodo de 20 ms
    T3CON = 0x8010; // T3 ON, Div = 2
}
  
void InicializarServos() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPB15R = 5; // OC1 conectado a RB15
    RPC8R = 5; // OC2 conectado a RC8
    SYSKEY=0x1CA11CA1;
    
    OC1CON = 0;
    OC1R = 2500; // Tiempo en alto de 1 ms inicial
    OC1RS = 2500;
    OC1CON = 0x800E; // OC ON, modo PWM sin faltas, utilizamos timer 3
    
    OC2CON = 0;
    OC2R = 2500;     // Tiempo en alto de 1 ms inicial
    OC2RS = 2500;
    OC2CON = 0x800E; // OC ON, modo PWM sin faltas
    
    T3CON = 0;
    TMR3 = 0;
    PR3 = 49999; // Periodo de 20 ms
    T3CON = 0x8010; // T3 ON, Div = 2
}

void InicializarTimer2(int tiempo, int valor_prescaler) {
    T2CON = 0;
    TMR2 = 0;
    PR2 = tiempo;
    
    T2CON = 0x8000; // Timer2 --> ON = 1 + reloj interno seleccionado
    T2CON |= (valor_prescaler << 4);   // añadimos el prescaler correspondiente
}

void bajar_barrera_entrada() {
    OC1RS = 2500;
}

void subir_barrera_entrada() {
    OC1RS = 5000;
}

void bajar_barrera_salida() {
    OC2RS = 2500;
}

void subir_barrera_salida() {
    OC2RS = 5000;
}