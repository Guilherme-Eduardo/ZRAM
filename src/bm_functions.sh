#!/bin/bash

# FUNCOES PARA BM_SETUP.SH

### LOG TANTO NO TERMINAL QUANTO NO ARQUIVO DE LOG
function write_logs() {
    echo $2
    echo $2 >> $1
}
function write_logs_title() {
    echo "-~~-~~-~~-~~-~~-~~- ${2} -~~-~~-~~-~~-~~-~~-"
    echo "-~~-~~-~~-~~-~~-~~- ${2} -~~-~~-~~-~~-~~-~~-" >> $1
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

### MUDAR PORCENTAGEM DE ZRAM ###
function change_zram_porc() {
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

    # Verifica se eh OPENSUSE
    if [ $(lsb_release -si 2>/dev/null) == "Open Suse" ]; then
        if [ $PORC -eq 0 ]; then
            sudo zramswapoff

        # Habilitar zram
        else
            sudo zramswapon

            sudo swapoff /dev/zram0

            # Se precisar, habilita
            if ! lsmod | grep -q zram; then
                sudo modprobe zram
            fi

            # TODO: TROCAR PARA O ESPECIFICADO NO FUTURO
            echo 1 > /sys/block/zram0/reset
            echo 8G > /sys/block/zram0/disksize
            sudo mkswap /dev/zram0
            sudo swapon /dev/zram0
        fi

        return 0
    fi

    # Desabilitar zram
    if [ $PORC -eq 0 ]; then
        sudo systemctl disable --now zramswap.service 

    # Habilitar zram
    else
        sudo systemctl enable --now zramswap.service

        sudo swapoff /dev/zram0

        # Se precisar, habilita
        if ! lsmod | grep -q zram; then
            sudo modprobe zram
        fi

        # TODO: TROCAR PARA O ESPECIFICADO NO FUTURO
        echo 1 > /sys/block/zram0/reset
        echo 8G > /sys/block/zram0/disksize
        sudo mkswap /dev/zram0
        sudo swapon /dev/zram0
    fi

    return 0
}