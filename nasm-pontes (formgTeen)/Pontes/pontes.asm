;nasm -f elf32 pontes.asm && gcc -m32 -o codeobj pontes.o driver.c asm_io.o && ./codeobj
%include "asm_io.inc"
%define MAX_PILARES 52
%define MAX_VETOR 2704
%define SIZE_DD 4
%define valueAcesso [EBP + 16]
%define posInicialAcesso [EBP + 12]
%define posFinalAcesso [EBP + 8]
%define valorDaTentativaAcesso [EBP - 4]
%define EAX_RETORNO EAX
%define ECX_FLAG ECX

segment .data
  pilarInicial  dd 0
  pilarFinal    dd 0
  pilares       dd 0
  pontes        dd 0
  quantBuracos  dd 0
  mapaDePontes      times MAX_VETOR   dd -1
  historicoCaminho  times MAX_PILARES dd 0
segment .bss
segment .text

global  asm_main

asm_main:         ; Função Principal para Inicialização

  enter   0,0     ; Cria uma Stack Frame para o Programa ( Pilha )
  pusha           ; Joga para a Stack os Valores guardados nos Registradores

  call read_int
  mov [pilares], EAX
  call read_int
  mov [pontes], EAX

  mov ECX, [pontes]

  _mapear_terreno:
    _leEntradas:
      call    read_int
      mov     [pilarInicial], EAX
      call    read_int
      mov     [pilarFinal], EAX 
      call    read_int
      mov     [quantBuracos], EAX 
      jmp     _escolhePosVetor

    _escolhePosVetor:       
      mov     EBX, MAX_PILARES    ; EBX = tamanho da coluna
      imul    EBX, [pilarInicial] ; EBX = tamanho da coluna * linha
      add     EBX, [pilarFinal]   ; EBX = posicao da coluna
      imul    EBX, SIZE_DD        ; EBX = posicao da coluna * tamanho tipo do vetor
      mov     EDX, [quantBuracos]
      mov     [mapaDePontes + EBX], EDX
    
    _escolhePosVetorInverso:       
      mov   EBX, MAX_PILARES      ; EBX = tamanho da coluna
      imul  EBX, [pilarFinal]     ; EBX = tamanho da coluna * linha
      add   EBX, [pilarInicial]   ; EBX = posicao da coluna
      imul  EBX, SIZE_DD          ; EBX = posicao da coluna * tamanho tipo do vetor
      mov   EDX, [quantBuracos]
      mov [mapaDePontes + EBX], EDX
  loop _mapear_terreno

  _chamadaDaFuncao:
    mov EBX, [pilares]
    inc EBX
    push -1d ; value [EBP + 16]
    push 0d  ; posInicial [EBP + 12]
    push EBX ; posFinal + 1 [EBP + 8]

    call buscaCaminho

  _voltaDaFuncao:
    pop EBX
    pop EBX
    pop EBX

  _fim:
    call print_int
    call print_nl
    leave
    ret

