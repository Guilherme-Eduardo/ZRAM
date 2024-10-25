#!/bin/bash

# VERSAO 1.1
# SCRIPT DE BENCHMARK NASA - ZRAM
#
# FAZ OS TESTES DE BENCHMARKS E SWITCH DE ZRAM
# UPDATE: Imprime a maquina atual
#
# @tuildes

### Arquivos de funcoes ###
source ./bm_functions.sh
source ./bm_env.sh

### Verifica se esta em modo SUDO ###
if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, rode o BENCHMARK como ROOT"
    exit 1
fi

### LOG DE INICIO DO BENCHMARK ###
touch $LOG_ARCHIVE # Arquivo de LOG desta execucao
echo "[FILE] Arquivo de LOG de execucao criado: ${LOG_ARCHIVE}"

write_logs_title $LOG_ARCHIVE "Informacoes de execucao"
write_logs $LOG_ARCHIVE "[INFO] Tempo estimado: 000:00:00"
write_logs $LOG_ARCHIVE "[INFO] Benchmarks a serem executados: ${BENCHMARKS[*]}"
write_logs $LOG_ARCHIVE "[INFO] Classes a serem executadas: ${BENCH_CLASSES[*]}"
write_logs $LOG_ARCHIVE "[INFO] Porcentagem de ZRAM analisadas: ${ZRAM_PORC[*]}"
write_logs $LOG_ARCHIVE ""

# Sobre a maquina que esta rodando
write_logs_title $LOG_ARCHIVE "Maquina dos testes"
write_logs $LOG_ARCHIVE "[INFO] lsb_release -a:"
lsb_release -a >> $LOG_ARCHIVE
write_logs $LOG_ARCHIVE "[INFO] Uname -a:"
write_logs $LOG_ARCHIVE "$( uname -a )"
write_logs $LOG_ARCHIVE "[INFO] cat /proc/meminfo:"
cat /proc/meminfo >> $LOG_ARCHIVE
write_logs $LOG_ARCHIVE "[INFO] cat /proc/cpuinfo | more:"
cat /proc/cpuinfo >> $LOG_ARCHIVE
write_logs $LOG_ARCHIVE "[INFO] df -ha:"
df -ha >> $LOG_ARCHIVE
write_logs $LOG_ARCHIVE "[INFO] fdisk -l:"
fdisk -l >> $LOG_ARCHIVE
write_logs $LOG_ARCHIVE ""

# Desabilitar os modulos para testes
write_logs_title $LOG_ARCHIVE "Preparacao do sistema"
write_logs $LOG_ARCHIVE "[LOG] Desabilitando XXXXXXX"
write_logs $LOG_ARCHIVE "[ERROR] Nao foi possivel desabilitar modulo XXXXX"
write_logs $LOG_ARCHIVE ""
# set mem_limit = 0

# Marcacao de inicio
write_logs_title $LOG_ARCHIVE "Iniciando benchmarks"
write_logs $LOG_ARCHIVE "[LOG] Iniciando testes: $(date +"%d/%m/%Y as %H:%M:%S")"

### Execucao dos testes ###
for bm in ${BENCHMARKS[@]}
do
    for cl in ${BENCH_CLASSES[@]}
    do

        # Compilar o benchmark
        write_logs $LOG_ARCHIVE ""
        write_logs_title $LOG_ARCHIVE "Benchmark ${bm}/${cl}"
        write_logs $LOG_ARCHIVE "[LOG] Compilando benchmark ${bm}/${cl}"
        { make -C $BENCHMARK_DIR $bm CLASS=$cl; } >> $LOG_ARCHIVE 2>&1
        if [ $? -ne 0 ]; then
            write_logs $LOG_ARCHIVE "[ERROR] Não foi possivel compilar"
            write_logs $LOG_ARCHIVE "[LOG] Abortando compilacao..."
            continue
        fi

        # Log de inicio do teste
        write_logs $LOG_ARCHIVE ""
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} iniciado: $(date +"%d/%m/%Y as %H:%M:%S")"

        # Criar arquivo de resultado
        RESULT_ARCHIVE="${RESULT_SOURCE}/${bm}-${cl}_$(date +"%d%m%Y_%H:%M:%S").log"
        touch $RESULT_ARCHIVE
        write_logs $LOG_ARCHIVE "[FILE] Arquivo criado: ${RESULT_ARCHIVE}"

        # Identificacao interna
        write_logs_title $RESULT_ARCHIVE "Benchmark ${bm} - classe ${cl}"
        echo "[TIME] Benchmark totalmente iniciado: $(date +"%d/%m/%Y as %H:%M:%S")" >> $RESULT_ARCHIVE

        # Testes para cada nivel de ZRAM
        for zr in ${ZRAM_PORC[@]}
        do
            echo "" >> $RESULT_ARCHIVE
            write_logs_title $RESULT_ARCHIVE "${zr}% (0 gb) de ZRAM"

            # Habilita ou desabilita o zram
            if [ $NO_ZRAM_DEBUGGER -eq 0 ]; then
                change_zram_porc $zr $LOG_ARCHIVE
                ZRAM_RET=$?
                if [ $ZRAM_RET -eq 1 ]; then
                    # Erro ao habilitar o zram
                    write_logs $LOG_ARCHIVE "[ERROR] Erro ao fazer troca para ${zr}% de zram"
                    echo "[ERROR] Erro ao fazer troca para ${zr}% de zram" >> $RESULT_ARCHIVE
                    write_logs $LOG_ARCHIVE "[LOG] Pulando teste..."
                    echo "[LOG] Pulando teste..." >> $RESULT_ARCHIVE
                    continue
                fi

                sleep 10 # Ter certeza que desabilitou
            fi

            # Identificacao do zram
            echo "[INFO] Iniciado benchmark com ${zr}% (0 gb) de ZRAM" >> $RESULT_ARCHIVE
            echo "[TIME] Benchmark iniciado: $(date +"%d/%m/%Y as %H:%M:%S")" >> $RESULT_ARCHIVE
            write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) iniciado: $(date +"%d/%m/%Y as %H:%M:%S")"

            if [ $NO_ZRAM_DEBUGGER -eq 0 ]; then
                show_zram_stats $RESULT_ARCHIVE
            fi

            # Executando benchmark
            EXECUTABLE="$BENCHMARK_DIR/bin/$bm.$cl.x"
            { time "$EXECUTABLE"; } >> $RESULT_ARCHIVE 2>&1
            if [ $? -nt 0 ]; then
                write_logs $LOG_ARCHIVE "[ERROR] Erro na execucao do benchmark"
            fi

            # Salvar resultados
            if [ $NO_ZRAM_DEBUGGER -eq 0 ]; then
                show_zram_stats $RESULT_ARCHIVE
            fi
            write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) finalizado: $(date +"%d/%m/%Y as %H:%M:%S")"
            echo "[TIME] Benchmark finalizado: $(date +"%d/%m/%Y as %H:%M:%S")" >> $RESULT_ARCHIVE
        done

        # Log de finalizacao
        echo >> $RESULT_ARCHIVE
        echo "[TIME] Benchmark totalmente finalizado: $(date +"%d/%m/%Y as %H:%M:%S")" >> $RESULT_ARCHIVE
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} finalizado: $(date +"%d/%m/%Y as %H:%M:%S")"
    done
done

# Finalizacao
write_logs $LOG_ARCHIVE ""
write_logs_title $LOG_ARCHIVE "Finalizando benchmarks"
write_logs $LOG_ARCHIVE "[LOG] Finalizando testes: $(date +"%d/%m/%Y as %H:%M:%S")"

exit 0