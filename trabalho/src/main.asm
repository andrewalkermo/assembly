
%include "lib/asm_io.inc"

segment .data

    cabo db "cabo", 0
    filename db "test.txt", 0
    buflen dw 2048
    ; ascii times 512 dd 0
segment .bss
    ascii resd 512
    buffer resb 2048

segment .text

    %include "lib/read_write_file.asm"
    global  asm_main

asm_main:

    mov ecx, 256
    mov ebx, 0
    inicializa:
        imul edx, ebx, 8
        mov [ascii+edx], ebx
        add edx, 4
        mov eax, 0
        mov [ascii+edx], eax
        inc ebx
        loop inicializa
    call print_nl


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
        imul ecx, eax, 8
        add ecx, 4
        mov edx, [ascii+ecx]
        inc edx
        mov [ascii+ecx], edx
        jmp print
    exit:
        call print_nl



    mov ecx, 256
    mov ebx, 0
    saida:

        imul edx, ebx, 8
        mov eax, [ascii+edx]
        call print_int
        mov eax, '-'
        call print_char
        ; mov eax, ebx
        add edx, 4
        mov eax, [ascii+edx]
        call print_int
        call print_nl

        inc ebx
        loop saida

    call print_nl


    leave
    ret
