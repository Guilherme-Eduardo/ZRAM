#!/bin/bash

### Variaveis de ambiente ###

BENCHMARKS=('is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu') # Definir os benchmarks que serão executados
BENCH_CLASSES=('A' 'B' 'C') # Classes a serem testadas
ZRAM_PORC=(0 25 50 75 100) # Porcentagem de ZRAM a serem testadas

LOG_ARCHIVE="BM_ZRAM_$(date +"%Y-%m-%d_%H:%M:%S").log" # Criar arquivo de log da execucao

RESULT_SOURCE="../results" # Onde sera guardado os resultados (*.log)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks