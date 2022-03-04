/*******************************************************/
/****************** EJERCICIO 1 ************************/
/*******************************************************/

// s0 --> i, a0 --> a[], a1 --> b[], a2 --> n

PRODUCTOESCALAR:   add s0, zero, zero  // PARA ITERAR i = 0
                    addi v0, zero, 0
            BUCLE:  beq s0, a2, FIN
                    sll t0, s0, 2   // t0 tiene i*4
                    add t0, s0, a0  // dir. a[i]
                    lw t1, 0(t0)    // valor = a[i]
                    add t2, s0, a1  // dir. de b[i]
                    lw t2, 0(t0)    // valor = b[i]
                    add t1, t2, t1 
                    add v0, v0, t1  // res = res + (a[i] + b[i]) --> en vo para retornarlo
                    addi s0, s0, 1    // i++
                    j BUCLE
            FIN:    jr ra

PRODUCTOESCALAR:    addi v0, zero, 0
            BUCLE:  beq zero, a2, FIN
                    lw t1, 0(a0)    // valor = a[i]
                    lw t2, 0(a1)    // valor = b[i]
                    mul t1, t2, t1 
                    add v0, v0, t1  // res = res + (a[i] + b[i]) --> en vo para retornarlo
                    addi a0, a0, 4  // siguiente numero en vector
                    addi a1, a1, 4
                    addi a2, a2, -1    // i--
                    j BUCLE
            FIN:    jr ra

/********** PASANDO PARÁMETROS POR PILA ******************/

PRODUCTOESCALAR:   add s0, zero, zero  // PARA ITERAR i = 0
                    lw s1, 8(sp)    // s1 --> n
                    lw s2, 4(sp)    // s2 --> b[]
                    lw s3, 0(sp)    // s3 --> a[]
            BUCLE:  beq s0, s1, FIN
                    sll t0, s0, 2   // t0 tiene i*4
                    add t0, s0, s3  // dir. a[i]
                    lw t1, 0(t0)    // valor = a[i]
                    add t2, s0, s2  // dir. de b[i]
                    lw t2, 0(t0)    // valor = b[i]
                    mul t1, t2, t1 
                    add v0, v0, t1  // res = res + (a[i] + b[i]) --> en vo para retornarlo
                    addi s0, s0, 1    // i++
                    j BUCLE
            FIN:    jr ra
/*********************** MAIN *******************/

MAIN:   lui t0, 0xA000  // li t0, 0xA0000010
        ori t0, t0, 0x0010
        addi t1, zero, 1
        sw t1, 0(t0)
        addi t1, zero, 7
        sw t1, 4(t0)
        addi t1, zero, 10
        sw t1, 8(t0)
        lui t2, 0xA000
        ori t2, t2, 0x0020
        addi t1, zero, 3
        sw t1, 0(t2)
        addi t1, zero, 4
        sw t1, 4(t2)
        addi t1, zero, 27
        sw t1, 8(t2)

        // pasamos por la pila
        addi sp, sp, -16    // hacemos sitio en la pila
        sw t0, 12(sp)    // metemos a[]
        sw t2, 8(sp)    // metemos b[]
        addi t0, zero, 3    // dimension de los vectores
        sw t0, 4(sp)    // metemos n
        sq ra, 0(sp)    // tenemos que guaradar el ra

        jal PRODUCTOESCALAR

        lui t0, 0xA000      // lui t0, 0xA000
        ori t0, t0, 0x0030  // sw v0, 0x30(t0)
        sw v0, 0(t0)

        lw ra, 0(sp)
        lw
        addi sp, sp, 16 // restauramos pila

        addi v0, zero, 0    // return 0
        jr ra   // retornamos 

/*******************************************************/
/****************** EJERCICIO 2 ************************/
/*******************************************************/

#include <xc.h>
#include "Pic32Ini.h"
#include <stdio.h>

#define T 20    // 20 ms

static int factor_servicio = 0;

int main(int argc, char const *argv[])
{
    int puls_act, puls_ant;

    // configuramos digitales y analógicos
    ANSELC &= ~(1 << 0);
    ANSELB &= ~(1 << 5);

    // configuramos entradas y salidas
    TRISC &= ~(1 <<< 0);
    TRISB |= (1 << 5);

    // LED empieza apagado
    LATC |= (1 << 0);

    InicializarTimer2();
    
    //activamos las interrupciones
    INTCONbits.MVEC = 1;    // INTCON |= (1 << 12);
    asm(" ei");

    puls_ant = (PORTB >> 5) & 1;    // cogemos valor PORTB

    while(1) {
        puls_act = (PORTB >> 5) & 1;

        if ((puls_ant != puls_act) && (puls_act == 0)) {
            asm(" di");
            factor_servicio = factor_servicio + 10;
            if (factor_servicio > 100) {
                factor_servicio = 0;
            }
            asm(" ei");
        }
        puls_ant = puls_act;    // IMPORTANTE !!!
    }

    return 0;
}

__attribute__((vector(8), interrupt(IPL2SOFT), nomips16))
void InterrupcionTimer2(void) {
    // borramos flag para que no vuelva a entrar
    static int cont = 0;
    static int tiempo_alto = 0;
    IFS0bits.T2IF = 0;

    tiempo_alto = (factor_servicio * T) / 100;
    if (cont < tiempo_alto) {   // durante el tiempo en alto --> encendido
        LATC &= ~(1 << 0);
    } else {
        LATC |= (1 << 0);
    }
    
    cont++;
    if (cont > T) {
        cont = 0;
    }
}

void InicializarTimer2() {
    T2CON = 0;
    TMR2 = 0;
    IFS0bits.T2IF = 0;  // IFS0 &= ~(1 << 9); 
    IEC0bits.T2IE = 1;  // IEC0 |= (1 << 9);
    IPC2bits.T2IP = 2;  // IPC2 = 0x0002; --> 0x 0000 0000 0000 0010 --> IPC2 |= (1 << 1);
    IPC2bits.T2IS = 1;  // IPC2 = 0x0001; --> 0x 0000 0000 0000 0001 --> IPC2 |= (1 << 0);
    PR2 = 499;
    T2CON = 0x8000;
}