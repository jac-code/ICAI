/* 
 * File:   Modulo_Servo.h
 * Author: jaime
 *
 * Created on 5 de abril de 2022, 10:49
 */

#ifndef MODULO_SERVO_H
#define	MODULO_SERVO_H

#ifdef	__cplusplus
extern "C" {
#endif
    
    void InicializarServoEntrada();
    void InicializarServoSalida();
    
    void subir_barrera_salida();
    void subir_barrera_entrada();
    void bajar_barrera_salida();
    void bajar_barrera_entrada();


#ifdef	__cplusplus
}
#endif

#endif	/* MODULO_SERVO_H */

