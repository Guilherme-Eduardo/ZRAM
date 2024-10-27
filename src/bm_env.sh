#!/bin/bash

### Variaveis de ambiente ###

BENCHMARKS=('is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu') # Definir os benchmarks que serão executados: 'is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu'
BENCH_CLASSES=('A' 'B' 'C' 'D') # Classes a serem testadas (S (fast to test), A, B, C (medium 4x), D, E, F (large 16x))
ZRAM_PORC=(0 50) # Porcentagem de ZRAM a serem testadas
COMPRESSION_ALGS=('null')

RESULT_SOURCE="../output" # Onde sera guardado os resultados (*.log)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks

LOG_ARCHIVE="${RESULT_SOURCE}/EXECUTION_bm_zram_$(date +"%d%m%Y_%H%M%S").log" # Criar arquivo de log da execucao

### Variaveis de debug ###

NO_ZRAM_DEBUGGER=1 # Ative se quiser INATIVAR testes com zram
