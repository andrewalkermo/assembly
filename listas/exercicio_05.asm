%include "asm_io.inc"

segment .data
	cabou	db		"cabou", 0
segment .bss
	ano		resb	6
	digitos	resd	5
segment .text
    global  asm_main
asm_main:
        enter   0,0
        pusha

		mov		ecx, 6
		mov		ebx, 0
		leitura:
			call	read_char

			cmp		al, 57
			jg		barraN
			cmp		al, 48
			jl		barraN
			jmp		notBarraN
			barraN:
				mov 	[ano+ebx], al
				jmp fimDaLeitura
			notBarraN:
				mov 	[ano+ebx], al
				inc ebx
				loop leitura

		fimDaLeitura:











		mov		ecx, 6
		mov		ebx, 0
		saidaTeste:
			mov 	ax, [ano+ebx]


			cmp		al, 57
			jg		fimDaSaida
			cmp		al, 48
			jl		fimDaSaida

			call	print_char
			call	print_nl
			inc ebx
			loop saidaTeste
		fimDaSaida:

        popa
        leave
        ret
