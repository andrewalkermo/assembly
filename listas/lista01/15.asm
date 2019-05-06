%include "asm_io.inc"

segment .data
f1 db 'Insira a matriz(3x3): ',0
f2 db 'A soma da diagonal principal eh: ',0
matriz times 9 dd 0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov eax,f1
	call print_string
	call print_nl
	mov ecx,9
	mov ebx,0
read:
	call read_int
	mov [matriz+ebx],eax
	add ebx,4
	loop read
	mov eax,f2
	call print_string
	mov eax,0
	;matriz[0][0] = 3*0 + 0, matriz[1][1] = 3*1 + 1, matriz[2][2] = 3*2 + 2
	add eax,[matriz]
	add eax,[matriz+16]
	add eax,[matriz+32]
	call print_int
	call print_nl
    leave                     
    ret
	