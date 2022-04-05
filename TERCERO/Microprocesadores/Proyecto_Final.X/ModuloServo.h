#ifndef MODULOSERVO_H
#define	MODULOSERVO_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarServoSalida();
    void InicializarServoEntrada();
    void bajar_barrera_salida();
    void subir_barrera_salida();
    void bajar_barrera_entrada();
    void subir_barrera_entrada();

#ifdef	__cplusplus
}
#endif

#endif	/* MODULOSERVO_H */

