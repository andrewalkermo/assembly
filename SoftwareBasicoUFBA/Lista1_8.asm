%include "asm_io.inc"

segment .data
fib times 50 dd 0
segment .bss

segment .text
        global  asm_main

asm_main:
	call read_int ; obs N<=45
	mov ecx,1
	mov [fib], ecx ; f(0) = 1
	mov [fib+4], ecx; f(1) = 1

; casos base
	cmp eax,1
	je f1
	cmp eax,0
	je f1

	mov ecx,eax
	dec ecx
	mov ebx,8
calc:
	mov eax,0
	add eax,[fib+ebx-4]
	add eax,[fib+ebx-8]
	mov [fib+ebx],eax
	add ebx,4
	cmp ecx,0
	loop calc
print:
	call print_int
	call print_nl	
    leave                     
    ret

f1:
	mov eax,1
	jmp print
	