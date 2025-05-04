#include "ej1.h"

char** agrupar_c(msg_t* msgArr, size_t msgArr_len){
}

char* str_concat(char* a, char* b) {
    if (!a) a = "";
    if (!b) b = "";
	int len1 = strlen(a);
    int len2 = strlen(b);
	int totalLength = len1 + len2;
    char *result = (char *)malloc(totalLength + 1); 
    strcpy(result, a);
    strcat(result, b);
    return result;  
}
