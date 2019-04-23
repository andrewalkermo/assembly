%include "asm_io.inc"

segment .data

segment .bss

segment .text
        global  asm_main
asm_main:
    call read_int ; basta apenas aplicar o complemento de 2, inverte todos os bits e soma 1
	not eax ; poderiamos usar neg em vez de not + 1, porem a questao pede operacoes de bit
	inc eax
	call print_int
	call print_nl
    leave                     
    ret
