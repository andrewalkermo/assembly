%include "asm_io.inc"

segment .data
aux dd 0
segment .bss

segment .text
        global  asm_main
asm_main:
    ; obs, n^m <= 2^32 e m>=0
	call read_int
	mov ebx,eax
	call read_int
	mov ecx,eax
	mov eax,ebx
	cmp eax,1
	je final
	cmp ecx,1
	je final
	cmp ecx,0
	je final2
	dec ecx
lp:
	mul ebx
	loop lp
final:    
    call print_int
    call print_nl

    leave                     
    ret
final2:
	mov eax,1
	jmp final