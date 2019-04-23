%include "asm_io.inc"

segment .data
arr times 8 dd 0
resp dd 0
f1 db 'Digite os 8 elementos: ',0
f2 db 'Digite a primeira posicao(1<=P<=8): ',0
f3 db 'Digite a segunda posicao(1<=P<=8): ',0
f4 db 'O resultado eh: ',0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov ecx,8
	mov ebx,0
	mov eax,f1
	call print_string
read:
	call read_int
	mov [arr+ebx],eax
	add ebx,4
	loop read
	mov ebx,4

	mov eax,f2
	call print_string
	call read_int
	mul ebx
	sub eax,4
	mov eax,[arr+eax]
	add [resp],eax

	mov eax,f3
	call print_string
	call read_int
	mul ebx
	sub eax,4
	mov eax,[arr+eax]
	add [resp],eax

	mov eax,f4
	call print_string

	mov eax,[resp]
	call print_int
	call print_nl
    leave                     
    ret

	