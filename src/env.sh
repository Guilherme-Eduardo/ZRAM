#!/bin/bash

### Variaveis de ambiente ###

# Algoritmo padrao (zram): lzo-rle
BENCHMARKS=('bt' 'cg' 'ep' 'dc' 'ft' 'is' 'lu' 'mg' 'sp' 'ua') # Definir os benchmarks que serão executados
BENCH_CLASSES=('C') # Classes a serem testadas (S (fast to test), A, B, C (medium 4x), D, E, F (large 16x))
ZRAM_PORC=(0 25 50 75 100) # Porcentagem de ZRAM a serem testadas
NUM_OF_REPETITIONS=2

RESULT_SOURCE="../output" # Onde sera guardado os resultados (*.log)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks

DIR_BENCH_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_benchmarks" # Diretorio de benchmarks unitarios
LOG_ARCHIVE="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_EXECUTION_bm_zram.log" # Log de execucao
CSV_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_RESULT.csv" # Planilha com resultados do (time --verbose)

### Variaveis de debug ###

NO_ZRAM_DEBUGGER=0 # 1 PARA DESABILITAR ZRAM
NO_BENCHMARKS_RESULTS=0 # 1 PARA SEM DIRETORIO DE RESULTADOS PARA CADA BENCHMARK
