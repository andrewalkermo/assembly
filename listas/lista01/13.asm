%include "asm_io.inc"

segment .data
f1 db 'Digite a quantidade de linhas que quer(1<=L<=12): ',0
space db ' ',0
k dd 0
n dd 0
p dd 0
fatn dd 0
fatp dd 0
fatnp dd 0
segment .bss

segment .text
        global  asm_main
calc:
	mov ebx,[n]
	mov [fatn],ebx
c1:
	mov eax,[fatn]
	cmp ebx,0
	je ajuste1
	cmp ebx,1
	je ajuste1
	dec ebx
	mul ebx
	mov [fatn],eax
	cmp ebx,1
	jg c1
	cmp ebx,1
	je nx1
ajuste1:
	mov eax,1
	mov [fatn],eax
nx1:
	mov ebx,[p]
	mov [fatp],ebx 
c2:
	mov eax,[fatp]
	cmp ebx,0
	je ajuste2
	cmp ebx,1
	je ajuste2
	dec ebx
	mul ebx
	mov [fatp],eax
	cmp ebx,1
	jg c2
	cmp ebx,1
	je nx2
ajuste2:
	mov eax,1
	mov [fatp],eax
nx2:
	mov ebx,[n]
	sub ebx,[p]
	mov [fatnp],ebx
c3:
	mov eax,[fatnp]
	cmp ebx,1
	je ajuste3
	cmp ebx,0
	je ajuste3
	dec ebx
	mul ebx
	mov [fatnp],eax
	cmp ebx,1
	jg c3
	cmp ebx,1
	je nx3
ajuste3:
	mov eax,1
	mov [fatnp],eax
nx3:
	mov eax,[fatp]
	mov ebx,[fatnp]
	mul ebx
	mov ebx,eax
	mov eax,[fatn]
	div ebx
	ret
linhaPascal:
	mov eax,0
	mov [k],eax
	mov [n],ebx
linhas:
	mov ebx,[k]
	mov [p],ebx
	call calc
	call print_int
	mov eax,space
	call print_string
	mov ebx,[k]
	inc ebx
	mov [k],ebx
	mov ebx,[n]
	cmp ebx,[k]
	jge linhas
	ret

asm_main:
	mov eax,f1
	call print_string
	call read_int
	mov ecx,eax
	mov ebx,0
lp:
	call linhaPascal
	call print_nl
	inc ebx
	loop lp
	
    leave                     
    ret
	