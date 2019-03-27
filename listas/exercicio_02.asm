%include "asm_io.inc"
segment .data
;
; Mensagens do resultado
;
one db    "1!", 0



;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input1  resd 1
input2  resd 1



;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        ;;;;;;;;;;;;;;;;;;LEITURA;;;;;;;;;;;;;;;;;;;;;;;;;;
        enter   0,0               ; setup routine
        pusha

        call    read_int          ; read integer
        mov     [input1], eax     ; store into input1

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;;;;;;;SOMA e IMPRIME;;;;;;;;;;;;;;;;;;;;;;;
        mov     eax, [input1]     ; eax = dword at input1
        cmp     eax, 0
        jz      prinone

prinone:
        mov     eax, one
        call    print_string      ; print out third message
        call    print_nl      ; print out third message

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



        popa
        mov     eax, 0            ; return back to C
        leave
        ret
