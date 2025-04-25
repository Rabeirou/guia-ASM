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
		mov dl, [rsi]
		cmp cl, dl
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
	push rbp
	mov rbp, rsp
	
	sub rsp, 8
	push rdi
	
	call strLen
	
	add rax, 1
	mov rcx, rax
	
	sub rsp, 8
	push rcx
	
	mov rdi, rax

	call malloc

	pop rcx
	add rsp, 8

	pop rdi

	push rax

	.ciclo:
		cmp rcx, 0
		jbe .fin
		mov dl, [rdi]
		mov byte [rax], dl
		inc rdi
		inc rax
		dec rcx
		jmp .ciclo

	.fin:

	pop rax

	add rsp, 8
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	push rbp
	mov rbp, rsp

	call free

	pop rbp
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
		mov dl, [rdi]
		cmp dl, 0
		je .fin
		add rdi, 1
		add rax, 1
		jmp .ciclo

	.fin:

	pop rbp
	ret


