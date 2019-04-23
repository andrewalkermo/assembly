%include "asm_io.inc"

segment .data
f1 db 'Digite o primeiro elemento da PA: ',0
f2 db 'Digite a razao da PA: ',0
f3 db 'Digite quantos elementos voce quer(>=1): ',0
space db ' ',0
val dd 0
raz dd 0
quant dd 0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov eax,f1
	call print_string
	call read_int
	mov [val],eax

	mov eax,f2
	call print_string
	call read_int
	mov [raz],eax

	mov eax,f3
	call print_string
	call read_int
	mov [quant],eax
	
	mov ecx,[quant]
lp:
	mov eax,[val]
	call print_int
	mov eax,space
	call print_string
	mov eax,[raz]
	add [val],eax
	loop lp
	call print_nl
    leave                     
    ret

	