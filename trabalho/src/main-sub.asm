
%include "lib/asm_io.inc"

segment .data

    filename db "test.txt", 0
    buflen dw 2048

segment .bss

    ascii resd 6
    buffer resb 2048
    aux_caractere resd 0
    aux_frequencia resd 0

segment .text

    %include "lib/read_write_file.asm"
    global  asm_main

asm_main:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ecx, 6
    mov ebx, 0
    mov eax, 6
    inicializa:
        mov [ascii+(ebx*4)], eax
        inc ebx
        dec eax
        loop inicializa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; push filename
    ; push buffer
    ; push buflen
    ; call read_file
    ;
    ; mov esi, buffer
    ; add esp, 12
    ; cld
    ; print:
    ;     lodsb
    ;     cmp al, 0
    ;     je exit
    ;
    ;     mov edx, [ascii+((eax*4))]
    ;     inc edx
    ;     mov [ascii+((eax*4))], edx
    ;
    ;     jmp print
    ; exit:
    ;     call print_nl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx, 5
mov ebx, 0
i:

    mov edx, 0
    j:
        mov eax, ecx
        sub eax, ebx
        cmp edx, eax
        jge not_repeat_j
        repeat_j:
            mov eax, 'a'
            call print_char
            call print_nl
            mov eax, [ascii+(edx*4)]
            cmp eax, [ascii+(edx*4)+4]
            jle not_change
            change:
                mov eax, 'a'
                call print_char
                call print_nl
                mov eax, [ascii+(edx*4)]
                mov [aux_caractere], eax
                mov eax, [ascii+((edx*4)+4)]
                mov [ascii+(edx*4)], eax
                mov eax, [aux_caractere]
                mov [ascii+((edx*4)+4)], eax
            not_change:
            inc edx
            jmp j
        not_repeat_j:

    loop i
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ecx, 6
    mov ebx, 0
    saida:
        mov eax, [ascii+(ebx*4)]
        call print_int
        ; mov eax, '-'
        ; call print_char
        ; mov eax, [ascii+((ebx*4)+4)]
        ; call print_int
        call print_nl
        inc ebx
        loop saida

    call print_nl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    leave
    ret
