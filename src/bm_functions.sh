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

    # Impressao dos resultados
    echo "---------------- RESULTADOS ZRAM (bytes) ---------------- " >> $AN
    printf "%30s | %20d\n" "Swaps realizados" "$(cat /sys/block/zram0/stat)" >> $AN
    printf "%30s | %20d\n" "Dados originais" "$(cat /sys/block/zram0/orig_data_size)" >> $AN
    printf "%30s | %20d\n" "Dados comprimidos" "$(cat /sys/block/zram0/compr_data_size)" >> $AN
    printf "%30s | %20d\n" "Memoria usada total" "$(cat /sys/block/zram0/mem_used_total)" >> $AN
    printf "%30s | %20d\n" "Tamanho original" "$(cat /sys/block/zram0/orig_data_size)" >> $AN
    printf "%30s | %20d\n" "Tamanho compactado" "$(cat /sys/block/zram0/compr_data_size)" >> $AN
    echo "--------------------------------------------------------- " >> $AN
}

### DESABILITAR ZRAM ###
function disable_zram() { 
    sudo systemctl disable --now zramswap.service 
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

    # Habilitar zram
    else
        sudo systemctl enable --now zramswap.service
        # Definir tamanho do zram com base no escolhido
    fi

    return 0
}