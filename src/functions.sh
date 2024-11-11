#!/bin/bash

# FUNCOES PARA BM_SETUP.SH

### Verifica pacotes instalados
function check_packages() {
    
    # Pacote "zram"
    if [ $(dpkg -l zram-config &>/dev/null) ]; then
        echo "Pacote "zram-config" nao instalado"
        exit 1
    fi

    # Pacote "fdisk"
    if [ $(dpkg -l fdisk &>/dev/null) ]; then
        echo "Pacote "fdisk" nao instalado"
        exit 1
    fi

    # Pacote "lsb-release"
    if [ $(dpkg -l fdisk &>/dev/null) ]; then
        echo "Pacote "lbs-release" nao instalado"
        exit 1
    fi

    # Pacote "make"
    if [ $(dpkg -l gfortran &>/dev/null) ]; then
        echo "Pacote "gfortran" nao instalado"
        exit 1
    fi

    # Pacote "gcc"
    if [ $(dpkg -l gcc &>/dev/null) ]; then
        echo "Pacote "gcc" nao instalado"
        exit 1
    fi
}

### LOG TANTO NO TERMINAL QUANTO NO ARQUIVO DE LOG
function write_logs() {
    echo $2
    echo $2 >> $1
}

### Titulo tanto no TERMINAL quanto no arquivo de LOG
function write_logs_title() {
    echo "-~~-~~-~~-~~-~~-~~- ${2} -~~-~~-~~-~~-~~-~~-"
    echo "-~~-~~-~~-~~-~~-~~- ${2} -~~-~~-~~-~~-~~-~~-" >> $1
}

### MOSTRAR RESULTADOS NO ZRAM NO ARCHIVO AN ###
function show_zram_stats() {
    AN=$1 # Nome do arquivo

    if [[ $(zramctl) ]]; then

	LOC="/sys/block/zram0"	

	echo "---------------- RESULTADOS ZRAM (bytes) ---------------- " >> $AN

	echo "More information: https://docs.kernel.org/admin-guide/blockdev/zram.html" >> $AN
	echo "" >> $AN
	
	echo "DISKSIZE: " >> $AN
	cat "${LOC}/disksize" >> $AN
	echo "INITSTATE: " >> $AN
    cat "${LOC}/initstate" >> $AN
    echo "WRITEBACK_LIMIT_ENABLE: " >> $AN
    cat "${LOC}/writeback_limit_enable" >> $AN
    echo "MAX_COMP_STREAMS: " >> $AN
    cat "${LOC}/max_comp+streams" >> $AN
    echo "COMP_ALGORITHM: " >> $AN
    cat "${LOC}/comp_algorithm" >> $AN
    echo "DEBUG_STAT: " >> $AN
    cat "${LOC}/debug_stat" >> $AN
    echo "BACKING_DEV: " >> $AN
    cat "${LOC}/backing_dev" >> $AN

	# Precisa melhorar essas saidas
    echo "STATS: " >> $AN
    cat "${LOC}/stat" >> $AN
	echo "STATS I/O: " >> $AN
    cat "${LOC}/io_stat" >> $AN
	echo "STATS mm: " >> $AN
    cat "${LOC}/mm_stat" >> $AN
	echo "STATS bd: " >> $AN
    cat "${LOC}/bd_stat" >> $AN

	echo "--------------------------------------------------------- " >> $AN

	fi
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

    TOTAL_MEMORY_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ZRAM_DISKSIZE=$((TOTAL_MEMORY_KB * PORC / 100))

    # Verifica se eh OPENSUSE
    if [ $(lsb_release -si 2>/dev/null) = "openSUSE" ]; then
        if [ $PORC -eq 0 ]; then
            sudo zramswapoff
        else
            sudo zramswapoff

            # Se precisar, habilita
            if ! lsmod | grep -q zram; then
                sudo modprobe zram
            fi

            echo 1 > /sys/block/zram0/reset
            echo ${ZRAM_DISKSIZE}KB > /sys/block/zram0/disksize
                
            sudo zramswapon
        fi
    else
    	# Desabilitar zram
    	if [ $PORC -eq 0 ]; then
        	sudo swapoff /dev/zram0 # Desabilitar

    	# Habilitar zram
    	else
        	sudo swapoff /dev/zram0 # Desabiliar para trocar

        	# Se precisar, habilita
        	if ! lsmod | grep -q zram; then
            	sudo modprobe zram
        	fi

        	# TODO: TROCAR PARA O ESPECIFICADO NO FUTURO
       		echo 1 > /sys/block/zram0/reset
        	echo ${ZRAM_DISKSIZE}KB > /sys/block/zram0/disksize
        	sudo mkswap /dev/zram0
        	sudo swapon /dev/zram0
    	fi
    fi
	
	write_logs $LOG_ARCHIVE "[INFO] zramctl:"
	zramctl >> $LOG_ARCHIVE

    return 0
}

### FUNCOES DE CSV ###
function csv_writer_title() {
    CSV=$1

    printf "Repetition,\"Start date\",\"End date\",Duration,Benchmark,\"Class\",\"Zram %% (gb)\"," >> $CSV
    printf "\"Tempo de CPU\",\"Memoria media (KB)\",\"Falhas maiores\",\"Falhas menores\"," >> $CSV
    printf "Swaps,\"Troca de contextos\",\"Troca de contextos voluntarias\",\"Uso de cpu\"" >> $CSV
}

function csv_writer() {
    CSV=$1

    printf "\n%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%3d%% (%2d gb)\"," $2 "$3" "$4" "$5" $6 $7 $8 $9 >> $CSV
    printf "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" >> $CSV

}
