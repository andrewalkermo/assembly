%include "asm_io.inc"

segment .data

segment .bss

segment .text
    global  asm_main
asm_main:
    enter   0,0

    call    read_int
    push    eax
    call    fat
    call    print_int
    call    print_nl
    pop     ecx

    leave
    ret

fat:
    push    ebp
    mov     ebp, esp
    mov     ebx, [ebp+8]
    cmp     ebx, 1
    jle     base
    dec     ebx
    push    ebx
    call    fat
    pop     ecx
    inc     ebx
    imul    eax, ebx
    jmp     fim
    base:
        mov     eax, 1
    fim:
    pop     ebp
    ret
