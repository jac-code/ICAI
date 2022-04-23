#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloServo.h"
#include "ModuloUART.h"
#include "ModuloSensorPresion.h"
#include "Retardo.h"

#define PIN_PULSADOR  5
#define PIN_SENSOR 9

#define NUM_MAX_PLAZAS 20
#define NUM_INICIO_PLAZAS 18

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
    
    int pulsador_ant, pulsador_act;
    int presion_act, presion_ant;
    int salida;
    
    int contador_coches = NUM_INICIO_PLAZAS; // numero de plazas OCUPADAS

    ANSELC &= ~0xF;

    LATA = 0; // En el arranque dejamos todas las salidas a 0
    LATB = 0;
    LATC = 0xFF; // Apago los LEDs de la placa

    TRISA = 0;
    TRISA |= (1 << PIN_SENSOR);
    TRISB |= (1 << PIN_PULSADOR);
    TRISC = 0;

    InicializarSensorPresion();
    InicializarServos();
    InicializarUART1();
    
    ConfiguracionLEDS(contador_coches);
    EnviarMensajeBienvenida();
    EnviarSalto();
    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
    EnviarSalto();
    
    pulsador_ant = (PORTB >> PIN_PULSADOR) & 1;
    presion_ant = getMedidaPresion();
    
    while(1) {
        if(contador_coches == 0) {  // PARKING VACIO --> solo pueden entrar coches
            // ENVIAR MENSAJE SOLO UNA VEZ
            if(bool_vacio == 0) {    // que solo mande mensaje una vez
                EnviarMensajeParkingVacio();
                ConfiguracionLEDS(contador_coches);
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
    }
}

/*
 * 
 * // LÓGICA SALIDA
            pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
            if((pulsador_ant != pulsador_act) && (pulsador_act == 1)){
                subir_barrera_salida();
                
                contador_coches--;  // entra un coche, plazas ocupadas++
                EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                ConfiguracionLEDS(contador_coches);
                
                int k = Retardo(3000);
            } else {
                bajar_barrera_salida();
            }
            pulsador_ant = pulsador_act;
 * 
        if(contador_coches <= NUM_MAX_PLAZAS) {
            if(contador_coches > 0) {
                presion_act = getMedidaPresion();
                if((presion_act != presion_ant) && (getMedidaPresion() == 1)){
                    subir_barrera_entrada();
                    while(getMedidaPresion() == 1);
                    
                    presion_ant = presion_act;
                    contador_coches++;  // entra un coche, plazas ocupadas++
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);
                } else {
                    bajar_barrera_entrada();
                }
            }
            if(contador_coches < NUM_MAX_PLAZAS) {
                pulsador_act = (PORTB >> PIN_PULSADOR) & 1;
                if ((pulsador_act != pulsador_ant) && (pulsador_act == 0)) {
                    contador_coches--;  // sale un coche
                    EnviarMensajeInfoPlazas(contador_coches, NUM_MAX_PLAZAS);
                    ConfiguracionLEDS(contador_coches);
                }
                pulsador_ant = pulsador_act;
            }
        } else {
            bajar_barrera_entrada();
        }
 
 #include <xc.h> 
.text
.global Retardo
.ent Retardo
Retardo:
    beq a0, zero, Fin	# comprobar si retardo = 0
    la t0, T2CON
    sw zero, 0(t0)  # T2CON=0
    la t0, TMR2
    sw zero, 0(t0)  # TMR2=0
    li t0, 0xFFFFFDFF   # Mascara para poner IFS0bits.T2IF = 0
    la t1, IFS0
    lw t2,0(t1)	# Cargo lo de IFS0
    and t2, t0, t2  # Aplico mascara
    sw t2, 0(t1)    # IFS0bits.T2IF=0
    addiu t0, t0, 0x1387    # 4999 en hexadecimal
    la t2, PR2
    sw t0, 0(t2)    # PR2 = 4999;
    ori t0, zero, 0x8000
    la t2, T2CON
    sw t0,0(t2)	# T2CON = 0x8000; 
    addu v0, zero, zero	# i=0
For:
    sltu t0, v0, a0 # t0 = 1 si i < retardo_ms
    beq t0, zero, Fin # si i < retardo_ms falso, salimos del bucle
    nop
While:
    lw t0, 0(t1)    # Leo en t0 el registro IFS0
    li t3, 0x0200   # Mascara para poner todo a 0 menos el bit que me interesa
    and t4, t0, t3  # Aplico mascara
    beq t4, zero, While	# Si todo es 0 ese bit que me interesa esta a 0
    nop
    li t0, 0xFFFFFDFF   # Mascara para poner IFS0bits.T2IF=0
    la t1, IFS0
    lw t2,0(t1)	# Cargo lo de IFS0
    and t2, t0, t2  # Aplico mascara
    sw t2, 0(t1)    # IFS0bits.T2IF = 0
    addi v0, v0, 1  # i++
    j For
    nop
Fin:
    jr ra
    .end Retardo
 
 */

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