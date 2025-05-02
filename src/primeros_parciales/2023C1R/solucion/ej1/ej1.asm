extern malloc
extern strcmp
global acumuladoPorCliente_asm
global en_blacklist_asm
global blacklistComercios_asm

PAGO_OFFSET EQU 24
PAGO_MONTO_OFFSET EQU 0
PAGO_COMERCIO_OFFSET EQU 8
PAGO_CLIENTE_OFFSET EQU 16
PAGO_APROBADO_OFFSET EQU 17

section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text


acumuladoPorCliente_asm:
	push rbp ;alineada
	mov rbp, rsp
	push r12
	push r13 ;alineada

	xor r12, r12 
	mov r12, rdi ;cantidadDePagos
	mov r13, rsi ;arr_pagos
	
	xor rdi, rdi
	mov rdi, 40
	call malloc ; rax = pagosPorCliente

	mov qword [rax], 0
	mov qword [rax + 8], 0
	mov qword [rax + 16], 0
	mov qword [rax + 24], 0
	mov qword [rax + 32], 0

	xor rdi, rdi ;i
.loop:
	cmp r12, rdi; i == cantidadDePagos?
	je .fin

	mov r8, rdi
	imul r8, PAGO_OFFSET
	mov sil, byte [r13 + r8 + PAGO_APROBADO_OFFSET] ;actual.aprobado
	cmp byte rsi, 0 ;actual.aprobado?
	je .nextIteration

	xor rcx, rcx
	mov cl, byte [r13 + r8 + PAGO_CLIENTE_OFFSET] ;actual.cliente
	xor rdx, rdx
	mov dl, byte [r13 + r8 + PAGO_MONTO_OFFSET] ;actual.monto
	add [rax + rcx * 4], edx ;pagosPorClienteActual += montoActual

.nextIteration:
	inc rdi
	jmp .loop

.fin:

	pop r13		
	pop r12
	pop rbp
	ret

en_blacklist_asm:
	push rbp ;alineada
	mov rbp, rsp
	push r12
	push r13 ;alineada
	push r14
	push r15 ;alineada

	mov r12, rdi ;guardo el valor de comercio
	mov r13, rsi ;guardo el valor de lista_comercios
	mov r14, rdx ;guardo el valor de n

	xor r15, r15 ;i = 0

.loop:
	cmp r15, r14 ;i == n?
	je .notFound

	mov rdi, r12
	mov rsi, [r13 + r15 * 8]
	call strcmp ;comercio == lista_comercios[i]?
	cmp rax, 0 ;strcpm == 0?
	je .found
	inc r15
	jmp .loop

.notFound:
	mov rax, 0
	jmp .fin

.found:
	mov rax, 1

.fin:
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

blacklistComercios_asm:
	push rbp ;alineada
	mov rbp, rsp
	push r12
	push r13 ;alineada
	push r14
	push r15 ;alineada
	push rbx
	sub rsp, 8 ;alineada

	mov r12, rdi ;cantidad_pagos
	mov r13, rsi ;arr_pagos
	mov r14, rdx ;arr_comercios
	mov r15, rcx ;size_comercios

	imul rdi, 8
	call malloc

	xor rbx, rbx ;i = 0
	xor rcx, rcx ;indice de mi array de retorno

.loop:
	cmp rbx, r12
	je .fin

	mov r8, rbx ; r8 = i
	imul r8, PAGO_OFFSET
	add r8, r13 ; r8 = &arr_pagos[i]

	mov rdi, [r8 + PAGO_COMERCIO_OFFSET] ;arr_pagos[i].comercio
	mov rsi, r14 ;arr_comercios
	mov rdx, r15 ;size_comercios

	push rax ;almaceno puntero a inicio de mi array de retorno
	push rcx ;alineada
	push r8
	sub rsp, 8 ;alineada

	call en_blacklist_asm
	mov r9, rax

	add rsp, 8
	pop r8
	pop rcx
	pop rax

	cmp r9, 1
	je .addToPagosRechazados

.nextIteration:
	inc rbx
	jmp .loop

.addToPagosRechazados:
	mov [rax + rcx * 8], r8
	inc rcx
	jmp .nextIteration

.fin:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
