extern malloc
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
	
	mov rdi, 4
	imul rdi, 10
	call malloc ; rax = pagosPorCliente

	mov rdi, 0 ;i
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
	add [rax + rcx * 4], rdx ;pagosPorClienteActual += montoActual

.nextIteration:
	inc rdi
	jmp .loop

.fin:

	pop r13		
	pop r12
	pop rbp
	ret

en_blacklist_asm:
	ret

blacklistComercios_asm:
	ret
