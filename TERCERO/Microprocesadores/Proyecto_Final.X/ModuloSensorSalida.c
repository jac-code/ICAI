#include <xc.h>
#include <stdint.h>
#include "Pic32Ini.h"
#include "ModuloSensorSalida.h"

#define PIN_SALIDA 9    // conectado a RA9

void InicializarSensorSalida() {
    TRISA |= (1 << PIN_SALIDA);
}

int getMedidaSalida() {
    int salida = 0;
    salida = (PORTA >> PIN_SALIDA) & 1;
    return salida;
}
