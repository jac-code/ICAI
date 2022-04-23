#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PIN_SENSOR 9

int main(void)
{ 
  int salida;
  // Pines como salidas
  TRISA |= (1 << PIN_SENSOR);
  TRISB = 0;
  TRISC = 0;
  
  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0;
  LATC = 0xF; // Apago los LEDs de la placa
  
  while(1){
      salida = (PORTA >> PIN_SENSOR) & 1;
      if(salida == 0) {   // hay algo cerca
          LATC &= ~(1 << 0);
      } else {
          // no hay nada encima
          LATC |= (1 << 0);
      }
  }
}