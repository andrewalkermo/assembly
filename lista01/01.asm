%include "asm_io.inc"

segment .data

Var1	dw	10
Var2	dw	-3
Var3	dw	15

segment .bss
resultado      resd    1
segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha

		mov     ax, [Var2]
        mov     bx, -1
        imul    bx
        mov     bx, ax

      	mov		ax, [Var1]
		imul	bx
		mov		eax, ax

		; mov
		call	print_int
		call	print_nl

        popa
        leave
        ret
