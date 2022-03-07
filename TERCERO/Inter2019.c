/*******************************************************/
/****************** EJERCICIO 1 ************************/
/*******************************************************/

// a1 = pcad1, a2 = pcad2
// recibe dos cadenas --> copia pcad2* en pcad1*
STRCPY: 
BUCLE:  lb t1, 0(a1)
        beq t1, zero, FIN 
        sb t1, 0(a0)
        addi a0, a0, 1
        addi a1, a1, 1
        j BUCLE

FIN:    jr ra

// a1 = pcad1, a2 = pcad2
// recibe dos cadenas : pcad1* > pcad2* --> positivo
//                      pcad1* < pcad2* --> negativo
//                      pcad1* = pcad2* --> 0
STRCMP:     add v0, zero, zero
BUCLE:      lb s1, 0(a1)
            lb s0, 0(a0)
            slt v0, s0, s1 // pcad1* < pcad2* --> v0 = 1
            addi t2, zero, 1
            beq v0 , t2, NEGATIVO
            beq v0, t2, POSITIVO
            beq t1, t0, IGUALES

NEGATIVO:   addi v0, v0, -1
            j INTERMEDIO

POSITIVO:   addi v0, v0, 1
            j INTERMEDIO

IGUALES:    beq s0, zero, FIN
            addi v0, v0, 0
            j INTERMEDIO

INTERMEDIO: addi a1, a1, 1  // actualizo punteros
            addi a0, a0, 1
            j BUCLE

FIN:        jr ra

/************* NO ACUMULATIVO ************/

// a1 = pcad1, a2 = pcad2
// recibe dos cadenas : pcad1* > pcad2* --> positivo
//                      pcad1* < pcad2* --> negativo
//                      pcad1* = pcad2* --> 0
STRCMP:     add v0, zero, zero
BUCLE:      lb s1, 0(a1)
            lb s0, 0(a0)
            slt v0, s0, s1 // pcad1* < pcad2* --> v0 = 1
            addi t2, zero, 1
            beq v0 , t2, NEGATIVO
            beq v0, t2, POSITIVO
            beq t1, t0, IGUALES
            
NEGATIVO:   addi v0, zero, -1
            jr ra

POSITIVO:   addi v0, zero, 1
            jr ra

IGUALES:    beq s0, zero, FIN
            j INTERMEDIO

INTERMEDIO: addi a1, a1, 1  // actualizo punteros
            addi a0, a0, 1
            j BUCLE

FIN:        addi v0, zero, 0
            jr ra

// a0 = pcad0, a1 = pcad1, a2 = pcad2
// copia cadena menor entre pcad1 y pcad2 en pcad0

STRMINCPY:  addi sp, sp, -16    // hacer hueco en pila
            sw ra, 12(sp)
            sw a0, 8(sp)
            sw a1, 4(sp)
            sw a2, 0(sp)

            jal STRCMP
            addi s0, zero, -1
            beq v0, s0, COPIAR
            bne v0, s0, FIN

COPIAR:     jal STRCPY
   
FIN:        lw ra, 12(sp)   // RESTAURAR LA PILA
            addi sp, sp, 16
            jr ra


/*******************************************************/
/****************** EJERCICIO 2 ************************/
/*******************************************************/

#include <xc.h>
#include "Pic32Ini.h"
#include <stdio.h>

#define V_SONIDO 340

static int medida = 0;

int main(int argc, char const *argv[]) {
    int puls_ant, puls_act;

    // 0x XXXX XXXX XXXX XXXX
    ANSELB = 0x0003; // 0000 0000 0000 0011
    ANSELA = 0;    // 0000 0000 0000 0000

    // 0x 0000 0000 0001 0010
    TRISB = 0x0012;
    TRISB |= (1 << 5);
    TRISB |= (1 << 1);  // ECHO
    TRISB &= ~(1 << 0); // TRIGGER

    TRISA = 0;  // 0x 0000 0000 0000 0000

    LATA = 0x079F;    // 0x 0000 0111 1001 1111

    SYSKEY = 0xAA996655 ; // Se desbloquean los registros
    SYSKEY = 0x556699AA ; // de configuración.
    T3CKR = 2; // T3CK conectado al PB1.
    SYSKEY = 0x1CA11CA1 ; // Se vuelven a bloquear.

    INTCONbits.MULTIVEC = 1;
    asm(" ei");

    puls_ant = (PORTB >> 5) & 1;
    while(1) {
        puls_act = (PORTB >> 5) & 1;
        if ((puls_ant != puls_act) && (puls_act == 0)) {
            asm(" ei");
            medida = 1;
            asm(" di");
        }
        puls_ant = puls_act;
    }

    return 0;
}

__attribute__((vector(8), interrupt(IPL2SOFT), nomips16))
void InterrupcionTimer2(void) {
    // borrar flag
    IFS0bits.T2IF = 0;

    if (medida == 1) {
        // generar pulso

        medida = 0;
    }
}

void InicializarTimer2() {
    T2CON = 0;
    TMR2 = 0;
    IFS0bits.T2IF = 0;
    IFS0 &= ~(1 << 9);

    IEC0bits.T2IE = 1;
    IEC0 |= (1 << 9);

    IPC2bits.T2IP = 2;
    IPC2 = 0x0002;
    IPC2bits.T2IS = 1;
    IPC2 = 0x0001;
    PR2 = 49;
    T2CON = 0x8000;
}

void InicializarTimer3() {
    T3CON = 0;
    TMR3 = 0;

    IFS0bits.T3IF = 0;
    IFS0 &= ~(1 << 14);

    T3CON &= ~(1 << 1); // TCS = 0
    T3CON |= (1 << 7);  // TGATE = 1 
    T3CON |= (1 << 15); // ON = 1
    // o hacer esto
    T3CON = 0x8080; // 0x 1000 0000 1000 0000
}

int distancia() {
    int dis = 0;
    
    if (IFS0bits.T3IF == 1) {   // ha terminado la cuenta
        // leemos el valor de TMR3 --> se pone tal cual
        dis = (TMR3 * V_SONIDO) / 2;
    }

    return dis;
}