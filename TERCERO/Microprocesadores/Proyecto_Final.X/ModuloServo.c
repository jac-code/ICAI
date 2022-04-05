#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"

void InicializarServoSalida() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPA9R = 5; // OC2 conectado a RC8
    SYSKEY=0x1CA11CA1;
    
    OC2CON = 0;
    OC2R = 2500;     // Tiempo en alto de 1 ms inicial
    OC2RS = 2500;
    OC2CON = 0x8006; // OC ON, modo PWM sin faltas
}
  
void InicializarServoEntrada() {
    SYSKEY=0xAA996655;
    SYSKEY=0x556699AA;
    RPB15R = 5; // OC1 conectado a RB15
    SYSKEY=0x1CA11CA1;
    
    OC1CON = 0;
    OC1R = 2500;     // Tiempo en alto de 1 ms inicial
    OC1RS = 2500;
    OC1CON = 0x8006; // OC ON, modo PWM sin faltas
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