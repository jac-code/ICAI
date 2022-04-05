/* 
 * File:   Temporizador.h
 * Author: jaime
 *
 * Created on 20 de febrero de 2022, 11:00
 */

#ifndef TEMPORIZADOR_H
#define	TEMPORIZADOR_H

#ifdef	__cplusplus
extern "C" {
#endif

    void InicializarTimer2(int tiempo, int prioridad, int subprioridad, int valor_prescaler);
    uint32_t TicksDesdeArr(void);

#ifdef	__cplusplus
}
#endif

#endif	/* TEMPORIZADOR_H */

