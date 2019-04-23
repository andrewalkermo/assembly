%include "asm_io.inc"

segment .data
arr times 10 dd 0
N dd 0
done dd 0
aux dd 0
segment .bss


segment .text
        global  asm_main

verify_Numbers:
    mov ebx,1
    mov [done],ebx
    mov ebx,0

start:
    cmp eax,0
    je finish

    mov ecx,10
    mov edx,0
    div ecx

    mov [arr + ebx],edx
    mov ecx,0

    checa_igual:
        cmp ecx,ebx
        je nextStep
		
        cmp edx,[arr+ecx]
        jne correct

        mov ecx,0
        mov [done],ecx
        jmp finish

        correct:
        add ecx,4
        jmp checa_igual

    nextStep:
    add ebx,4
    jmp start

finish:
    ret

asm_main:
    call read_int
    mov [N],eax
work:
    mov eax,[N]
    inc eax
    mov [N],eax
	call verify_Numbers
    mov ebx,0
    cmp [done],ebx
    je work
	
    mov eax,[N]
    call print_int
    call print_nl
    leave                     
    ret


