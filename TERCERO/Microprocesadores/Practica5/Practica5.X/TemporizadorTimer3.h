/* 
 * File:   TemporizadorTimer3.h
 * Author: jaime
 *
 * Created on 20 de febrero de 2022, 11:26
 */

#ifndef TEMPORIZADORTIMER3_H
#define	TEMPORIZADORTIMER3_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarTimer3(int tiempo, int prioridad, int subprioridad, int valor_prescaler);
    uint32_t TicksDesdeArrTimer3(void);


#ifdef	__cplusplus
}
#endif

#endif	/* TEMPORIZADORTIMER3_H */

