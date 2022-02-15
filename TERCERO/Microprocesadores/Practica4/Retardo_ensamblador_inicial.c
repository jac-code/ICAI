#include <xc.h> 
.text
.global Retardo
.ent Retardo 
Retardo:
    beq a0, zero, Fin	# comprobar si retardo = 0
    la t0, T2CON
    sw zero, 0(t0)  # T2CON=0
    la t0, TMR2
    sw zero, 0(t0)  # TMR2=0
    li t0, 0xFFFFFDFF   # Mascara para poner IFS0bits.T2IF = 0
    la t1, IFS0
    lw t2,0(t1)	# Cargo lo de IFS0
    and t2, t0, t2  # Aplico mascara
    sw t2, 0(t1)    # IFS0bits.T2IF=0
    addiu t0, t0, 0x1387    # 4999 en hexadecimal
    la t2, PR2
    sw t0, 0(t2)    # PR2 = 4999;
    ori t0, zero, 0x8000
    la t2, T2CON
    sw t0,0(t2)	# T2CON = 0x8000; 
    addu v0, zero, zero	# i=0
For:
    sltu t0, v0, a0 # t0 = 1 si i < retardo_ms
    beq t0, zero, Fin # si i < retardo_ms falso, salimos del bucle
    nop
While:
    lw t0, 0(t1)    # Leo en t0 el registro IFS0
    li t3, 0x0200   # Mascara para poner todo a 0 menos el bit que me interesa
    and t4, t0, t3  # Aplico mascara
    beq t4, zero, While	# Si todo es 0 ese bit que me interesa esta a 0
    nop
    li t0, 0xFFFFFDFF   # Mascara para poner IFS0bits.T2IF=0
    la t1, IFS0
    lw t2,0(t1)	# Cargo lo de IFS0
    and t2, t0, t2  # Aplico mascara
    sw t2, 0(t1)    # IFS0bits.T2IF = 0
    addi v0, v0, 1  # i++
    j For
    nop
Fin:
    jr ra
    .end Retardo