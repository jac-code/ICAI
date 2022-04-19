#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"
#include "ModuloUART.h"
#include "ModuloSensorPresion.h"
//#include "Retardo.h"

#define PIN_PULSADOR  5
#define NUM_MAX_PLAZAS 20
#define NUM_INICIO_PLAZAS 5

#define LIM_25 5
#define LIM_50 10
#define LIM_75 15
#define LIM_100 20

#define LED0 0
#define LED1 1
#define LED2 2
#define LED3 3

#define MASCARA_0 0xFF
#define MASCARA_25 0x000E // 0000 0000 0000 1110
#define MASCARA_50 0x000C // 0000 0000 0000 1100
#define MASCARA_75 0x0008 // 0000 0000 0000 1000
#define MASCARA_100 0x0000 // 0000 0000 0000 0000

void ConfiguracionLEDS(int contador_plazas);

int main(void) {
    int bool_completo = 0;
    int bool_vacio = 0;
    
    int temp_pulsador = 0;
    int pulsador_ant, pulsador_act;
    int presion_act, presion_ant;
    int contador_plazas = NUM_INICIO_PLAZAS;
    
    uint16_t retardo_puerta = 2000;

    ANSELC &= ~0xF;

    LATA = 0; // En el arranque dejamos todas las salidas a 0
    LATB = 0;
    LATC = 0xFF; // Apago los LEDs de la placa

    TRISA = 0;
    TRISB |= (1 << PIN_PULSADOR);
    TRISC = 0;

    InicializarSensorPresion();
    InicializarServos();
    InicializarUART1();
    
    ConfiguracionLEDS(contador_plazas);
    EnviarMensajeBienvenida();
    EnviarSalto();
    EnviarMensajeInfoPlazas(contador_plazas, NUM_MAX_PLAZAS);
    EnviarSalto();
    
    pulsador_ant = (PORTB >> PIN_PULSADOR) & 1;
    presion_ant = getMedidaPresion();
    
    while (1) {
        if ((contador_plazas < NUM_MAX_PLAZAS) && (contador_plazas > 0)) {    // INTERMEDIO
            bool_vacio = 0;
            bool_completo = 0;
            
            // SALIDA
            pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
            presion_act = getMedidaPresion();

            if ((pulsador_act != pulsador_ant) && (pulsador_act == 0)) {
                // Flanco de bajada en la patilla del pulsador
                if (temp_pulsador == 0) {
                    subir_barrera_salida();
                    temp_pulsador = 1;
                } else {
                    bajar_barrera_salida();
                    temp_pulsador = 0;
                }
                contador_plazas--;
                EnviarMensajeInfoPlazas(contador_plazas, NUM_MAX_PLAZAS);
                ConfiguracionLEDS(contador_plazas);
            }
            pulsador_ant = pulsador_act;
            
            // ENTRADA
            presion_act = getMedidaPresion();
            if ((presion_act != presion_ant) && (getMedidaPresion() == 1)) {
                subir_barrera_entrada();
                while (getMedidaPresion() == 1)
                    ;
                
                
                presion_ant = presion_act;
                contador_plazas++;
                EnviarMensajeInfoPlazas(contador_plazas, NUM_MAX_PLAZAS);
                ConfiguracionLEDS(contador_plazas);
            } else {
                //int k = Retardo(retardo_puerta);
                bajar_barrera_entrada();
            }
        }
        else if(contador_plazas == 0) {   // PARKING VACIO --> solo entrar
            if(bool_vacio == 0) {    // que solo mande mensaje una vez
                EnviarMensajeParkingVacio();
                ConfiguracionLEDS(contador_plazas);
                bool_vacio = 1;
            }
            
            presion_act = getMedidaPresion();
            if ((presion_act != presion_ant) && (getMedidaPresion() == 1)) {
                subir_barrera_entrada();
                while (getMedidaPresion() == 1)
                    ;

                presion_ant = presion_act;
                contador_plazas++;
                EnviarMensajeInfoPlazas(contador_plazas, NUM_MAX_PLAZAS);
                ConfiguracionLEDS(contador_plazas);
            } else {
                bajar_barrera_entrada();
            }
        }
        else if(contador_plazas == NUM_MAX_PLAZAS) {   // PARKING LLENO --> solo salir
            if(bool_completo == 0) {    // que solo mande mensaje una vez
                EnviarMensajeParkingCompleto();
                ConfiguracionLEDS(contador_plazas);
                bool_completo = 1;
            }
            
            pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
            presion_act = getMedidaPresion();

            if ((pulsador_act != pulsador_ant) && (pulsador_act == 0)) {
                // Flanco de bajada en la patilla del pulsador
                if (temp_pulsador == 0) {
                    subir_barrera_salida();
                    temp_pulsador = 1;
                } else {
                    bajar_barrera_salida();
                    temp_pulsador = 0;
                }
                contador_plazas--;
                EnviarMensajeInfoPlazas(contador_plazas, NUM_MAX_PLAZAS);
                ConfiguracionLEDS(contador_plazas);
            }
            pulsador_ant = pulsador_act;
        }
    }
}

void ConfiguracionLEDS(int contador_plazas) {
    if(contador_plazas <= LIM_25) {
        LATC = MASCARA_25;
    } else if((contador_plazas <= LIM_50) && (contador_plazas >  LIM_25)) {
        LATC = MASCARA_50;
    } else if((contador_plazas <= (NUM_MAX_PLAZAS-1)) && (contador_plazas >  LIM_50)) {
        LATC = MASCARA_75;
    } else if(contador_plazas ==  NUM_MAX_PLAZAS) {
        LATC = MASCARA_100;
    } else if(contador_plazas == 0) {
        LATC = MASCARA_0;
    }
}