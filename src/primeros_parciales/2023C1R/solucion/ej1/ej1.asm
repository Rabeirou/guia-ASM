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
	
	mov rdi, PAGO_OFFSET
	imul rdi, 10
	call malloc ; rax = pagosPorCliente

	mov rdi, 0 ;i
.loop:
	cmp r12, rdi; i == cantidadDePagos?
	je .fin

	imul rdi, 16
	mov rsi, [r13 + rdi] ;actual
	cmp byte [rsi + PAGO_APROBADO_OFFSET], 0 ;actual.aprobado?
	je .nextIteration

	xor rcx, rcx
	mov cl, byte [rsi + PAGO_CLIENTE_OFFSET] ;actual.cliente
	xor rdx, rdx
	mov dl, byte [rsi + PAGO_MONTO_OFFSET] ;actual.monto
	add [rax + rcx], rdx ;pagosPorClienteActual += montoActual

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
