; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

STRING_PROC_LIST_OFFSET EQU 16
STRING_PROC_LIST_FIRST_OFFSET EQU 0
STRING_PROC_LIST_LAST_OFFSET EQU 8
STRING_PROC_NODE_OFFSET EQU 32
STRING_PROC_NODE_NEXT_OFFSET EQU 0
STRING_PROC_NODE_PREVIOUS_OFFSET EQU 8
STRING_PROC_NODE_TYPE_OFFSET EQU 16
STRING_PROC_NODE_HASH_OFFSET EQU 24

section .data

section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat


string_proc_list_create_asm:
    push rbp ;alineada
    mov rbp, rsp
    
    mov rdi, STRING_PROC_LIST_OFFSET
    call malloc
    mov qword [rax], NULL ;list->first = NULL
    mov qword [rax + 8], NULL ;list->last = NULL
    ;mov rdi, [rax]
    ;mov rsi, [rax + 8]

    pop rbp
    ret

string_proc_node_create_asm:
    ;type -> rdi
    ;hash -> rsi
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada

    mov r12, rdi ;guardo type
    mov r13, rsi ;guardo hash

    mov rdi, STRING_PROC_NODE_OFFSET
    call malloc
    mov qword [rax], NULL
    mov qword [rax + 8], NULL
    mov byte [rax + 16], r12b
    mov qword [rax + 24], r13

    mov rdi, [rax]
    mov rsi, [rax + 8]
    mov byte cl, [rax + 16]
    mov r8, [rax + 24]

    pop r13
    pop r12
    pop rbp
    ret

string_proc_list_add_node_asm:
    ;list -> rdi
    ;type -> rsi
    ;hash -> rdx
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada
    push r14
    push r15 ;alineada

    mov r12, rdi ;list
    mov r13, rsi ;type
    mov r14, rdx ;hash

    mov rdi, r13 ;type
    mov rsi, r14 ;hash
    call string_proc_node_create_asm ;newNode
    
    mov r15, [r12 + STRING_PROC_LIST_LAST_OFFSET] ;list->last
    cmp r15, NULL
    je .addFirstNode

.replaceLastNode:
    mov [r15 + STRING_PROC_NODE_NEXT_OFFSET], rax ;list->last->next = newNode
    mov [rax + STRING_PROC_NODE_PREVIOUS_OFFSET], r15 ;newNode->previous = list->last
    jmp .fin

.addFirstNode:
    mov [r12 + STRING_PROC_LIST_FIRST_OFFSET], rax ;list->first = newNode

.fin:
    mov [r12 + STRING_PROC_LIST_LAST_OFFSET], rax ;list->last = newNode
    mov rax, r12

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

string_proc_list_concat_asm:
    ;list -> rdi
    ;type -> rsi
    ;hash -> rdx
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada
    push r14
    push r15 ;alineada
    push rbx
    sub rsp, 8 ;alineada

    mov r12, rdi ;list
    mov r13, rsi ;type
    mov r14, rdx ;hash
    xor rbx, rbx ;seteo mi flag para saber si ya concatené algo en 0

    cmp r12, NULL ;list == NULL?
    je .fin

    mov r15, [r12 + STRING_PROC_LIST_FIRST_OFFSET] ;list->first (currNode)

.loop:
    cmp r15, NULL ;currNode == NULL?
    je .fin

    xor rdi, rdi
    mov byte dil, [r15 + STRING_PROC_NODE_TYPE_OFFSET] ;currNode->type
    cmp rdi, r13 ;currNode->type == type?
    je .concatHashes

.nextIteration:
    mov r15, [r15 + STRING_PROC_NODE_NEXT_OFFSET] ;currNode = currNode->next
    jmp .loop

.concatHashes:
    mov rdi, r14 ;hash
    mov rsi, [r15 + STRING_PROC_NODE_HASH_OFFSET] ;currNode->hash
    call str_concat ;obtengo hashConcatenado

    cmp rbx, 0
    je .skipFree

    push rax
    sub rsp, 8
    
    mov rdi, r14
    call free

    add rsp, 8
    pop rax

.skipFree:
    mov r14, rax ;hash = hashConcatenado
    mov rbx, 1 ;seteo flag para saber que ya concatené algo

    jmp .nextIteration

.fin:
    mov rax, r14 ;hash a retornar

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
