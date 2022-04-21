
#include <xc.h>
		.text
		
		.global Retardo
		
		.ent Retardo

Retardo : beq a0, zero, FIN
								//preparar el temporizador
		  lui v0, 0xBF80
		  sw zero, 2048(v0)
		  sw zero, 2064(v0) //tmr2 a 0
		  lui t1, 0xBF88 //cargo pos de IFS0
		  li t2, 0x7FFFFDFF //mascara con todo a 1 menos el t2IF
		  lw t3, 4144(t1) //cargo el registro en t3 
		  and t2, t2,t3 //aplico mascara para poner a 0
		  sw t2, 4144(t1) //guardo el resultado
		  addiu t3, zero, 4999 //cargo valor de pr2
		  sw t3, 2080(v0) //lo guardo
		  addiu t2, zero, 0x8000 //cargo el valor de T2CON (enciendo y pongo tckps a 0)
		  sw t2, 2048(v0) //guardo el valor
Bucle :	  lw t3, 4144(t1)
		  addiu t4, zero, 512 //mascara con 1 en el t2IF (se puede poner antes del bucle para mejorar la eficiencia al nop tener que ejecutarse cada bucle)
		  and t3, t4, t3			
		  beq t3,zero, Bucle			
		  li t2, 0x7FFFFDFF //mascara con todo a 1 menos el t2IF
		  lw t3, 4144(t1) //cargo el registro en t3 
		  and t2, t2,t3 //aplico mascara para poner a 0
		  sw t2, 4144(t1) //guardo el resultado
		  addiu a0, a0, -1	//retardo_ms--
		  beq a0,zero, FIN
		  j Bucle

FIN : sw zero, 2048(v0) 
		  jr ra

		.end Retardo