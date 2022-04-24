#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloUART.h"

int main(void) {
  char c;
  int configuracion = 1;
  
  // Pines como salidas
  TRISA = 0;
  TRISB = 0;
  TRISC = 0;
  
  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0;
  LATC = 0xF; // Apago los LEDs de la placa
  
  InicializarUART1();
  EnviarMensajeBienvenida();
  EnviarSalto();
  
  ConfiguracionGaraje();
  EnviarSalto();
  
  while(configuracion == 1) {
    c = RecibirComando();
  
    if(c == 'A') {
        LATC &= ~(1 << 0);
        EnviarMensajeBienvenida();
        EnviarSalto();
        configuracion = 0;
    } else if (c == 'M') {
        LATC &= ~(1 << 1);
    } else if (c == 'S') {
        LATC &= ~(1 << 2);
    } else if (c == 'N') {
        LATC &= ~(1 << 3);
    }
  }
  
  ConfiguracionGaraje();
  EnviarSalto();
  
}