#!/bin/bash
# echo $1
if [[ -z $1 ]]; then
  read -p "Digite o nome arquivo sem extencao: " entrada
else
  entrada=$1
fi
cp ${entrada}.asm ./nasm &&
cd nasm &&
nasm -f elf32 ${entrada}.asm &&
gcc -m32 -o ${entrada} ${entrada}.o driver.c asm_io.o &&
./${entrada} &&
# rm ${entrada}* &&
cd ..
