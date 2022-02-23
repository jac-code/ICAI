/* 
 * File:   TemporizadorSeccion4.h
 * Author: jaime
 *
 * Created on 20 de febrero de 2022, 11:42
 */

#ifndef TEMPORIZADORSECCION4SIMPLE_H
#define	TEMPORIZADORSECCION4SIMPLE_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler);
    uint16_t num_pulsaciones;

#ifdef	__cplusplus
}
#endif

#endif	/* TEMPORIZADORSECCION4SIMPLE_H */

