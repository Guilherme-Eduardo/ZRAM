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

    # Preparacao dos resultados

    # Impressao dos resultados
    echo "---------------- RESULTADOS ZRAM (bytes) ---------------- " >> $AN
    printf "%30s | %20d\n" "Swaps realizados" "$(cat cat_file.txt)" >> $AN
    printf "%30s | %20d\n" "Dados originais" "$(cat cat_file.txt)" >> $AN
    printf "%30s | %20d\n" "Dados comprimidos" "$(cat cat_file.txt)" >> $AN
    printf "%30s | %20d\n" "Memoria usada total" "$(cat cat_file.txt)" >> $AN
    printf "%30s | %20d\n" "Taxa de compressao" "$(cat cat_file.txt)" >> $AN
    echo "--------------------------------------------------------- " >> $AN
}

### DESABILITAR ZRAM ###
function disable_zram() {
    echo "disabilitando zram"
}

### HABILITAR ZRAM ###
function enable_zram() {
    PORC=$1 # Porcentagem de zram
    LOG_ARCHIVE=$2

    # Caso de entradas de ZRAM impossiveis
    if [ $PORC -gt 100 ]; then
        write_logs $LOG_ARCHIVE "[ERRO] Porcentagem de ZRAM mal definida: ${PORC}"
        return 1 
    fi
    if [ $PORC -lt 0 ]; then
        write_logs $LOG_ARCHIVE "[ERRO] Porcentagem de ZRAM mal definida: ${PORC}"
        return 1 
    fi

    # Desabilitar zram
    if [ $PORC -eq 0 ]; then
        disable_zram
    else
        # Habilitar zram
        echo "habilitando zram..."
    fi

    return 0
}

### FAZER TESTE ###
function execute_test() {
    RESULT_ARCHIVE=$1 # Arquivo de resultado
}