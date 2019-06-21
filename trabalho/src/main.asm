
%include "lib/asm_io.inc"

segment .data

    indice db "INDEX: ", 0
    caractere db "CARACTERE: ", 0
    frequencia db "FREQUENCIA: ", 0
    separador db " | ", 0

    filename db "test.txt", 0
    buflen dw 2048

segment .bss

    ascii resd 512
    buffer resb 2048
    aux_caractere resd 0
    aux_frequencia resd 0

segment .text

    %include "lib/read_write_file.asm"
    global  asm_main

asm_main:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ecx, 256
    mov ebx, 0
    mov eax, 0
    inicializa:
        mov [ascii+(ebx*8)], ebx
        mov [ascii+((ebx*8)+4)], eax
        inc ebx
        loop inicializa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

        mov edx, [ascii+((eax*8)+4)]
        inc edx
        mov [ascii+((eax*8)+4)], edx

        jmp print
    exit:
        call print_nl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx, 255
mov ebx, 0
i:
    mov edx, 0
    j:
        mov eax, ecx
        sub eax, ebx
        cmp edx, eax
        jge not_repeat_j
        repeat_j:
            mov eax, [ascii+(edx*8)+4]
            cmp eax, [ascii+(edx*8)+12]
            jle not_change
            change:
                mov eax, [ascii+(edx*8)]
                mov [aux_caractere], eax

                mov eax, [ascii+((edx*8)+8)]
                mov [ascii+(edx*8)], eax
                mov eax, [aux_caractere]
                mov [ascii+((edx*8)+8)], eax

                mov eax, [ascii+((edx*8)+4)]
                mov [aux_frequencia], eax

                mov eax, [ascii+((edx*8)+12)]
                mov [ascii+(edx*8)+4], eax
                mov eax, [aux_frequencia]
                mov [ascii+((edx*8)+12)], eax

            not_change:
            inc edx
            jmp j
        not_repeat_j:
    loop i
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ecx, 256
    mov ebx, 0
    saida:
        mov eax, [ascii+((ebx*8)+4)]
        cmp eax, 0
        je nao_imprime
        imprime:
            mov eax, indice ;
            call print_string ;

            mov eax, ebx
            call print_int

            mov eax, separador ;
            call print_string ;

            mov eax, caractere ;
            call print_string ;

            mov eax, [ascii+(ebx*8)]
            call print_int

            mov eax, separador ;
            call print_string ;

            mov eax, frequencia ;
            call print_string ;

            mov eax, [ascii+((ebx*8)+4)]
            call print_int

            call print_nl
        nao_imprime:
        inc ebx
        loop saida

    call print_nl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    leave
    ret
