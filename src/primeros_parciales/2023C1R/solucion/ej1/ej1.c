#include "ej1.h"

uint32_t* acumuladoPorCliente(uint8_t cantidadDePagos, pago_t* arr_pagos){
    uint32_t pagosPorCliente[10];
    for(int i = 0; i < cantidadDePagos; ++i) {
        pago_t actual = arr_pagos[i];
        if(actual.aprobado) {
            uint32_t* pagosPorClienteActual = &pagosPorCliente[actual.cliente];
            uint8_t montoActual = actual.monto;
            *pagosPorClienteActual += montoActual;
        }
    }
    return pagosPorCliente;
}

uint8_t en_blacklist(char* comercio, char** lista_comercios, uint8_t n){
}

pago_t** blacklistComercios(uint8_t cantidad_pagos, pago_t* arr_pagos, char** arr_comercios, uint8_t size_comercios){
}


