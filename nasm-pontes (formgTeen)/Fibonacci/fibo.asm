%include "asm_io.inc"

segment .data

segment .bss

segment .text

    global  asm_main

    asm_main:               ; Função Principal para Inicialização

            enter   0,0     ; Cria uma Stack Frame para o Programa ( Pilha )
            pusha           ; Joga para a Stack os Valores guardados nos Registradores

            call read_int
            push eax
            call fibo
            pop edx
            call print_int
            call print_nl
            
            popa                        ; Devolve os Valores dos Registradores armazenados na Stack
            mov     eax, 0              ; Devolve o Status do Programa para o C
            leave
            ret




    fibo:
      enter 0,0 ; Guardo o EBP da Chamada
      push ebx ; Salva o Contexto
      push ecx ; Salva o Contexto
      push edx ; Salva o Contexto
      mov ecx, [ebp + 8] ; Salva o Primeiro parametro em ecx


      cmp ecx, 0
      je is_zero ; Caso o parametro seja 0

      cmp ecx, 1
      je is_one ; Caso o parametro seja 1

      jmp try ; Tenta reduzir o problema


      is_zero:
        mov eax, 0
        jmp is_out ; Prepara para Sair

      is_one:
        mov eax, 1
        jmp is_out ; Prepara para Sair

      try:
        mov edx, ecx ; Copia o atual parametro em EDX
        dec edx ; Prepara o Proximo

        push edx; Envia como Parametro
        call fibo
        pop edx ; Pega o Antigo parametro
        mov ebx, eax ; Salva o Resultado em EBX

        dec edx ; Prepara o Parametro de novo

        push edx ; Envia um novo parametro
        call fibo
        pop edx ;

        add eax, ebx; Soma os Resultados
        jmp is_out; Prepara para Sair

      is_out:
        pop edx; Restaura o Contexto
        pop ecx; Restaura o Contexto
        pop ebx; Restaura o Contexto
        leave
        ret
