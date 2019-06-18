
%include "lib/asm_io.inc"

segment .data
    str: times 100 db 0 ; Allocate buffer of 100 bytes
    lf:  db 10          ; LF for full str-buffer

    filename db "test.txt", 0
    buflen dw 2048

segment .bss

    e1_len resd 1
    dummy resd 1
    buffer resb 2048

segment .text

    %include "lib/read_write_file.asm"
    global  asm_main

asm_main:


    mov eax, 3          ; Read user input into str
    mov ebx, 0          ; |
    mov ecx, str        ; | <- destination
    mov edx, 100        ; | <- length
    int 80h             ; \

    mov [e1_len],eax    ; Store number of inputted bytes
    cmp eax, edx        ; all bytes read?
    jb .2               ; yes: ok
    mov bl,[ecx+eax-1]  ; BL = last byte in buffer
    cmp bl,10           ; LF in buffer?
    je .2               ; yes: ok
    inc DWORD [e1_len]  ; no: length++ (include 'lf')

    .1:                 ; Loop
    mov eax,3           ; SYS_READ
    mov ebx, 0          ; EBX=0: STDIN
    mov ecx, dummy      ; pointer to a temporary buffer
    mov edx, 1          ; read one byte
    int 0x80            ; syscall
    test eax, eax       ; EOF?
    jz .2               ; yes: ok
    mov al,[dummy]      ; AL = character
    cmp al, 10          ; character = LF ?
    jne .1              ; no -> next character
    .2:                 ; end of loop

    push filename
    push buffer
    push buflen
    call read_file
    add esp, 12

    mov esi, buffer
    cld
    print:
    lodsb
        cmp al, 0
        je exit
        call print_char
    jmp print
    exit:
    call print_nl


    leave
    ret
