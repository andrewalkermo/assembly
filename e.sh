#!/bin/bash
rm -f recursos/nasm/tmp_*                                                      # remove arquivos temporarios anteriores
if [[ -z $1 ]]; then                                          # verifica se tem parametro
  read -p "Digite o nome arquivo sem extencao: " entrada      # salva o caminho do arquivo em $entrada
else
  entrada=$1                                                  # salva o conteudo do parametro em $entrada
fi
if [[ ! -f $1 ]]; then                                        # verifica se o arquivo existe
  echo "caminho do arquivo invalido"                          # imprime erro
  exit                                                        # interrompe a execucao
fi
entrada="$(cut -d'.' -f 1 <<< $entrada)"                      # retira a extensao .asm de $entrada
fileName=${entrada##*/}                                       # salva apenas o nome do arquivo (sem o caminho) em $fileName
hash=$(date +%s | sha256sum | base64 | head -c 32 ; echo)     # cria hash a partir da data atual e salva em $hash
tempFile="tmp_$fileName$hash"                                 # salva nome do arquivo temporario em $tempFile
cp ${entrada}.asm ./recursos/nasm/${tempFile}.asm                      # cria arquivo temporario na pasta nasm
cd recursos/nasm &&                                                    # navega ate a pasta nasm/
nasm -f elf32 ${tempFile}.asm                                 # cria arquivo .o
gcc -m32 -o ${tempFile} ${tempFile}.o driver.c asm_io.o       # cria arquivo executavel
./${tempFile}                                                 # executa o arquivo
cd ..                                                         # navega ate a raiz do projeto
rm -f recursos/nasm/${tempFile}*                                       # deleta arquivo temporario
