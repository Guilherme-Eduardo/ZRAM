#!/bin/bash

source ./bm_functions.sh # Funcoes

### Variaveis de ambiente ###
# BENCHMARKS=('is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu') # Definir os benchmarks que serão executados
# BENCH_CLASSES=('A' 'B' 'C' 'D') # Classes a serem testadas
LOG_ARCHIVE="BM_ZRAM_$(date +"%Y-%m-%d_%H:%M:%S").log" # Criar arquivo de log da execucao
RESULT_SOURCE="../results" # Onde sera guardado os resultados (*.txt)
BENCHMARK_DIR="./bin" # Onde esta localizado os benchmarks

### Variaveis testes ###
BENCHMARKS=('is' 'ep') # Definir os benchmarks que serão executados
BENCH_CLASSES=('A' 'B') # Classes a serem testadas

### Verifica se esta em modo SUDO ###
if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, rode o BENCHMARK como ROOT"
    exit 1
fi

### LOG DE INICIO DO BENCHMARK ###
touch $LOG_ARCHIVE # Arquivo de LOG desta execucao
write_logs $LOG_ARCHIVE "[LOG] Iniciando testes: $(date +"%Y-%m-%d %H:%M:%S")"

### Execucao dos testes ###
for bm in ${BENCHMARKS[@]}
do
    for cl in ${BENCH_CLASSES[@]}
    do
        # Log de inicio do teste
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} iniciado: $(date +"%Y-%m-%d %H:%M:%S")"

        # Criar arquivo de resultado
        RESULT_ARCHIVE="${RESULT_SOURCE}/${bm}-${cl}_$(date +"%Y-%m-%d_%H:%M:%S").txt"
        touch $RESULT_ARCHIVE

        # Salvar resultados
        show_zram_stats $RESULT_ARCHIVE

        # Log de finalizacao
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} finalizado: $(date +"%Y-%m-%d %H:%M:%S")"
    done
done

# Finalizacao
write_logs $LOG_ARCHIVE "[LOG] Finalizando testes: $(date +"%Y-%m-%d %H:%M:%S")"

exit 0