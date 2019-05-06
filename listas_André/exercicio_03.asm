%include "asm_io.inc"

segment .data                         ;sessão de variaveis inicializadas

printpar db    "par", 0
printimpar db    "impar", 0

segment .bss                          ;sessão de variaveis não inicializadas

segment .text                         ;sessão de codigos
        global  asm_main
asm_main:
        enter   0,0                   ;Cria um quadro de pilha (composto por espaço para armazenamento dinâmico e armazenamento de ponteiro de quadro 1-32) para um procedimento.
        pusha                         ;empilha os registradores comuns na pilha

        call read_int                 ;lê inteiro
        mov ecx,16                    ;quantidade de vezes que o loop vai rodar
        shl eax,16                    ;apaga os 16 digitos mais relevantes do numero para trabalhar apenas com numeros representados por 16 bits
        mov ebx,eax                   ;salva o valor de eax em ebx

        start:
            xor eax,eax               ;zera o valor de eax
            shl ebx,1                 ;desloca para esquerda bit de ebx e salva em CF
            adc eax,0                 ;eax = eax + 0 + CF | salva o valor de CF em eax
            call print_int            ;imprime o bit que foi deslocado de ebx e que agora esta em eax
        loop start                    ;repete o loop por mais 15 vezes
        call print_nl                 ;imprime nova linha
        cmp   eax, 1                  ;verifica se digito menos relevante é igual a um, implicando numa sequencia binaria representando um numero decimal impar
        jz impar                      ;pula para impar caso eax=1 (o numero seja impar), do contrario apenas continua

        par:
            mov     eax, printpar     ;move "par" para eax
            jmp     end               ;pula para o fim, evitando que imprima "impar"
        impar:
            mov     eax, printimpar   ;move "impar" para eax
        end:
            call    print_string      ;imprime conteudo de eax
            call print_nl             ;imprime nova linha

        popa                          ;desempilha os registradores comuns na pilha
        leave                         ;Libera o quadro de pilha configurado pela instrucao ENTER anterior.
        ret                           ;Transfere o controle do programa para um endereço de retorno localizado no topo da pilha.
