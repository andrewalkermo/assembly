;
;
; ██████╗ ██╗   ██╗██╗ ██████╗██╗  ██╗    ███████╗ ██████╗ ██████╗ ████████╗    ███╗   ██╗ █████╗ ███████╗███╗   ███╗
;██╔═══██╗██║   ██║██║██╔════╝██║ ██╔╝    ██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝    ████╗  ██║██╔══██╗██╔════╝████╗ ████║
;██║   ██║██║   ██║██║██║     █████╔╝     ███████╗██║   ██║██████╔╝   ██║       ██╔██╗ ██║███████║███████╗██╔████╔██║
;██║▄▄ ██║██║   ██║██║██║     ██╔═██╗     ╚════██║██║   ██║██╔══██╗   ██║       ██║╚██╗██║██╔══██║╚════██║██║╚██╔╝██║
;╚██████╔╝╚██████╔╝██║╚██████╗██║  ██╗    ███████║╚██████╔╝██║  ██║   ██║       ██║ ╚████║██║  ██║███████║██║ ╚═╝ ██║
; ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝
                                                                                                                    
;
;██████╗  ██████╗ ███╗   ██╗████████╗    ██████╗  █████╗ ███╗   ██╗██╗ ██████╗██╗
;██╔══██╗██╔═══██╗████╗  ██║╚══██╔══╝    ██╔══██╗██╔══██╗████╗  ██║██║██╔════╝██║
;██║  ██║██║   ██║██╔██╗ ██║   ██║       ██████╔╝███████║██╔██╗ ██║██║██║     ██║
;██║  ██║██║   ██║██║╚██╗██║   ██║       ██╔═══╝ ██╔══██║██║╚██╗██║██║██║     ╚═╝
;██████╔╝╚██████╔╝██║ ╚████║   ██║       ██║     ██║  ██║██║ ╚████║██║╚██████╗██╗
;╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝       ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝
;                                                                                




; Macro para auxiliar na impressão
%macro print 2
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro para auxiliar na leitura
%macro scan 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro para fim de programa
%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    vetor_entrada resb 200                                  ;vetor de bytes com a entrada em string
    vetor_numerico resd 200                                 ;vetor de double word para a ordenação em 
    char_atual resb 1                                       ;'variável' para auxiliar na impressão
    n resd 1                                                ;auxilia no tamanho da entrada
    
    
section .text
global _start

partition:
    enter 20,0                                              ;apesar de desnecessário, adotamos o mesmo padrão para evitar problemas
    mov eax, [ebp+8]                            
    mov ebx, [ebp+12]
    mov dword [ebp-4], ebx                                  ;ebp-4 tem o primeiro parâmetro (inferior)
    mov dword [ebp-8], eax                                  ;ebp-8 tem o segundo parâmetro  (superior)
    shl eax, 2                                              ;ultiplicapor 4, para pegar corretamente no vetor o valor
    mov ebx, [vetor_numerico+eax]
    mov dword [ebp-12], ebx                                 ;ebp-12 tem o valor do pivô, que é o último elemento
    mov eax, [ebp-4]
    sub eax, 1
    mov dword [ebp-16], eax                                 ;ebp-16 tem i
    mov eax, [ebp-4]
    mov dword [ebp-20], eax                                 ;ebp-20 tem j
    
    loop1:
        mov eax, [ebp-20]
        mov ebx, [ebp-8]
        sub ebx, 1
        cmp eax,ebx                                         ;aqui ele vai comparar o loop, no caso, se i é menor ou igual a valor superior passado. (dentro do for)
        jg fim_laco2
        
        mov eax, [ebp-20]
        shl eax, 2
        mov ebx, [vetor_numerico+eax]
        mov ecx, [ebp-12]
        cmp ebx, ecx                                        ;nesse ponto, ele compara o valor do pivô que tenho com o valor do vetor naquele momento de leitura
        jg inc_loop
        
        mov eax, [ebp-16]                           
        add eax, 1                                          ;se for menor ou igual, ele incrementa o valor de i e providencia o swap entre estes deois valores
        mov dword [ebp-16], eax
        
        
        ;---------------------------------------- swap
        mov eax, [ebp-16]
        mov ebx, [ebp-20]
        shl eax, 2
        shl ebx, 2
        mov ecx, [vetor_numerico+eax]
        mov edx, [vetor_numerico+ebx]
        mov dword [vetor_numerico+ebx], ecx
        mov dword [vetor_numerico+eax], edx
        ;---------------------------------------- swap
    
    inc_loop:                                               ;incrementa o laço for
        mov eax, [ebp-20]
        add eax, 1
        mov dword [ebp-20], eax
        jmp loop1
    
    fim_laco2:
    ;---------------------------------------- swap
    mov eax, [ebp-16]
    add eax, 1
    shl eax, 2
    mov ebx, [ebp-8]
    shl ebx, 2
    mov ecx, [vetor_numerico+eax]
    mov edx, [vetor_numerico+ebx]
    mov dword [vetor_numerico+ebx], ecx
    mov dword [vetor_numerico+eax], edx
    ;---------------------------------------- swap
    mov eax, [ebp-16]                                       ;move o retorno para a
    add eax, 1
    leave                                                   ;prepara para o retorno e volta 
    ret
    
