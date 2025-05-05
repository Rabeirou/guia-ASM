ORDERING_TABLE_TAM EQU 16
ORDERING_TABLE_OFFSET_SIZE EQU 0
ORDERING_TABLE_OFFSET_TABLE EQU 8


NODO_OT_TAM EQU 16
NODO_OT_OFFSET_DISPLAY_ELEMENT EQU 0
NODO_OT_OFFSET_SIGUIENTE EQU 8


NODO_DISPLAY_TAM EQU 24
NODO_DISPLAY_OFFSET_PRIMITIVA EQU 0
NODO_DISPLAY_OFFSET_X EQU 8
NODO_DISPLAY_OFFSET_Y EQU 9
NODO_DISPLAY_OFFSET_Z EQU 10
NODO_DISPLAY_OFFSET_SIGUIENTE EQU 16

%define NULL 0

section .text

global inicializar_OT_asm
global calcular_z_asm
global ordenar_display_list_asm

extern malloc
extern calloc
extern free


;########### SECCION DE TEXTO (PROGRAMA)

; ordering_table_t* inicializar_OT(uint8_t table_size) 
inicializar_OT_asm:
    ;rdi (dil) -> table_size
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada

    movzx rdi, dil ;limpio la parte alta de rdi
    mov r12, rdi ;guardo el valor de table_size
    mov rdi, ORDERING_TABLE_TAM

    call malloc ;pido espacio para la nueva OT
    mov r13, rax ;guardo el puntero a la nueva OT

    mov byte [r13 + ORDERING_TABLE_OFFSET_SIZE], r12b ;OT->table_size = table_size

    cmp r12b, NULL ;table_size == NULL?
    je .tabla_null

    mov rdi, r12
    imul rdi, NODO_OT_TAM ;rdi = table_size * NODO_OT_TAM

    call calloc ;pido espacio para la tabla que va a estar dentro de OT

    jmp .fin

.tabla_null:
    xor rax, rax

.fin:
    mov [r13 + ORDERING_TABLE_OFFSET_TABLE], rax ;OT->table = nueva tabla

    mov rax, r13 ;rax = puntero a la nueva OT

    pop r13
    pop r12
    pop rbp
    ret

; void* calcular_z(nodo_display_list_t* nodo, uint8_t z_size) ;
calcular_z_asm: 
    ;rdi -> nodo
    ;rsi (sil) -> z_size
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada

    mov r12, rdi ;guardo el valor de nodo
    movzx r13, sil ;guardo el valor de z_size

.loop:
    cmp r12, NULL ;nodo_actual == NULL?
    je .fin

    mov rcx, [r12 + NODO_DISPLAY_OFFSET_PRIMITIVA] ;rcx = nodo_actual->primitiva
    mov rdi, [r12 + NODO_DISPLAY_OFFSET_X] ;rdi = nodo_actual->x
    mov rsi, [r12 + NODO_DISPLAY_OFFSET_Y] ;rsi = nodo_actual->y
    mov rdx, r13 ;rdx = z_size

    call rcx ;llamo a la funcion primitiva
    mov byte [r12 + NODO_DISPLAY_OFFSET_Z], al ;nodo_actual->z = z_calculada

    mov r12, [r12 + NODO_DISPLAY_OFFSET_SIGUIENTE] ;nodo_actual = nodo_actual->siguiente
    jmp .loop

.fin:
    pop r13
    pop r12
    pop rbp
    ret

; void* ordenar_display_list(ordering_table_t* ot, nodo_display_list_t* display_list) ;
ordenar_display_list_asm:
    ;rdi -> ot
    ;rsi -> display_list
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada
    push r14
    push r15 ;alineada

    mov r12, rdi ;guardo el valor de ot
    mov r13, rsi ;guardo el valor de display_list
    mov r14, [r12 + ORDERING_TABLE_OFFSET_SIZE] ;r14 = ot->table_size
    mov r15, [r12 + ORDERING_TABLE_OFFSET_TABLE] ;r15 = ot->table

.loop:
    cmp r13, NULL ;nodo_actual == NULL?
    je .fin

    mov rdi, r13 ;rdi = nodo_actual
    mov rsi, r14 ;rsi = ot->table_size
    call calcular_z_asm

    mov rdi, NODO_OT_TAM
    call malloc ;creo un nuevo nodo_ot

    xor rcx, rcx
    mov byte cl, [r13 + NODO_DISPLAY_OFFSET_Z] ;rcx = nodo_actual->z
    imul rcx, 8 ;rcx = nodo_actual->z * 8

    mov rsi, [r15 + rcx] ;rsi = ot->table[nodo_actual->z]

    mov [rax + NODO_OT_OFFSET_DISPLAY_ELEMENT], r13 ;nodo_ot_actual->display_element = nodo_actual
    mov [rax + NODO_OT_OFFSET_SIGUIENTE], rsi ;nodo_ot_actual->siguiente = ot-table[nodo_actual->z]
    mov [r15 + rcx], rax ;ot->table[nodo_actual->z] = nodo_ot_actual

    mov r13, [r13 + NODO_DISPLAY_OFFSET_SIGUIENTE] ;nodo_actual = nodo_actual->siguiente
    jmp .loop

.fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
