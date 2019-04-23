%include "asm_io.inc"

segment .data

segment .bss

segment .text
        global  asm_main
asm_main:
    
	mov ecx,100
	mov eax,100
lp:
	mov ebx,eax
	AND ebx,1
	cmp ebx,1
	jne par
impar:
    call print_int
    call print_nl
par:
	inc eax
	loop lp

    leave                     
    ret
