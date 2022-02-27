#ifndef UART1_H
#define	UART1_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarUART1(int baudios);
    void putsUART(char *ps);
    char getcUART(void);

#ifdef	__cplusplus
}
#endif

#endif	/* UART1_H */