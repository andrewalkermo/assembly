%include "asm_io.inc"

;
segment .data

    
prompt2 db    "par ", 0
prompt3 db    "impar ", 0

prompt0 db    "0", 0       
prompt1 db    "1", 0


segment .bss

input1  resd 1
segment .text
    global  asm_main


asm_main:
        enter   0,0               ; setup routine
        pusha
    ;input1

        call    read_int
        mov     [input1],eax
        mov     bx, [input1]

       
        mov ecx,16   
        
        convert:
            shl bx,1
            jc  One

            mov     eax, prompt0
            call    print_string


        jmp afterOne      ;retorna pra flag de inicio do loop
        
        One:                   ;se o valor for 1 e não 0
            mov     eax, prompt1
            call    print_string

        afterOne:         ;flag pro inicio do loop

        loop convert
        call    print_nl


        mov     eax,[input1]
        mov     ebx, 2
        cdq
        idiv    ebx
        mov     eax, edx
        cmp     edx,0
        jz      par
        cmp     eax,1
        jz      impar



par:
    mov     eax, prompt2
    call    print_string
    call    print_nl
    jmp     end

impar:
    mov     eax, prompt3
    call    print_string
    call    print_nl
      
   
 
end:      
    mov eax, 0
    leave
    ret

