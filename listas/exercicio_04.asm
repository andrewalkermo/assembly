%include "asm_io.inc"

segment .data

segment .bss
palavra     resb    10
k           resb    1
segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha


        call read_int                   ;lê o valor de k
        mov [k], eax                    ;move para k
        call read_char                  ;descarda o \n lido para não entrar no vetor

        mov ecx, 10                     ;define o numero de voltar do loop leitura
        mov ebx, 0                      ;defne o contador que irá percorrer o vetor
        leitura:
            call read_char              ;lê cada caractere da sequencia
            add al, [k]                 ;incrementa o valor de k na em al, resultando em outra letra da tabela asc
            cmp al, 91                  ;compara para ver se ja passou de z
            jc antesz                   ;pula caso tenha passado de z
            depoisz:
              sub al, 26                ;subitrai 26 de al caso tenha passado de z
            antesz:
              mov [palavra+ebx], al     ;salva letra dentro do vetor
              inc ebx                   ;incrementa posicao do vetor
              loop leitura              ;perete o loop

        mov ecx, 10                     ;define o tamanho do loop de saida
        mov ebx, 0                      ;defne o contador que irá percorrer o vetor
        saida:
            mov eax, [palavra+ebx]      ;move para eax cada caractere do vetor
            call print_char             ;imprime cada caractere d vetor
            inc ebx                     ;incrementa contador
            loop saida                  ;repete o loop

        call print_nl                   ;imprime a quebra de linha

        popa
        leave
        ret
