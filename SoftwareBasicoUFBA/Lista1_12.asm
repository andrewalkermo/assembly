%include "asm_io.inc"

segment .data
f1 db 'Digite os 10 elementos: ',0
f2 db 'O maior elemento eh: ',0
f3 db 'O menor elemento eh: ',0
maior dd -1000000000 ; -10^9
menor dd 1000000000 ; 10^9
segment .bss

segment .text
        global  asm_main

asm_main:
	mov ecx,10
	mov ebx,0
	mov eax,f1
	call print_string
read:
	call read_int
	cmp eax,[maior]
	jle proxcomp
	mov [maior],eax
proxcomp:
	cmp eax,[menor]
	jge continua
	mov [menor],eax
continua:
	loop read

	mov eax,f2
	call print_string
	mov eax,[maior]
	call print_int
	call print_nl

	mov eax,f3
	call print_string
	mov eax,[menor]
	call print_int
	call print_nl
	
    leave                     
    ret
	