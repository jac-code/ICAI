#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"
#include "ModuloUART.h"
#include "ModuloSensorPresion.h"
#include "Retardo.h"

#define PIN_PULSADOR  5
#define PIN_SENSOR 9

#define NUM_MAX_PLAZAS 5
#define NUM_INICIO_PLAZAS 2

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
    int bool_configuracion = 1;
    int bool_mensaje_automatico = 0;
    int bool_mensaje_manual = 0;
    
    int configuracion;  // guardamos la configuracion seleccionada
    char c; // caracter recibido por el terminal
    
    int presion_act, presion_ant;
    int salida;
    
    int contador_coches = NUM_INICIO_PLAZAS; // numero de plazas OCUPADAS

    ANSELC &= ~0xF;

    LATA = 0; // En el arranque dejamos todas las salidas a 0
    LATB = 0;
    LATC = 0xFF; // Apago los LEDs de la placa

    TRISA = 0;
    TRISA |= (1 << PIN_SENSOR);
    TRISB = 0;
    TRISC = 0;

    InicializarSensorPresion();
    InicializarServos();
    InicializarUART1();
    
    ConfiguracionLEDS(contador_coches);
    
    EnviarMensajeBienvenida();
    EnviarSalto();
    ConfiguracionGaraje();
    EnviarSalto();
    
    while(bool_configuracion == 1) {
        c = RecibirComando();
  
        if(c == 'A') {
            // MODO AUTOMATICO SELECCIONADO
            configuracion = 0;
            EnviarMensajeModoAutomaticoSeleccionado();
            bool_configuracion = 0;
        } else if (c == 'M') {
            // MODO MANUAL SELECCIONADO;
            configuracion = 1;
            EnviarMensajeModoManualSeleccionado();
            bool_configuracion = 0;
        }
    }
    
    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
    EnviarSalto();
    
    presion_ant = getMedidaPresion();
    
    while(1) {
        if(configuracion == 0) {    // MODO AUTOMATICO
            if(contador_coches == 0) {  // PARKING VACIO --> solo pueden entrar coches
                // ENVIAR MENSAJE SOLO UNA VEZ
                if(bool_vacio == 0) {    // que solo mande mensaje una vez
                    EnviarMensajeParkingVacio();
                    ConfiguracionLEDS(contador_coches);
                    bajar_barrera_salida();
                    bool_vacio = 1;
                }

                // LÓGICA ENTRADA
                presion_act = getMedidaPresion();
                if((presion_ant != presion_act) && (presion_act == 1)){
                    subir_barrera_entrada();

                    //while(getMedidaPresion() == 1); // mientras este con presion la puerta está abierta
                    contador_coches++;  // entra un coche, plazas ocupadas++
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);

                    int k = Retardo(3000);
                } else {
                    bajar_barrera_entrada();
                }
                presion_ant = presion_act;
            } else if(contador_coches == NUM_MAX_PLAZAS) {  // PARKING LLENO --> solo pueden salir coches
                // ENVIAR MENSAJE SOLO UNA VEZ
                if(bool_completo == 0) {    // que solo mande mensaje una vez
                    EnviarMensajeParkingCompleto();
                    ConfiguracionLEDS(contador_coches);
                    bajar_barrera_entrada();
                    bool_completo = 1;
                }

                // LÓGICA SALIDA
                salida = (PORTA >> PIN_SENSOR) & 1;
                if(salida == 0){
                    subir_barrera_salida();

                    contador_coches--;  // entra un coche, plazas ocupadas++
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);

                    int k = Retardo(3000);
                } else {
                    bajar_barrera_salida();
                }
            } else if((contador_coches < NUM_MAX_PLAZAS) && (contador_coches > 0)) {
                bool_vacio = 0;
                bool_completo = 0;

                // LÓGICA ENTRADA
                presion_act = getMedidaPresion();
                if((presion_ant != presion_act) && (presion_act == 1)){
                    subir_barrera_entrada();

                    //while(getMedidaPresion() == 1); // mientras este con presion la puerta está abierta
                    contador_coches++;  // entra un coche, plazas ocupadas++
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);

                    int k = Retardo(3000);
                } else {
                    bajar_barrera_entrada();
                }
                presion_ant = presion_act;

                // LÓGICA SALIDA
                salida = (PORTA >> PIN_SENSOR) & 1;
                if(salida == 0){
                    subir_barrera_salida();

                    contador_coches--;  // entra un coche, plazas ocupadas++
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);

                    int k = Retardo(3000);
                } else {
                    bajar_barrera_salida();
                }
            }
        } else {    // MODO MANUAL SELECCIONADO
            bool_configuracion = 1; // para futuras lecturas
            bool_mensaje_automatico = 0;
            bool_mensaje_manual = 0;
            
            if(contador_coches == 0) {  // PARKING VACIO --> solo pueden entrar coches
                // ENVIAR MENSAJE SOLO UNA VEZ
                if(bool_vacio == 0) {    // que solo mande mensaje una vez
                    EnviarMensajeParkingVacio();
                    ConfiguracionLEDS(contador_coches);
                    bajar_barrera_salida();
                    bool_vacio = 1;
                }

                // LÓGICA ENTRADA
                presion_act = getMedidaPresion();
                if((presion_ant != presion_act) && (presion_act == 1)){
                    if(bool_mensaje_automatico == 0) {
                        EnviarMensajeCocheEntrada();
                        bool_mensaje_automatico = 1;
                    }
                    
                    while(bool_configuracion == 1) {
                        c = RecibirComando();
                    
                        if(c == 'S') {
                            subir_barrera_entrada();
                            EnviarMensajeAbrirBarrera();
                            contador_coches++;  // entra un coche, plazas ocupadas++
                            EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                            ConfiguracionLEDS(contador_coches);

                            int k = Retardo(3000);
                            bool_configuracion = 0;
                        } else if(c == 'N') {
                            bajar_barrera_entrada();
                            EnviarMensajeDenegarAcceso();
                            bool_configuracion = 0;
                        }
                    }
                } else {
                    bajar_barrera_entrada();
                }
                presion_ant = presion_act;
            } else if(contador_coches == NUM_MAX_PLAZAS) {  // PARKING LLENO --> solo pueden salir coches
                // ENVIAR MENSAJE SOLO UNA VEZ
                if(bool_completo == 0) {    // que solo mande mensaje una vez
                    EnviarMensajeParkingCompleto();
                    ConfiguracionLEDS(contador_coches);
                    bajar_barrera_entrada();
                    bool_completo = 1;
                }

                // LÓGICA SALIDA
                salida = (PORTA >> PIN_SENSOR) & 1;
                if(salida == 0){
                    if(bool_mensaje_manual == 0) {
                        EnviarMensajeCocheSalida();
                        bool_mensaje_manual = 1;
                    }
                    
                    while(bool_configuracion == 1) {
                        c = RecibirComando();
                        if(c == 'S') {
                            subir_barrera_salida();
                            EnviarMensajeAbrirBarrera();

                            contador_coches--;  // entra un coche, plazas ocupadas++
                            EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                            ConfiguracionLEDS(contador_coches);

                            int k = Retardo(3000);
                            bool_configuracion = 0;
                        } else if(c == 'N') {
                            EnviarMensajeDenegarAcceso();
                            bajar_barrera_salida();
                            bool_configuracion = 0;
                        }
                    }
                } else {
                    bajar_barrera_salida();
                }
            } else if((contador_coches < NUM_MAX_PLAZAS) && (contador_coches > 0)) {
                bool_vacio = 0;
                bool_completo = 0;

                // LÓGICA ENTRADA
                presion_act = getMedidaPresion();
                if((presion_ant != presion_act) && (presion_act == 1)){
                    if(bool_mensaje_automatico == 0) {
                        EnviarMensajeCocheEntrada();
                        bool_mensaje_automatico = 1;
                    }
                    
                    while(bool_configuracion == 1) {
                        c = RecibirComando();
                    
                        if(c == 'S') {
                            subir_barrera_entrada();
                            EnviarMensajeAbrirBarrera();
                            contador_coches++;  // entra un coche, plazas ocupadas++
                            EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                            ConfiguracionLEDS(contador_coches);

                            int k = Retardo(3000);
                            bool_configuracion = 0;
                        } else if(c == 'N') {
                            bajar_barrera_entrada();
                            EnviarMensajeDenegarAcceso();
                            bool_configuracion = 0;
                        }
                    }
                } else {
                    bajar_barrera_entrada();
                }
                presion_ant = presion_act;

                // LÓGICA SALIDA
                salida = (PORTA >> PIN_SENSOR) & 1;
                if(salida == 0){
                    if(bool_mensaje_manual == 0) {
                        EnviarMensajeCocheSalida();
                        bool_mensaje_manual = 1;
                    }
                    
                    while(bool_configuracion == 1) {
                        c = RecibirComando();
                        if(c == 'S') {
                            subir_barrera_salida();
                            EnviarMensajeAbrirBarrera();

                            contador_coches--;  // entra un coche, plazas ocupadas++
                            EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                            ConfiguracionLEDS(contador_coches);

                            int k = Retardo(3000);
                            bool_configuracion = 0;
                        } else if(c == 'N') {
                            EnviarMensajeDenegarAcceso();
                            bajar_barrera_salida();
                            bool_configuracion = 0;
                        }
                    }
                } else {
                    bajar_barrera_salida();
                }
            }
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