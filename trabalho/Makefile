all: src/main.asm
	nasm -f elf32 src/main.asm
	 gcc -m32 -o trabalho src/main.o lib/driver.c lib/asm_io.o
