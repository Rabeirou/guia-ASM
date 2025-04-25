#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	char* a = "Omega 4";
	char* ac = TEST_CALL_S(strClone, a);
	strDelete(ac);
	return 0;
}
