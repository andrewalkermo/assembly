%include "asm_io.inc"

segment .data

printpar db    "par", 0
printimpar db    "impar", 0

segment .bss
palavra     resb    10
segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha
        mov     ecx, 9
        leitura:
            call read_char
            mov [palavra+ecx], al
            loop leitura

        mov ecx, 9
        mov ebx, 0

        saida:
            mov eax, [palavra+ebx]
            call print_char
            call print_nl
            inc ebx
            loop saida
        popa
        leave
        ret
