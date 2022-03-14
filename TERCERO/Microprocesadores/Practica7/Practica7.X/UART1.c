#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
 
#define TAM_COLA 100

#define FREC_RELOJ 5000000

#define RB7 7
#define RB13 13

static char cola_rx[TAM_COLA]; // cola de recepción 
static int icab_rx = 0; // índice para añadir 
static int icol_rx = 0; // índice para leer
static char cola_tx[TAM_COLA]; // cola de transmisión 
static int icab_tx = 0; // índice para añadir 
static int icol_tx = 0; // índice para leer
 
__attribute__((vector(32), interrupt(IPL3SOFT),nomips16))
void InterrupcionUART1(void) {
    if(IFS1bits.U1RXIF == 1){ // Ha interrumpido el receptor
        if( (icab_rx+1 == icol_rx) || (icab_rx+1 == TAM_COLA && icol_rx == 0)){
          // La cola está llena
        } else {
            cola_rx[icab_rx] = U1RXREG; // Lee carÃ¡cter de la UART 
            icab_rx++;
            if(icab_rx == TAM_COLA){
                icab_rx = 0; 
            }
        }
        IFS1bits.U1RXIF = 0; // Y para terminar se borra el flag
    }
    if(IFS1bits.U1TXIF == 1){ // Ha interrumpido el transmisor
    // Se extrae un carácter de la cola y se envía 
        if(icol_tx != icab_tx){ // Hay datos nuevos
            U1TXREG = cola_tx[icol_tx]; 
            icol_tx++;
            if(icol_tx == TAM_COLA){
                icol_tx = 0; 
            }
        }else{ // Se ha vaciado la cola
            IEC1bits.U1TXIE = 0; // Para evitar bucle sin fin
        }
        IFS1bits.U1TXIF = 0; // Y para terminar se borra el flag
    }
}

void InicializarUART1(int baudios){
    double valor;
    if(baudios > 38400){
        valor = (FREC_RELOJ/(4*baudios)) - 1;    //Modo de alta velocidad con BRGH = 1
        if((FREC_RELOJ%(4*9600)) > (9600*2)){
            valor++;    // aproximación hacia arriba, menor error
        }
    } else{
        valor = FREC_RELOJ/(16*baudios) - 1;
        if((FREC_RELOJ%(16*9600)) > (9600*8)){
            valor++;    // aproximación hacia arriba, menor error
        }
    }
    
    U1BRG = (int) valor;
    
    // Activamos las interrupciones del receptor
    IFS1bits.U1RXIF = 0; // Borro flag receptor
    IEC1bits.U1RXIE = 1; // Habilito interrupciones 
    IFS1bits.U1TXIF = 0; // Borro flag del transmisor
    IPC8bits.U1IP = 3; // Prioridad 3 
    IPC8bits.U1IS = 1; // Subprioridad 1
    
    // Conectamos U1RX y U1TX a los pines RB13 y RB7 del micro 
    ANSELB &= ~((1 << RB13)|(1 << RB7)); // Pines digitales
    TRISB |= (1 << RB13); // Y RB13 como entrada
    LATB |= (1 << RB7); // A 1 si el transmisor está inhabilitado.
    
    SYSKEY=0xAA996655; // Se desbloquean los registros 
    SYSKEY=0x556699AA; // de configuración.
    U1RXR = 3; // U1RX conectado a RB13
    RPB7R = 1; // U1TX conectado a RB7
    SYSKEY=0x1CA11CA1; // Se vuelven a bloquear
    
    U1STAbits.URXISEL = 0; // Interrupción cuando llegue 1 char
    U1STAbits.UTXISEL = 2; // Interrupciçon cuando FIFO vacía
    U1STAbits.URXEN = 1; // habilitar el receptor
    U1STAbits.UTXEN = 1; // habilitar el transmisor
    U1MODE = 0x8000; // Se arranca la UART
}

void putsUART(char *ps) {
    while(*ps != '\0'){ // iteramos por la frase
        if( (icab_tx+1 == icol_tx) || (icab_tx+1 == TAM_COLA && icol_tx == 0)){
            // La cola está llena --> Se aborta el envío de los caracteres que restan
            break;
        }else{
            cola_tx[icab_tx] = *ps; // Copia el carácter en la cola 
            ps++;  //Apunto al siguiente carácter de la cadena 
            icab_tx++;
            if(icab_tx == TAM_COLA){
                icab_tx = 0;
            }
        }
    }
    // Se habilitan las interrupciones del transmisor para comenzar a enviar
    IEC1bits.U1TXIE = 1;
}

char getcUART(void) {
    char c;
    
    if(icol_rx != icab_rx){ // Hay datos nuevos 
        c = cola_rx[icol_rx];
        icol_rx++;
        if(icol_rx == TAM_COLA){ 
            icol_rx=0;
        }
    }else{ // no ha llegado nada
        c = '\0'; 
    }
    return c;
}
