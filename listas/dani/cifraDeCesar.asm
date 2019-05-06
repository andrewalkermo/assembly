%include "asm_io.inc"

;
segment .data

segment .bss

vetor resb 11
k     resb  1

segment .text

    global  asm_main

asm_main:
    enter   0,0               ; setup routine
    pusha

    mov ebx, 0
    mov ecx, 10

    call read_int                  
    mov [k], eax                   
    call read_char                


    loop_read:
        call read_char
        add al, [k]
        cmp al,90
        jg passed
        jmp notPassed

    passed:
        sub al,26
        mov [vetor+ebx],al
        call print_char 
        add ebx,1
        loop loop_read

   notPassed:
        call print_char
        add ebx, 1
        loop loop_read


    call    print_nl
  
       

end:

    mov eax, 0
    leave
    ret

