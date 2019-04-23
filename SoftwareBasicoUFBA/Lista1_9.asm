%include "asm_io.inc"

segment .data
xx db ' Anos',0
segment .bss

segment .text
        global  asm_main

asm_main:
	mov eax,0
	mov ebx,150 ; anacleto
	mov ecx,110 ; felisberto
proxAno:
	inc eax
	add ebx,2
	add ecx,3
	cmp ebx,ecx
	jge proxAno
	call print_int
	mov eax,xx
	call print_string
	call print_nl
    leave                     
    ret

	