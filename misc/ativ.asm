%include "asm_io.inc"

segment .data

segment .bss

segment .text
  global  asm_main
asm_main:
  enter   0,0               ; setup routine

  push 5
  push 10
  push 2

  call delta

  call print_int

  leave
  ret

delta:
    push ebp
    mov ebp, esp

    mov eax, [ebp+16]
    mov ebx, [ebp+12]
    mov ecx, [ebp+8]

    imul ebx, ebx

    imul eax, ecx

    imul eax, 4
    neg eax

    add eax, ebx

    pop ebp
    ret   ;retorna
