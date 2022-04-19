#ifndef MODULOUART_H
#define	MODULOUART_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarUART1();
    void EnviarMensajeBienvenida();
    void EnviarSalto();
    void EnviarPadding();
    void EnviarMensajeInfoPlazas(int contador_plazas, int max_plazas);
    void EnviarMensajeParkingCompleto();
    void EnviarMensajeParkingVacio();

#ifdef	__cplusplus
}
#endif

#endif	/* MODULOUART_H */

