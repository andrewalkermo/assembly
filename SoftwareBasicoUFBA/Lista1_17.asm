%include "asm_io.inc"

segment .data
string times 15 db 0
f1 db 'Insira uma string de 15 caracteres: ',0
f2 db 'Insira a letra L1: ',0
f3 db 'Insira a letra L2: ',0
f4 db 'O resultado eh: ',0
l1 db 0
l2 db 0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov eax,f1
	call print_string
	mov ecx,15
	mov ebx,0
read:
	call read_char
	mov [string+ebx],al
	inc ebx
	loop read
	call read_char ; enter apos a primeira string

	mov eax,f2
	call print_string
	call read_char
	mov [l1],al
	call read_char ; enter apos o primeiro caractere
	
	mov eax,f3
	call print_string
	call read_char
	mov [l2], al
	call read_char ; ultimo enter

	mov eax,f4
	call print_string
	mov ecx,15
	mov ebx,0
ans:
	mov al,[string+ebx]
	cmp al,[l1]
	jne imprime
	mov al,[l2]
imprime:
	call print_char
	inc ebx
	loop ans
	call print_nl
    leave                     
    ret
	