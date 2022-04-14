#include <xc.h>
#include <stdint.h>
#include "ModuloSensorPresion.h"
#include "Pic32Ini.h"
#include "Retardo.h"

#define PIN_SENSOR_PRESION 0 // RA0

void InicializarSensorPresion() {
    TRISA = (1 << PIN_SENSOR_PRESION);
    
    AD1CON1 = 0; // Apago el ADC por si acaso
    //AD1CON2 = 0;
    //AD1CON3 = 0; // Conversión con TADC = 2TPBCLK (a tope)
    AD1CHS = 0x00000000; // CH0SA = AN0, CH0NA = GND
    AD1CON1bits.ASAM = 1;
    AD1CON1bits.ON = 1; // Arranco el ADC
    
    AD1CON1bits.SAMP = 1;   // modo automatico
    Retardo(1);
}

int getMedidaPresion(void){
    int valor;
    
    AD1CON1bits.SAMP = 0;
    while(AD1CON1bits.DONE==0)
        ; // Espera fin de conversión
    valor = ADC1BUF0;
    //El valor está en ADC1BUF0
    if(valor >= 600){
        return 1;
    }
    return 0;
    
    /*AD1CON1bits.SAMP = 0;
    while(AD1CON1bits.DONE == 0)
        ;
    valor = ADC1BUF0;

    if(valor >= 600) {
        LATC ^= (1 << 0);
    }*/
}