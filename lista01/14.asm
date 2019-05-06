%include "asm_io.inc"

segment .data
f1 db 'Digite os 10 elementos (1<=ai<=2^31): ',0
f2 db 'Os numeros primos do vetor sao: ',0
space db ' ',0
arr times 10 dd 0
x dd 0
boolean dd 0
end dd 0
segment .bss

segment .text
        global  asm_main
isprime:
	mov eax,[arr+ebx]
	mov [x],ebx
	mov [end],eax
	cmp eax,2
	je true
	cmp eax,1
	je false
	mov ebx,2
lp:
	mov eax,ebx
	mul eax
	cmp eax,[end]
	jg true
	mov eax,[end]
	mov edx,0
	div ebx
	cmp edx,0
	je false
	inc ebx
	jmp lp

true:
	mov eax,1
	mov [boolean],eax
	jmp final
false:
	mov eax,0
	mov [boolean],eax
final:
	ret

asm_main:
	mov eax,f1
	call print_string
	mov ecx,10
	mov ebx,0
read:
	call read_int
	mov [arr+ebx],eax
	add ebx,4
	loop read
	mov ecx,10
	mov ebx,0
	mov eax,f2
	call print_string
	call print_nl
check:
	call isprime
	mov edx,[boolean]
	cmp edx,0
	je nx
	mov eax,[end]
	call print_int
	mov eax,space
	call print_string
nx:
	mov ebx,[x]
	add ebx,4
	loop check
	call print_nl
    leave                     
    ret
	