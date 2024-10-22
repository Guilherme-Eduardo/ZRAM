#!/bin/bash

source ./bm_functions.sh # Funcoes

### Variaveis de ambiente ###
# BENCHMARKS=('is' 'ep' 'cg' 'mg' 'ft' 'bt' 'sp' 'lu') # Definir os benchmarks que serão executados
# BENCH_CLASSES=('A' 'B' 'C') # Classes a serem testadas
# ZRAM_PORC=(0 25 50 75 100) # Porcentagem de ZRAM a serem testadas
LOG_ARCHIVE="BM_ZRAM_$(date +"%Y-%m-%d_%H:%M:%S").log" # Criar arquivo de log da execucao
RESULT_SOURCE="../results" # Onde sera guardado os resultados (*.txt)
BENCHMARK_DIR="./NPB-OMP" # Onde esta localizado os benchmarks

### Variaveis testes ###
BENCHMARKS=('is') # Definir os benchmarks que serão executados
BENCH_CLASSES=('A') # Classes a serem testadas
ZRAM_PORC=(0 50)

### Verifica se esta em modo SUDO ###
if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, rode o BENCHMARK como ROOT"
    exit 1
fi

### LOG DE INICIO DO BENCHMARK ###
touch $LOG_ARCHIVE # Arquivo de LOG desta execucao
echo "[FILE] Arquivo de LOG de execucao criado: ${LOG_ARCHIVE}"

write_logs $LOG_ARCHIVE "[INFO] Tempo estimado: 000:00:00"
write_logs $LOG_ARCHIVE "[INFO] Benchmarks a serem executados: ${BENCHMARKS[*]}"
write_logs $LOG_ARCHIVE "[INFO] Classes a serem executadas: ${BENCH_CLASSES[*]}"
write_logs $LOG_ARCHIVE "[INFO] Porcentagem de ZRAM analisadas: ${ZRAM_PORC[*]}"
write_logs $LOG_ARCHIVE ""

# Desabilitar os modulos para testes
write_logs $LOG_ARCHIVE "[LOG] Desabilitando XXXXXXX"
write_logs $LOG_ARCHIVE "[ERRO] Nao foi possivel desabilitar modulo XXXXX"
write_logs $LOG_ARCHIVE ""

# Marcacao de inicio
write_logs $LOG_ARCHIVE "[LOG] Iniciando testes: $(date +"%Y-%m-%d %H:%M:%S")"

### Execucao dos testes ###
for bm in ${BENCHMARKS[@]}
do
    # Compilar o algoritmo
    write_logs $LOG_ARCHIVE "[LOG] Compilando benchmark"
    write_logs $LOG_ARCHIVE ""
    make -C $BENCHMARK_DIR $bm >> $LOG_ARCHIVE
    if [ algo ]; then
        write_logs $LOG_ARCHIVE ""
        write_logs $LOG_ARCHIVE "[ERRO] Não foi possivel compilar benchmark ${bm}"
        write_logs $LOG_ARCHIVE "[LOG] Abortando compilacao... ${bm}"
        continue
    fi
    write_logs $LOG_ARCHIVE ""

    for cl in ${BENCH_CLASSES[@]}
    do
        # Log de inicio do teste
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} iniciado: $(date +"%Y-%m-%d %H:%M:%S")"

        # Criar arquivo de resultado
        RESULT_ARCHIVE="${RESULT_SOURCE}/${bm}-${cl}_$(date +"%Y-%m-%d_%H:%M:%S").log"
        touch $RESULT_ARCHIVE
        write_logs $LOG_ARCHIVE "[FILE] Arquivo criado: ${RESULT_ARCHIVE}"

        # Identificacao interna
        echo "[ID] Benchmark ${bm} - classe ${cl}" >> $RESULT_ARCHIVE
        echo "[TIME] Benchmark totalmente iniciado: $(date +"%Y-%m-%d %H:%M:%S")" >> $RESULT_ARCHIVE

        # Memoria livre inicial (para controle de tamanho)
        echo >> $RESULT_ARCHIVE
        echo "Memoria livre e existente na maquina" >> $RESULT_ARCHIVE
        free -lh >> $RESULT_ARCHIVE

        # Testes para cada nivel de ZRAM
        for zr in ${ZRAM_PORC[@]}
        do
            # Habilita ou desabilita o zram
            enable_zram $zr $LOG_ARCHIVE
            ZRAM_RET=$?
            if [ $ZRAM_RET -eq 1 ]; then
                # Erro ao habilitar o zram
                write_logs $LOG_ARCHIVE "[ERRO] Erro ao fazer troca de ${zr}% de zram"
                write_logs $LOG_ARCHIVE "[LOG] Pulando teste..."
                continue
            fi

            sleep 10 # Ter certeza que desabilitou

            # Identificacao do zram
            echo >> $RESULT_ARCHIVE
            echo "[INFO] Iniciado benchmark com ${zr}% (0 gb) de ZRAM" >> $RESULT_ARCHIVE
            echo "[TIME] Benchmark iniciado: $(date +"%Y-%m-%d %H:%M:%S")" >> $RESULT_ARCHIVE
            write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) iniciado: $(date +"%Y-%m-%d %H:%M:%S")"

            # Executando benchmark
            # /usr/bin/time -v "$EXECUTABLE" >> $RESULT_ARCHIVE
            show_zram_stats $RESULT_ARCHIVE

            # Salvar resultados
            show_zram_stats $RESULT_ARCHIVE
            write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) finalizado: $(date +"%Y-%m-%d %H:%M:%S")"
            echo "[TIME] Benchmark finalizado: $(date +"%Y-%m-%d %H:%M:%S")" >> $RESULT_ARCHIVE
        done

        # Log de finalizacao
        echo >> $RESULT_ARCHIVE
        echo "[TIME] Benchmark totalmente finalizado: $(date +"%Y-%m-%d %H:%M:%S")" >> $RESULT_ARCHIVE
        write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} finalizado: $(date +"%Y-%m-%d %H:%M:%S")"
    done
done

# Finalizacao
write_logs $LOG_ARCHIVE "[LOG] Finalizando testes: $(date +"%Y-%m-%d %H:%M:%S")"

exit 0