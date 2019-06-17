;https://www.jdoodle.com/compile-assembler-nasm-online

; Macro criada para imprimir dados na tela
%macro imprima 2
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro criada para ler os dados de entrada
%macro leia 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro para verificar se a pilha está vazia ou não
%macro verifica_pilha 0
    pushad
    mov ecx, [topo_pilha]
    cmp esp, ecx
    je msg_erro
    popad
%endmacro

; Macro criada para finalizar a execução do programa
%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    topo_pilha resd 1                   ;variavel que armazena o valor do topo da pilha no inicio da execução do programa
    expressao_pos resb 200              ;variavel que armazena a expressao pos-fixa
    contador resd 1                     ;contador
    expressao resb 200                  ;variavel que armazena a expressao infixa
    i resw 1                            ;contador
    char_atual resb 1                   ;variavel para armazenar um caracter por vez durante as operações
    auxiliar resb 1                     ;Variavel auxiliar para manipular n conversão de infixa para pos fixa

section .data
    ; Declaração das mensagens a serem exibidas
    msg_com_erro db "Erro de formatação"
    len1 equ $ - msg_com_erro
    msg_sem_erro db "Bem formatada"
    len2 equ $ - msg_sem_erro

section .text
    global _start

_start:
    mov dword [topo_pilha], esp         ;Guarda o endereço inicial do topo da pilha
    leia expressao, 200                 ;Ler os dados de entrada
    mov dword [contador], 0x0           ;Zera um contador
    mov ebx, 0x0                        ;Zera o registrador ebx, que será utilizado como contador
    mov [i], ebx                        ;Move o registrador ebx para a variavel (contador) 'i'
    jmp add_parenteses                  ;Adiciona parenteses no inicio e no fim da expressao e verifica se esta bem formada

; Iniciao loop para converter de infixa para pos-fixa
volta_inicio:
    ;mov eax, 0x0                        ;Zera o registrador eax //TODO
    mov al, [expressao + ebx]            ;Move para al o primeiro caracter da expressao
    add ebx, 1                           ;Incrementa ebx
    mov byte [char_atual], al            ;Move o caracter que está armazenado em al para a variavel char_atual
    cmp al, 0xa                          ;Verifica se é o fim da expressao
    je o_fim_conversao                   ;Caso seja o fim da expressao, segue para o proximo passo
    ;Nestre trecho é verificado se o caracter atual é um operador ou um parenteses
    cmp al, '('
    je par_abr
    cmp al,')'
    je par_fec
    cmp al, '+'
    je mais_ou_menos
    cmp al, '-'
    je mais_ou_menos
    cmp al, '*'
    je mult_ou_div
    cmp al, '/'
    je mult_ou_div
    ; Caso o caracter atual seja um valor númerico, ele é inserido na variavel expressao_pos
    ;------------------------
    mov dword edx, [contador]               ;Resgata o valor do contador
    mov al, [char_atual]                    ;Move o valor da variavel char_atual para al
    mov byte [expressao_pos + edx], al      ;Move al para expressao_pos
    inc edx                                 ;Incrementa o contador
    mov dword [contador], edx               ;Guarda o valor do contador na variavel
    ;------------------------
    jmp volta_inicio                        ; Volta para o inicio do loop

;------------------
add_parenteses:
    ;O registrador ebx já está zerado
    mov al, [expressao + ebx]               ;Move para al o valor do primeiro caracter
    add ebx, 1                              ;Incrementa o registrador ebx (contador)
    cmp al, '('
    je push_parenteses
    cmp al, ')'
    je pop_parenteses

