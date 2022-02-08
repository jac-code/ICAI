#include <xc.h>

#define TMAX_PRESCALER_1 13 // (1/5 MHz) * 2^16 = 13.1072 ms
#define TMAX_PRESCALER_2 26
#define TMAX_PRESCALER_4 52
#define TMAX_PRESCALER_8 104 // (1/ (5 MHz/8)) * 2^16 = 104.8576 ms
#define TMAX_PRESCALER_16 209 // 209.7152 ms
#define TMAX_PRESCALER_32 419 //419.4304 ms  
#define TMAX_PRESCALER_64 838 //838.8608 ms
#define TMAX_PRESCALER_256 3355 //3355.48615 ms

#define RANGO_16_BITS 65536

int Retardo(uint16_t retardo_ms) {
    int res = 1;
    float pr2 = 0.0;
    int tckps = 0;
    
    if(((int)((((float)retardo_ms) / TMAX_PRESCALER_1) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = ((float)retardo_ms / TMAX_PRESCALER_1) - 1.0;
        T2CON = 0x0000;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_2) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_2) - 1.0;
        T2CON = 0x0010;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_4) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_4) - 1.0;
        T2CON = 0x0020;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_8) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_8) - 1.0;
        T2CON = 0x0030;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_16) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_16) - 1.0;
        T2CON = 0x0040;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_32) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_32) - 1.0;
        T2CON = 0x0050;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_64) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_64) - 1.0;
        T2CON = 0x0060;
    }
    else if(((int)((((float)retardo_ms) / TMAX_PRESCALER_256) - 1.0)) <= RANGO_16_BITS) {
        res = 0;
        pr2 = (((float)retardo_ms) / TMAX_PRESCALER_256) - 1.0;
        T2CON = 0x0070;
    }
    
    T2CON = 0; // se para el temporizador 2
    TMR2 = 0; // se pone la cuenta a 0
    IFS0bits.T2IF = 0; // se borra el bit de fin de cuenta
    PR2 = (int)pr2; //metemos el valor convirtiendo a int
    //T2CON.ON = 0;
    
    return res;
}

/*
    while(1) {
        if((cont%2) != 0) { //contador impar
            int i = 0;
            for(i = 1; i < 21; i++) {
                int k = Retardo(i);
                if(k == 0) {
                    while(IFS0bits.T2IF == 0) {
                        LATC |= (1 << BIT_LED0);
                    }
                    LATC &= ~(1 << BIT_LED0);
                    IFS0bits.T2IF = 0;
                }
                T2CON = 0x0000;
            }
        }
        else {  //contador par
           int j = 0;
           for(j = 20; j >= 0; j--) {
                int k = Retardo(j);
                T2CON |= (1 << 15);
                if(k == 0) {
                    while(IFS0bits.T2IF == 0) {
                        LATC |= (1 << BIT_LED0);
                    }
                    LATC &= ~(1 << BIT_LED0);
                    IFS0bits.T2IF = 0;
                }
                T2CON = 0x0000;
           }
        }
        cont++;
    }*/