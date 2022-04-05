/* 
 * File:   TemporizadorTimer2.h
 * Author: jaime
 *
 * Created on 20 de febrero de 2022, 11:26
 */

#ifndef TEMPORIZADORTIMER2_H
#define	TEMPORIZADORTIMER2_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler);
    uint32_t TicksDesdeArrTimer2(void);


#ifdef	__cplusplus
}
#endif

#endif	/* TEMPORIZADORTIMER2_H */

