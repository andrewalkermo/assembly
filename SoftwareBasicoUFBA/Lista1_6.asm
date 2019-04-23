%include "asm_io.inc"

segment .data
Resultado dd 0
segment .bss

segment .text
        global  asm_main

eleva_2:
	mov eax,1
lp:
	cmp ebx,0
	je final
	mov edx,2
	mul edx
	dec ebx
	jmp lp
final:
	ret

asm_main:
    mov ecx,8
	
read:
	call read_char

	cmp al,'1'
	jne nxt
	mov ebx,ecx
	dec ebx
	call eleva_2
	add [Resultado],eax
nxt:
	loop read
	mov eax,[Resultado]
	call print_int
	call print_nl
    leave                     
    ret
