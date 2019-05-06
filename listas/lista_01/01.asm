a)
%include "asm_io.inc"

segment .data
Var1 dw 10
Var2 dw -3
Var3 dw 15


segment .bss
Resultado resd 1 ; doubleword

segment .text
        global  asm_main
asm_main:

    mov dx, [Var3]
    mov ax, [Var1]
	movzx eax,ax
	movzx edx,dx

    sub edx, eax ; var3 - var1
    mov eax,edx ; eax = var3-var1
    mul eax ; eax = (var3-var1)^2
    mov ecx,eax ; ecx = (var3-var1)^2

    mov ax, [Var2]
	movsx eax,ax

    neg eax ; eax = -Var2

    mov bx,[Var1]
	movzx ebx,bx ; ebx = var1
	
    mul ebx ; eax = (-var2)*Var1
    mul ecx ; eax = (-var2)*var1*(var3-var1)^2
	
	mov [Resultado],eax
	mov eax,[Resultado]

	call print_int ; imprime o numero para verificar o resultado
    call print_nl

    leave                     
    ret

b)
%include "asm_io.inc"

segment .data
Var1 dw 10
Var2 dw -3
Var3 dw 15


segment .bss
Resultado resd 1 ; doubleword

segment .text
        global  asm_main
asm_main:
    mov ax,[Var1]
    movzx eax,ax
    mov bx,[Var3]
    movzx ebx,bx
    add ebx,eax ; ebx = var1+Var3

    mov cx,[Var2]
    movsx ecx,cx

    mov edx,0
    idiv ecx ; edx = var1%var2 
    neg edx ; edx = -(var1%var2) 
	
    mov eax,ebx ; eax = var1+var3
    mov ebx,edx ; ebx = -(var1%var2)
    mov edx,0
    idiv ebx

    mov [Resultado],eax
    
    call print_int
    call print_nl

    leave                     
    ret