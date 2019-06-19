
%include "lib/asm_io.inc"

segment .data

    cabo db "cabo", 0
    filename db "test.txt", 0
    buflen dw 2048
    ascii times 300 db 0
segment .bss

    buffer resb 2048

segment .text

    %include "lib/read_write_file.asm"
    global  asm_main

asm_main:

    push filename
    push buffer
    push buflen
    call read_file

    mov esi, buffer
    add esp, 12
    cld
    print:
        lodsb
        cmp al, 0
        je exit
        
        mov edx, [ascii+eax]
        inc edx
        mov [ascii+eax], edx
        jmp print
    exit:
        call print_nl

    mov ecx, 256                     ;define o tamanho do loop de saida
    mov ebx, 0                      ;defne o contador que irá percorrer o vetor
    saida:
        ; mov eax, ebx                     ;incrementa contador
        mov eax, [ascii+ebx]      ;move para eax cada caractere do vetor
        call print_int
        mov eax, '-'
        call print_char             ;imprime cada caractere d vetor
        mov eax, ebx
        call print_int             ;imprime cada caractere d vetor
        call print_nl

        inc ebx
        loop saida                  ;repete o loop

    call print_nl                   ;imprime a quebra de linha


    leave
    ret
