%include "asm_io.inc"

segment .data
aux dd 0
segment .bss

segment .text
        global  asm_main
asm_main:
    call read_int
	sub eax,32
	mov ebx,5
	imul ebx ; usei imul e idiv para aceitar numeros negativos em fahrenheit tb
	mov ebx,9
	idiv ebx
    call print_int
    call print_nl

    leave                     
    ret
