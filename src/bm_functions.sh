#!/bin/bash

# FUNCOES PARA BM_SETUP.SH

### LOG TANTO NO TERMINAL QUANTO NO ARQUIVO DE LOG
function write_logs() {
    echo $2
    echo $2 >> $1
}

### MOSTRAR RESULTADOS NO ZRAM NO ARCHIVO AN ###
function show_zram_stats() {
    AN=$1 # Nome do arquivo

    # Preparacao dos reusltados

    # Impressao dos resultados
    echo >> $AN
    echo "---------------- RESULTADOS ZRAM (bytes) ---------------- " >> $AN
    printf "%30s | %20d\n" "Swaps realizados" 0 >> $AN
    printf "%30s | %20d\n" "Dados originais" 0 >> $AN
    printf "%30s | %20d\n" "Dados comprimidos" 0 >> $AN
    printf "%30s | %20d\n" "Memoria usada total" 0 >> $AN
    printf "%30s | %20d\n" "Taxa de compressao" 0 >> $AN
    echo "--------------------------------------------------------- " >> $AN
    echo >> $AN
}

### FAZER TESTE ###
function execute_test() {
    RESULT_ARCHIVE=$1 # Arquivo de resultado
}