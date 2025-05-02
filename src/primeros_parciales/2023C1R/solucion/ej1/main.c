#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){
    char* comercio = "comer";
    char* lista_comercios[] = {"hola", "comea", "sdf"}; 
    uint8_t res = en_blacklist_asm(comercio, lista_comercios, 3);
    if (res == 1) {
        printf("yey\n");
    } else {
        printf("notFound\n");
    }
}


