#!/bin/bash

### Variaveis de ambiente ###

BENCHMARKS=('is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu' 'lu' 'ua') # Definir os benchmarks que serão executados
BENCH_CLASSES=('S') # Classes a serem testadas (S (fast to test), A, B, C (medium 4x), D, E, F (large 16x))
ZRAM_PORC=(0 50) # Porcentagem de ZRAM a serem testadas
COMPRESSION_ALGS=('null')
NUM_OF_REPETITIONS=1

RESULT_SOURCE="../output" # Onde sera guardado os resultados (*.log)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks

DIR_BENCH_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_benchmarks"
LOG_ARCHIVE="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_EXECUTION_bm_zram.log" # Criar arquivo de log da execucao
CSV_RESULT="${RESULT_SOURCE}/$(date +"%d%m%Y_%H%M%S")_RESULT.csv"

### Variaveis de debug ###

NO_ZRAM_DEBUGGER=0 # Ative se quiser INATIVAR testes com zram
