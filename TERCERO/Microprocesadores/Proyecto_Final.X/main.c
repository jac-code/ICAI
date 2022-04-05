#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"
#include "ModuloSensorPresion.h"
#include "Retardo.h"

#define PIN_PULSADOR  5
#define PIN_PRESION 3   // RB3

int main(void)
{
  int pulsador_ant, pulsador_act;
  int presion_act, presion_ant;
  int temporal = 0;
  
  int valor = 0;
    // Pines de los LEDs como digitales
    ANSELC &= ~0xF;

    LATA = 0; // En el arranque dejamos todas las salidas a 0
    LATB = 0;
    LATC = 0xF; // Apago los LEDs de la placa

    TRISA = 0;
    TRISB = (1 << PIN_PRESION);
    TRISC = 0;
    
    AD1CON1 = 0; // Apago el ADC por si acaso
    AD1CON2 = 0;
    AD1CON3 = 0; // Conversión con TADC = 2TPBCLK (a tope)
    AD1CHS = 0x00050000; // CH0SA = AN5, CH0NA = GND
    AD1CON1bits.ASAM = 1;
    AD1CON1bits.ON = 1; // Arranco el ADC
    
    AD1CON1bits.SAMP = 1;   // modo automatico
    int k = Retardo(1);
    
    while(1) {
        AD1CON1bits.SAMP = 0;
        while(AD1CON1bits.DONE == 0)
            ;
        valor = ADC1BUF0;
        
        if(valor >= 600) {
            LATC ^= (1 << 0);
        }
        
        Retardo(1);
    }
    
}

/*
 // Se lee el estado del pulsador
    pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
    if( (pulsador_act != pulsador_ant) && (pulsador_act == 0) ){
      // Flanco de bajada en la patilla del pulsador
      LATC ^= (1 << 0);
      if(temporal == 0) {
          //subir_barrera_salida();
          subir_barrera_entrada();
          temporal = 1;
      } else {
          //bajar_barrera_salida();
          bajar_barrera_entrada();
          temporal = 0;
      }
    }
    pulsador_ant = pulsador_act;
 */