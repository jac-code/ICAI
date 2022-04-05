#include <xc.h>
#include <stdint.h>
#include "ModuloSensorPresion.h"
#include "Pic32Ini.h"
#include "Retardo.h"

#define PIN_SENSOR_PRESION 2 // RB2

int getMedidaPresion(void){
    
    int valor = 0;
    // Pines de los LEDs como digitales
    ANSELC &= ~0xF;

    LATA = 0; // En el arranque dejamos todas las salidas a 0
    LATB = 0;
    LATC = 0xF; // Apago los LEDs de la placa

    TRISA = 0;
    TRISB = (1 << PIN_SENSOR_PRESION);
    TRISC = 0;

    LATC &= ~(1 << 2);
    AD1CON1 = 0; // Apago el ADC por si acaso
    AD1CON2 = 0;
    AD1CON3 = 0; // Conversión con TADC = 2TPBCLK (a tope)
    AD1CHS = 0x00040000; // CH0SA = AN5, CH0NA = GND
    AD1CON1bits.ON = 1; // Arranco el ADC
    AD1CON1bits.SAMP = 1;
    //int k = Retardo(10);
    LATC &= ~(1 << 1);
    AD1CON1bits.SAMP = 0;
    while(AD1CON1bits.DONE==0); // Espera fin de conversión
    valor = ADC1BUF0;
    LATC &= ~(1 << 3);
    //El valor está en ADC1BUF0
    if(valor >= 100){
        return 1;
        
        //LATC = ~0X000F;
    }
    return 0;
}