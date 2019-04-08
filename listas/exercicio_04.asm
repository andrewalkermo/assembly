%include "asm_io.inc"

segment .data

printpar db    "par", 0
printimpar db    "impar", 0

segment .bss
palavra
segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha

        call read_int





        popa
        leave
        ret
