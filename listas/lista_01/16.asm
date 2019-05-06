%include "asm_io.inc"

segment .data
string times 10 db 0
f1 db 'Insira uma string de 10 caracteres: ',0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov ecx,10
	mov ebx,0
	mov eax,f1
	call print_string
lp:
	call read_char
	mov [string+ebx],al
	movzx eax,al
	inc ebx
	loop lp
	
	mov ecx,10
	mov ebx,0
ans:
	mov al,[string+ebx]
	cmp al,'a'
	je continua
	cmp al,'e'
	je continua
	cmp al,'i'
	je continua
	cmp al,'o'
	je continua
	cmp al,'u'
	je continua	
imprime:
	call print_char
continua:
	inc ebx
	loop ans
	call print_nl
    leave                     
    ret
	