quicksort:
    enter 12,0                                              ;salva o valor de ebp, move o valor de esp para ebp e reserva 12 bytes para variáveis
    mov ecx, [ebp + 8]
    mov ebx, [ebp + 12]
    mov dword [ebp-4], ebx                                  ;ebp-4 tem o inferior (primeiro parâmetro)
    mov dword [ebp-8], ecx                                  ;ebp-8 tem o superior (segundo parâmetro)
    cmp ebx, ecx                                            ;critêrio de parada da recursão: o primeiro parâmetro ser maior que o segundo
    jge fim_quicksort
    mov eax, [ebp-4]
    push eax                                                ;passa primeiro parâmetro para partition
    mov eax, [ebp-8]
    push eax                                                ;passa segundo parâmetro para partition
    call partition                                          ;chama partition
    pop ebx                                                 ;desempilha o que empilhou
    pop ebx                                                 ;desempilha o que empilhou
    mov dword [ebp-12], eax                                 ;pivô retornado pela partition encontra-se aqui
    mov eax, [ebp-4]
    push eax                                                ;empilha para recursãona primeira metade do vetor
    mov eax, [ebp-12]
    sub eax, 1
    push eax
    call quicksort                                          ;chamando do inferior até pivô-1
    pop eax
    pop eax
    
    mov eax, [ebp-12]
    add eax, 1
    push eax                                                
    mov eax, [ebp-8]
    push eax
    call quicksort                                          ;em seguida chama o quick indo de pivô+1 até o superior
    pop eax
    pop eax
    
    fim_quicksort:                                          ;retorna tudo ao normal e retorna 
    leave
    ret

_start:
    scan vetor_entrada, 200                                 ;lê entrada como no outro trabalho
    mov eax, 0x0
    mov ebx, 0x0
    mov ecx, 0x0
    mov edx, 0x0
    mov dword [n], eax                                      ;zera o tamanho
    
    leitura:
        mov al, [vetor_entrada + ebx]                       ;para cada entrada cataloga o que leu
        cmp al, 0xa                                         ;se quebra de linha, salta pro final
        je fim_laco
        cmp al, 0x20                                        ;se espaço, salta para o outro caractere
        je fim_espaco
        cmp al, 0x2d                                        ;se negativo, antecipa uma leitura, nega e salva no vetor convertendo de ascii para inteiro
        jne continua                                                
        add ebx, 1
        mov al, [vetor_entrada + ebx]
        add ebx, 1
        movsx eax, al
        sub eax,'0'
        neg eax
        mov dword [vetor_numerico + ecx], eax
        add ecx, 4
        mov edx, [n]                                        ;aqui atualiza o valor de n - tamanho
        add edx, 1
        mov dword [n], edx
        jmp leitura

    continua:                                               ;se positivo entra aqui. similar ao negativo, mas com a diferença de que não nega o número
        sub al,'0'
        movsx eax, al
        mov dword [vetor_numerico + ecx], eax
        add ecx, 4
        
        mov edx, [n]                                        ;aqui atualiza o valor de n - tamanho
        add edx, 1
        mov dword [n], edx
    
    fim_espaco:
        add ebx, 1
        jmp leitura

    
    fim_laco:                                                       
        mov eax, 0x0
        push eax                                            ;passa primeiro parâmetro, 0
        mov eax, [n]                        
        sub eax, 1
        push eax                                            ;passa segundo parâmetro, n-1 (tamanho do vetor no caso)
        call quicksort                                      ;aqui começa a 'mágica' do quicksort
        pop eax                                             ;ele vai desempilhar o que empilhou
        pop eax                                             ;denovo
        mov ebx, 0x0                                        ;zera ebx pra começar a impressão

    print_array:
        mov ecx, [vetor_numerico + ebx]                     ;ele lê elemento por elemento
        cmp ecx, 0
        jns positivo                                        ;verifica o sinal
        
        mov byte [char_atual],'-'                                   
        print char_atual, 1                                 ;se negativo, imprime o sinal e 
        neg ecx                                             ;nega o valor
    
    positivo:                                               ;ai imprime o valor absoluto do número
        add ecx, '0'
        mov byte [char_atual], cl
        print char_atual, 1
        add ebx, 4
        mov byte [char_atual], ' '                          ;imprime um espaço para auxiliar nos paranaê
        print char_atual, 1
        
        mov ecx, [n]
        shl ecx, 2                                          ;para verificar se é o fim do vetor, ele compara o tamanho do vetor (multiplicado por 4)
        cmp ebx, ecx                                        ;com a posição atual. Isso é para garantir que o vetor correu corretamente tudo
        jl print_array
        fim
    
