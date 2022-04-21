#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PIN_PULSADOR 9

int main(void)
{
  int pulsador_ant, pulsador_act;
  
  // Pines como salidas
  TRISA |= (1 << PIN_PULSADOR);
  TRISB = 0;
  TRISC = 0;
  
  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0;
  LATC = 0xF; // Apago los LEDs de la placa
  
  pulsador_ant = (PORTA >> PIN_PULSADOR) & 1;
  while(1){
      pulsador_act = (PORTA >> PIN_PULSADOR) & 1;
      if(((PORTA >> PIN_PULSADOR) & 0x1) == 0) {   // hay algo cerca
          LATC &= ~(1 << 0);
      } else {
          // no hay nada encima
          LATC |= (1 << 0);
      }
  }
}