end_push_parenteses:
end_pop_parenteses:
    cmp al, 0xa                             ;Compara para saber se é fim de linha
    jne add_parenteses                      ;Caso não seja fim de linha, volta para o início do loop
    
    mov eax, [topo_pilha]                   ;Resgata o valor do topo da pilha no inicio da execução do programa
    cmp esp, eax                            ;Compara com valor do topo da pilha no instante atual
    jne msg_erro                            ;Se tiverem valores diferentes, é encaminhada para mensagem de erro
    
    sub ebx, 1                              ;Decrementa ebx (contador) para resgatar o caracter anterior
    mov al, ')'
    mov [expressao + ebx], al               ;Adiciona um ')' no fim da expressao
    add ebx, 1                              ;Incrementa o registrador ebx (contador)
    mov al, 0xa
    mov [expressao + ebx], al               ;Adiciona uma "quebra de linha" no fim da expressao
    mov ebx, 0x0                            ;Zera o registrador ebx
    mov eax, '('
    push eax                                ;Adiciona o '(' no inicio da pilha
    jmp volta_inicio                        ;Volta para o inicio do programa
push_parenteses:
    push eax
    jmp end_push_parenteses

pop_parenteses:                             ;Verifica se existe algum elemento na pilha
    verifica_pilha                          ;Verifica a situação da pilha
    pop ecx
    jmp end_pop_parenteses
;------------------
;Quando o caracter atual é um '(', ele é empilhado
par_abr:
    mov eax, [char_atual]
    push eax
    jmp volta_inicio

;------------------
par_fec:
    verifica_pilha                          ;Verifica a situação da pilha
    pop ecx                                 ;Desempilha o valor do topo da pilha
    cmp cl,'('                              ;Compara o valor desempilhado com o caracter '('
    je volta_inicio                         ;Volta para o inicio caso sejam iguais
    mov byte [auxiliar], cl                 ;Move o caracter desempilhado para uma variavel auxiliar
    ;------------------------
    ;Adiciona esse caracter em um vetor e incrementa seu contador
    mov dword edx, [contador]
    mov al, [auxiliar]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    jmp par_fec                             ;Volta para o inicio dessa label
    
;------------------
mais_ou_menos:
    verifica_pilha                          ;Verifica a situação da pilha
    pop ecx                                 ;Desempilha o valor do topo da pilha
    cmp cl, '('                             ;Compara o valor desempilhado com o caracter '('
    je fim_mais_ou_menos                    ;Vai para a label que finaliza essa tarefa
    mov [auxiliar], cl                      ;Move o caracter desempilhado para uma variavel auxiliar
    ;------------------------
    ;Adiciona esse caracter em um vetor e incrementa seu contador
    mov dword edx, [contador]
    mov al, [auxiliar]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    jmp mais_ou_menos                       ;Volta para o inicio dessa label
    
;------------------
fim_mais_ou_menos:
    mov ecx, '('
    push ecx                                ;Empilha o caracter '('
    mov ecx, [char_atual]
    push ecx                                ;Empilha o caracter atual
    jmp volta_inicio                        ;Volta para o inicio

;------------------
mult_ou_div:
    verifica_pilha                          ;Verifica a situação da pilha
    pop ecx                                 ;Desempilha o valor do topo da pilha
    ;Verifica se o caracter desempilhado é diferente de '(', '+' ou '-'
    cmp cl, '('
    je fim_mult_ou_div
    cmp cl, '+'
    je fim_mult_ou_div
    cmp cl, '-'
    je fim_mult_ou_div
    mov [auxiliar], cl
    ;------------------------
    ;Adiciona esse caracter em um vetor e Incrementa seu contador
    mov dword edx, [contador]
    mov al, [auxiliar]
    mov byte [expressao_pos + edx], al
    inc edx
    mov dword [contador],edx
    ;------------------------
    jmp mult_ou_div                         ;Volta para o inicio dessa label

fim_mult_ou_div:
    push ecx                                ; Empilha novamente o último caracter desempilhado na label anterior
    mov ecx, [char_atual]
    push ecx                                ;Empilha o caracter atual
    jmp volta_inicio                        ;Volta para o inicio
    
