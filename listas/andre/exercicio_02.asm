%include "asm_io.inc"
segment .data
;
; Mensagens do resultado
;
one db    "1", 0

;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input  resd 1
; result  resd 1

segment .text
        global  asm_main
asm_main:
        ;;;;;;;;;;;;;;;;;;LEITURA;;;;;;;;;;;;;;;;;;;;;;;;;;
        enter   0,0
        pusha

        call    read_int
        mov     [input], eax

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov     eax, [input]
        cmp     eax, 0
        jz      printone           ;Imprime 1 para entrada = 1
        cmp     eax, 1
        jz      printone           ;Imprime 1 para entrada = 1

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov     ecx, [input]                                  ;decrementa um do contador/multiplicador do fatorial , fazendo também o 'do' do 'while'
        dec     ecx
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fatorial:                           ;loop que faz o calculo de fatorial e deixa o resultado em eax | ja começa com: se n! eax = n, ecx = n-1
        mul     ecx                 ; multiplica o montante atual de fatorial que esta em eax por ecx que contem o multiplicador atual de fatorial
        cmp     ecx, 2              ;compara se o contador/multiplicador é igual a 2 | sempre para quando fatorial esta multiplicando por 2
        loopne    fatorial          ;repete laço caso ecx seja maior que 2
        jmp     printresult         ;sai do loop e pula para o final

printresult:                        ;imprime o resultado de fatorial que esta em eax
        call    print_int
        call    print_nl
        jmp     then
printone:                           ;imprime '1' | apenas nos casos onde a entrada é igual a 0 ou 1
        mov     eax, one
        call    print_string
        call    print_nl
then:

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        popa
        mov     eax, 0            ; return back to C
        leave
        ret
