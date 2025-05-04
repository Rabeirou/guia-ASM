global agrupar
extern malloc
extern strcmp
extern str_concat
extern free

%define MAX_TAGS 4

MSG_OFFSET EQU 24
MSG_TEXT_OFFSET EQU 0
MSG_TEXT_LEN_OFFSET EQU 8
MSG_TAG_OFFSET EQU 16


;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

agrupar:
    ;msgArr -> rdi
    ;msgArr_len -> rsi
    push rbp ;alineada
    mov rbp, rsp
    push r12
    push r13 ;alineada
    push r14
    push r15 ;alineada
    push rbx
    sub rsp, 8

    mov r12, rdi ;msgArr
    mov r13, rsi ;msgArr_len

    mov rdi, MAX_TAGS
    imul rdi, 8
    call malloc ;llamo a malloc pidiendo 8*MAX_TAGS bytes de espacio
    mov r14, rax ;arrMsgConcatenados

    xor rdi, rdi ;i = 0
.loopInitializeStrings:
    cmp rdi, MAX_TAGS ;i == MAX_TAGS?
    je .continue

    mov qword [r14 + rdi * 8], 0 ;arrMsgConcatenados[i] = ""
    inc rdi
    jmp .loopInitializeStrings

.continue:
    xor r15, r15 ;i = 0
.loop:
    cmp r15, r13 ;i == masArr_len?
    je .fin

    xor r8, r8 ;limpio r8
    mov r8, r15 ;r8 = i
    imul r8, MSG_OFFSET ;r8 = i * 24
    add r8, r12 ;r8 = i * 24 + msgArr

    xor rbx, rbx
    mov ebx, [r8 + MSG_TAG_OFFSET] ;msgArr[i]->tag
    mov rsi, [r8 + MSG_TEXT_OFFSET] ;msgArr[i]->text

    mov rdi, [r14 + rbx * 8] ;arrMsgConcatenados[msgArr[i]]

    cmp rdi, 0
    je .addFirstString

.concatStrings:
    push rdi
    sub rsp, 8 ;alineada

    call str_concat ;newText = arrMsgConcatenados[i] + msgArr[i]->text

    mov [r14 + rbx * 8], rax ;arrMsgConcatenados[msgArr[i]->tag] = newText

    add rsp, 8
    pop rdi
    call free ;libero memoria de string concatenado previo

.nextIteration:
    inc r15
    jmp .loop

.addFirstString:
    call str_concat ;newText = "" + msgArr[i]->text esto lo hago para poder hacer free despues
    mov [r14 + rbx * 8], rax ;arrMsgConcatenados[msgArr[i]->tag] = msgArr[i]->text
    jmp .nextIteration

.fin:
    mov rax, r14

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