;------------------
o_fim_conversao:
    mov eax, [topo_pilha]
    cmp eax, esp
    jne msg_erro                            ;encaminha para mensagem de erro
    ;----------------------------
    mov eax, [contador]                     ;eax é usado como contador (para saber o total de espaços utilizaods na pilha)
    mov ecx, 0x0                            ;ecx é usado como 'i' e como pilha
    mov [i], ecx

;------------------------
; Trecho que percorre a expressão pós fixa e efetua as operações
check_operator:
    mov eax, [contador]
    mov ecx, [i]
    cmp ecx, eax                            ;Verifica se chegou no fim do vetor de caracter
    je empilha_result                       ;Caso tenha chegado, vá para a próxima label
    ;---------------------------
    mov bl, [expressao_pos + ecx]
    add ecx, 1                              ;Incrementa ecx
    mov [i], ecx                            ;Move para a variavel 'i'
    mov bh, '+'
    cmp bl,bh
    je soma
    mov bh, '-'
    cmp bl,bh
    je subt
    mov bh, '*'
    cmp bl,bh
    je mult
    mov bh, '/'
    cmp bl,bh
    je divi
    movsx edx, bl
    ;--------------------
    push edx
    jmp check_operator                      ;Volta para o inicio dessa label
    
;------------------------
soma:                                       ;Realiza operação de soma
    pop ebx
    pop eax
    sub ebx, '0'
    sub eax, '0'
    add eax, ebx
    add eax, '0'
    push eax
    jmp check_operator

subt:                                       ;Realiza operação de subtração
    pop ebx
    pop eax
    sub ebx, '0'
    sub eax, '0'
    sub eax, ebx
    add eax, '0'
    push eax
    jmp check_operator

mult:                                       ;Realiza operação de multiplicação
    pop ebx
    pop eax
    sub eax, '0'
    sub ebx, '0'
    mov ecx, 0
    mov edx, 0
    imul ebx
    add eax, '0'
    push eax
    jmp check_operator

divi:                                       ;Realiza operação de divisão
    pop ebx
    pop eax
    sub eax, '0'
    sub ebx, '0'
    mov ecx, 0
    mov edx, 0
    idiv ebx
    add eax, '0'
    push eax
    jmp check_operator

empilha_result:
    ;Quando a execução chega nesse ponto, é porque ela está bem formada
    imprima msg_sem_erro, len2              ;Imprime mensagem de expressão bem formada
    mov al, 0xa                             ;Move quebra de linha para o registrador al
    mov byte [char_atual], al
    imprima char_atual,1                    ;Imprime quebra de linha
    ; -----------------
    pop eax
    sub eax, '0'
    ; -------------------
    ;Verifica se é positivo ou negativo
    cmp eax, 0
    jns positivo
    mov bl, '-'
    mov byte [char_atual], bl
    imprima char_atual, 1
    imul eax, -1                            ;multiplica por -1 para ficar positivo

; -------------------
positivo:
    ; Laço para pegar todos os caracteres de um número inteiro
    mov ebx, 10                             ;Inicializa o registrador ebx

divide_por_dez:                             ;Vai dividindo por 10 até chegar em zero
    cmp eax, 0
    je exibe_resultado
    mov edx, 0                              ;Zera o registrador
    div ebx
    push edx                                ;Empilha o resto das divisões por 10
    jmp divide_por_dez

exibe_resultado:
    mov edx, [topo_pilha]

loop_resultado:
    cmp edx, esp
    je fim_programa                         ;Chama a macro que finaliza o programa
    pop eax
    add eax, '0'                            ;Adiciona '0' para o valor se enquadrar na tabela ASCII
    mov byte [char_atual], al
    imprima char_atual, 1                   ;Imprime o caracter em questão
    jmp loop_resultado                      ;Volta para o início dessa label

msg_erro:
    imprima msg_com_erro, len1              ;Label para exibir mensagem de erro

fim_programa:
    fim
