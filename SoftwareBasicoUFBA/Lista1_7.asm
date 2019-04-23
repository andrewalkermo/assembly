%include "asm_io.inc"

segment .data
segment .bss

segment .text
        global  asm_main

asm_main:

do:
	inc eax
	cmp eax,ecx
	jne else
	if:
		mov edx,10
		jmp while
	else:
		mov edx,20
while:
	cmp eax,ebx
	jg do

    leave                     
    ret
