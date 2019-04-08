%include "asm_io.inc"

;
segment .data


prompt0 db    "0", 0       
prompt1 db    "1", 0
barra   dd      '/'


segment .bss

vetor resb 11


segment .text

    global  asm_main


asm_main:
    enter   0,0               ; setup routine
    pusha

    mov ebx, 0
    mov ecx, 10

    lp:

    call read_char
    mov [vetor+ebx],al
    add ebx,1
    

    loop lp



   
 
end:      
    mov eax, 0
    leave
    ret

