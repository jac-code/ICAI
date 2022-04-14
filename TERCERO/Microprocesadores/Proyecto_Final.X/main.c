#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"
#include "ModuloSensorPresion.h"
#include "Retardo.h"

#define PIN_PULSADOR  5

int main(void)
{
  int pulsador_ant, pulsador_act;
  int presion_act, presion_ant;
  
  ANSELC &= ~0xF;

  LATA = 0; // En el arranque dejamos todas las salidas a 0
  LATB = 0;
  LATC = 0xF; // Apago los LEDs de la placa
  
  TRISA = 0;
  TRISB |= (1 << PIN_PULSADOR);
  TRISC = 0;
    
  InicializarSensorPresion();
  InicializarServos();
  
  int temp_pulsador = 0;
  int temp_presion = 0;
  
  pulsador_ant = (PORTB >> PIN_PULSADOR) & 1; 
  presion_ant = getMedidaPresion();
  
  while(1){
    // Se lee el estado del pulsador
    pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
    presion_act = getMedidaPresion();
    
    if((pulsador_act != pulsador_ant) && (pulsador_act == 0) ){
        // Flanco de bajada en la patilla del pulsador
        if(temp_pulsador == 0) {
            subir_barrera_salida();
            temp_pulsador = 1;
        } else {
            bajar_barrera_salida();
            temp_pulsador = 0;
        }
    }
    pulsador_ant = pulsador_act;
    /*
    if((presion_act != presion_ant) && (presion_act == 1)) {
        if(temp_presion == 0) {
            subir_barrera_entrada();
            while(getMedidaPresion() == 1)
                ;
            temp_presion = 1;
        } else {
            bajar_barrera_entrada();
            temp_presion = 0;
        }
    }
    
    presion_ant = presion_act;*/
    
    presion_act = getMedidaPresion();
    if((presion_act != presion_ant) && (getMedidaPresion() == 1)) {
        subir_barrera_entrada();
        while(getMedidaPresion() == 1)
            ;
        Retardo(2000);
        presion_ant = presion_act;
    }
    else {
        bajar_barrera_entrada();
    }
  }
}