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
#include "ModuloServo.h"

#define PIN_PULSADOR  5

int main(void)
{
  int pulsador_ant, pulsador_act;
  int temp = 0;
  
  // Pines de los LEDs como digitales
  ANSELC &= ~0xF;
  
  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0; 
  LATC = 0xF; // Apago los LEDs de la placa
  
  // Pines como salidas
  TRISA = 0;
  TRISB = (1 << PIN_PULSADOR);
  TRISC = 0;
 
  //InicializarServoSalida();
  InicializarServos();
  
  pulsador_ant = (PORTB>>PIN_PULSADOR) & 1;
  while(1){
    // Se lee el estado del pulsador
    pulsador_act = (PORTB>>PIN_PULSADOR) & 1;
    if( (pulsador_act != pulsador_ant) && (pulsador_act == 0) ){
        if(temp == 0) {
            subir_barrera_salida();
            subir_barrera_entrada();
            temp = 1;
        } else {
            bajar_barrera_salida();
            bajar_barrera_entrada();
            temp = 0;
        }
    }
    pulsador_ant = pulsador_act;
  }
}

