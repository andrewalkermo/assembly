; Macro criada para imprimir dados na tela
%macro print 2
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; Macro criada para ler os dados de entrada
%macro scan 2
    pushad
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

%macro swap 2
    pushad
    mov eax, %1
    mov ebx, %2
    mov %1, ebx
    mov %2, eax
    popad
%endmacro

%macro fim 0
    mov eax, 1
    mov ebx, 0
    int 0x80
%endmacro

section .bss
    vetor_entrada resb 200
    vetor_numerico resd 200
    char_atual resb 1
    n resd 1
    r resd 1
    p resd 1
    i resd 1
    j resd 1
    imp resb 1
    
section .text
global _start

partition:
    ; -------------------------------- pega parâmetros
    mov ebx, [esp + 4]  ;ebx = p
    mov ecx, [esp + 8]  ;ecx = r
    mov dword [p], ebx
    mov dword [r], ecx
   ;----------------------------------- fç
   shl ecx, 2           ;r*4
   mov eax, [vetor_numerico + ecx]  ;x = arrray[r] ---n pode mexer em eax
   shr ecx, 2
   mov dword [i], ebx               ;i=j=p
   mov dword [j], ebx
   
   
   loop1:
   mov ebx, [j]
   mov ecx, [r]
   cmp ebx, ecx
   jge fim_loop1
   mov ebx, [j]
   shl ebx, 2   
   mov ecx, [vetor_numerico + ebx]      ;ecx tem o valor do array[j]
   ;----------------------------------------
   ; Unificar trecho acima com o trecho de baixo
   cmp ecx, eax
   jg array_maior_x
   mov ebx, [i]
   shl ebx, 2
   mov ecx, [j]
   shl ecx, 2
   swap [vetor_numerico + ebx], [vetor_numerico + ecx]
   ;------------------------------------------------------
   ;Incrementa i
   mov ebx, [i]
   add ebx, 1
   mov dword [i], ebx
   ;---------------------------------
   array_maior_x:
    mov ebx, [j]
    add ebx, 1
    mov dword [j], ebx
    jmp loop1
    
    fim_loop1:
        
    mov ebx, [i]
    shl ebx, 2
    mov ecx, [r]
    shl ecx, 2
    swap [vetor_numerico + ebx],[vetor_numerico + ecx]
    mov eax, [i]
    pop ebp
    ret
    
    
quicksort:              ;esp armazena q em endereço -4
    ; -------------------------------- pega parâmetros
    mov ebx, [esp + 4]  ;ebx = p
    mov ecx, [esp + 8]  ;ecx = r
    ; -------------------------------- armazenar variaveis locais
    push ebp
    mov ebp, esp
    sub esp, 4
    ; -------------------------------- começo da função
    cmp ebx, ecx
    jge eh_maior_ou_igual
    push ebx                        ;passando p como parâmetro
    push ecx                        ;passando r como parâmetro
    call partition
    mov dword [ebp-4], eax
    push ebx
    sub eax, 1
    push eax
    call quicksort
    add eax, 2
    push eax
    push ecx
    call quicksort
    
    eh_maior_ou_igual:
    ; -------------------------------- fim da fç
    mov esp, ebp
    pop ebp
    ret

_start:
    scan vetor_entrada, 200
    ; aqui deve entrar o techo do código que converte a string para inteiro.
    mov eax, 0x0
    mov ebx, 0x0
    mov ecx, 0x0
    mov dword [n], eax
    
volta_inicio:
    mov al, [vetor_entrada + ebx]
    cmp al, 0xa
    je fim_laco
    cmp al, 0x20
    je fim_espaco
    ;----- se for negativo
    sub al,'0'
    movsx eax, al
    mov dword [vetor_numerico + ecx], eax
    add ecx, 1
    
    fim_espaco:
    add ebx, 1
    jmp volta_inicio
    ; em vetor_numerico vou admitir que existe um vetor com valores para serem ordenados
    ;n indica tamanho do vetor
    
fim_laco:
    mov dword [n], ecx
    mov eax, 0x0
    push eax
    mov eax, [n]                        ;Falta definir o valor de n
    sub eax, 1
    push eax
    call quicksort
    pop eax                             
    pop eax
    
    mov ebx, 0x0
print_array:
    mov ecx, [vetor_numerico + ebx]
    add ecx, '0'
    mov byte [char_atual], cl
    
    print char_atual, 1
    add ebx, 1
    
    mov ecx, [n]
    cmp ebx, ecx ; Compara se o contador é igual ao tamanho do vetor
    jl print_array
    fim
