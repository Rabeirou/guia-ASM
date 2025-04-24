extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a -> rdi
; b -> rsi
strCmp:
	push rbp
	mov rbp, rsp

	cmp rdi, 0
	jz .fin
	cmp rsi, 0
	jz .fin

	mov rax, 0

	.ciclo:
		mov cl, [rdi]
		mov bl, [rsi]
		cmp cl, bl
		jb .menor
		jg .mayor
		add rdi, 1
		add rsi, 1
		cmp cl, 0
		jz .fin
		jmp .ciclo

	.menor:
		mov rax, 1	
		jmp .fin

	.mayor:
		mov rax, -1	
		jmp .fin

	.fin:

	pop rbp
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
; a -> rdi
strLen:
	push rbp
	mov rbp, rsp

	mov rax, 0 ;inicializo contador en 0

	cmp rdi, 0 ;checkeo que el puntero no sea null
	jz .fin

	.ciclo:
		mov bl, [rdi]
		cmp bl, 0
		je .fin
		add rdi, 1
		add rax, 1
		jmp .ciclo

	.fin:

	pop rbp
	ret