buscaCaminho:

  enter 4, 0  ; reserva valor tentativa
  push  EBX   ; Salva o Contexto
  push  ECX   ; Salva o Contexto
  push  EDX   ; Salva o Contexto
  mov   EDX, posFinalAcesso
  mov   EBX, posInicialAcesso
  cmp   EBX, EDX
  je    _isZero
  jmp   _forToSet
  
  _forToSet:
    mov   ECX_FLAG, 1 ; ECX = 1

  _forToCompare:
    mov   EBX, posFinalAcesso   ; EBX = posFinal
    cmp   ECX_FLAG, EBX         ; Verifica se estou em um pilar valido para procura
    jle   _forToExec            ; Tente ir até o pilar se ele é valido
    jmp   _forToOut

  _forToExec:
      _visualizarHistorico:
        mov   EDX, ECX_FLAG
        imul  EDX, SIZE_DD
        mov   EBX, [historicoCaminho + EDX]
        cmp   EBX, 0
        jne   _forToAdd
        jmp   _visualizarMapa

      _visualizarMapa:
        ;Busca valor no Mapa
        mov   EBX, MAX_PILARES          ; EBX = tamanho da coluna
        imul  EBX, posInicialAcesso     ; EBX = tamanho da coluna * posInicial
        add   EBX, ECX_FLAG             ; EBX = posicao da coluna
        imul  EBX, SIZE_DD              ; EBX = posicao da coluna * tamanho-type-vetor
        mov   EBX, [mapaDePontes + EBX] ; mapa[posInicial][ECX]
        cmp   EBX, 0
        jl    _forToAdd
        jmp   _setHistorico

      _setHistorico:
        mov   EDX, ECX_FLAG
        imul  EDX, SIZE_DD
		    mov   EBX, 1d
        mov   [historicoCaminho + EDX], EBX ; historicoCaminho[ECX] = 1
        jmp   _recursiveCall

      _recursiveCall:
        mov   EDX, valueAcesso
        push  EDX
        push  ECX_FLAG  ; Envia ECX(i) como Parametro
        mov   EDX, posFinalAcesso
        push  EDX

        call buscaCaminho ; Chamada Recursiva

        pop EBX ; Limpa Parametro
        pop EBX ; Limpa Parametro
        pop EBX ; Limpa Parametro
    
        mov valorDaTentativaAcesso, EAX_RETORNO ; valorDaTentativa = EAX ( Retorno da Recursao )
        jmp _clearHistorico

      _clearHistorico:  
        mov   EDX, ECX_FLAG
        imul  EDX, SIZE_DD
		    mov   EBX, 0d
        mov   [historicoCaminho + EDX], EBX ;historicoCaminho[ECX] = 0
        jmp   _validaSolucao

      _validaSolucao: 
        mov   EBX, valorDaTentativaAcesso   ; EBX = valorDaTentativa
        cmp   EBX, -1d                      ; valorDaTentativa != 1 ?
		    je    _forToAdd
        jmp   _adicionaBuracosNoResultado   ; Continue com a Validacao

      _adicionaBuracosNoResultado:
        ; Busca o Valor no Mapa
        mov   EBX, MAX_PILARES
        imul  EBX, posInicialAcesso
        add   EBX, ECX_FLAG
        imul  EBX, SIZE_DD
        mov   EBX, [mapaDePontes + EBX]     ; EBX = mapa[posInicial][ECX]
        add   valorDaTentativaAcesso, EBX   ; valorDaTentativa = EBX
        jmp   _acheiSolucaoAntes

      _acheiSolucaoAntes:
        mov   EDX, valueAcesso              ; EDX = value
        cmp   EDX, -1                       ; value == -1 ? ou seja... Existe alguma solucao?
        je    _replace                      ; Caso não exista, aceite (valorDaTentativa)
        jmp   _melhorSolucao

      _melhorSolucao:
        mov   EBX, valorDaTentativaAcesso   ; EBX = valorDaTentativa
        cmp   EBX, valueAcesso              ; Compara solucoes
        jl    _replace                      ; Caso o valorDaTentiva seja melhor, aceite-o
        jmp   _forToAdd                     ; Caso o valor da tentativa seja pior, procure outro

      _replace:
        mov EBX, valorDaTentativaAcesso     ; EBX = valorDaTentativa
        mov [ebp + 16], EBX                 ; value = valorDaTentativa
        jmp _forToAdd                       ; Procure mais soluções

      _forToAdd: ; Prepara para repetir o processo de procura de solucoes
        inc ECX
        jmp _forToCompare

      _forToOut:
	  	  jmp _isValue

  _isValue: ; Retorno será o Value
    mov EAX, [ebp + 16]
    jmp _isOut

  _isZero: ; Retorno será 0
    mov EAX, 0
    jmp _isOut

_isOut: ; Prepara para Sair
  pop EDX; Restaura o Contexto
  pop ECX; Restaura o Contexto
  pop EBX; Restaura o Contexto
  leave
  ret