/**
 * Programa de prueba del PWM. Controla un servo usando la unidad output compare
 * del pic32. Para ello configura el OC1 para usar el timer 2 en mod 16 bits
 * y el timer 2 se usa con un predivisor de 2, para poder conseguir un
 * periodo de 20 ms.
 * El valor inicial del tiempo en alto se deja a 1 ms y cada vez que se pulse
 * el pulsador de la placa se incrementa la cuenta en 40 us. Cuando se superen
 * los 2 ms como tiempo en alto, se vuelve al principio.
 */

#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"

#define PIN_PULSADOR  5

int main(void)
{
  int pulsador_ant, pulsador_act;
  int t_alto; // Tiempo en alto de la salida
  
  // Pines de los LEDs como digitales
  ANSELC &= ~0xF;
  
  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0;
  LATC = 0xF; // Apago los LEDs de la placa
  
  // Pines como salidas
  TRISA = 0;
  TRISB = (1 << PIN_PULSADOR);
  TRISC = 0;
 
  SYSKEY=0xAA996655;
  SYSKEY=0x556699AA;
  RPB15R = 5; // OC1 conectado a RB15
  SYSKEY=0x1CA11CA1;
  
  OC1CON = 0;
  OC1R = 2500;     // Tiempo en alto de 1 ms inicial
  OC1RS = 2500;
  OC1CON = 0x8006; // OC ON, modo PWM sin faltas
  
  T2CON = 0;
  TMR2 = 0;
  PR2 = 50000;     // Periodo de 10 ms
  T2CON = 0x8010; // T3 ON, Div = 2
  
  pulsador_ant = (PORTB >> PIN_PULSADOR) & 1;
  while(1){
    // Se lee el estado del pulsador
    pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
    if( (pulsador_act != pulsador_ant) && (pulsador_act == 0) ){
      // Flanco de bajada en la patilla del pulsador
      LATC ^= (1 << 0);
      t_alto += 100;
      if(t_alto > 5000){
        t_alto = 2500;
      }
      OC1RS = t_alto;
    }
    pulsador_ant = pulsador_act;
  }
}