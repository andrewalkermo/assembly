%include "asm_io.inc"
segment .data
;
; Mensagens do resultado
;
outmsg1 db    "Soma: ", 0
outmsg2 db    "Subtracao: ", 0
outmsg3 db    "Multiplicacao: ", 0
outmsg4 db    "Divisao: ", 0
outmsg5 db    "Resto da divisao: ", 0


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

        call    read_int          ; read integer
        mov     [input2], eax     ; store into input2
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;;;;;;;SOMA e IMPRIME;;;;;;;;;;;;;;;;;;;;;;;
        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax

        mov     eax, outmsg1
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;;;;;;;SUBTRAI e IMPRIME;;;;;;;;;;;;;;;;;;;

        mov     eax, [input1]     ; eax = dword at input1
        sub     eax, [input2]     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax

        mov     eax, outmsg2
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;;;;;;;MULTIPLICA e IMPRIME;;;;;;;;;;;;;;;

        mov     eax, [input1]     ; eax = dword at input1
        mov     ebx, [input2]     ; eax = dword at input1
        imul    ebx     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax

        mov     eax, outmsg3
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;DIVIDE e IMPRIME COM O RESTO;;;;;;;;;;;;;

        mov     eax, [input1]     ; eax = dword at input1
        cdq
        mov     ebx, [input2]     ; eax = dword at input1
        idiv    ebx     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax

        mov     eax, outmsg4
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line

        mov     eax, outmsg5
        call    print_string      ; print out third message
        mov     eax, edx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; next print out result message as series of steps
;



        popa
        mov     eax, 0            ; return back to C
        leave
        ret
