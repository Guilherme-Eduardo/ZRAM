#!/bin/bash

### Variaveis de ambiente ###

# Removido DC
# Algoritmo padrao de comprensaos: lzo-rle
BENCHMARKS=('bt' 'cg' 'ep' 'ft' 'is' 'lu' 'mg' 'sp' 'ua') # Definir os benchmarks que serão executados
BENCH_CLASSES=('C') # Classes a serem testadas (S (fast to test), A, B, C (medium 4x), D, E, F (large 16x))
ZRAM_PORC=(0 25 50 75 100) # Porcentagem de ZRAM a serem testadas
NUM_OF_REPETITIONS=1

RESULT_SOURCE="../output" # Onde sera guardado os resultados (*.log)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks

DIR_BENCH_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_benchmarks"
LOG_ARCHIVE="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_EXECUTION_bm_zram.log" # Criar arquivo de log da execucao
CSV_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_RESULT.csv"

### Variaveis de debug ###

# Por enquanto desabilitar isto, apenas gera a nao habilitacao do zram
# O teste continuara igual
# Entao ele fara o teste para 50% de zram, mas se habilitar de fato
NO_ZRAM_DEBUGGER=0 # 1 PARA DESABILITAR ZRAM
NO_BENCHMARKS_RESULTS=0 # 1 PARA SEM DIRETORIO DE RESULTADOS PARA CADA BENCHMARK
