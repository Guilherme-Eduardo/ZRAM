#!/bin/bash

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

write_logs $LOG_ARCHIVE "[INFO] Tempo estimado: 000:00:00"
write_logs $LOG_ARCHIVE "[INFO] Benchmarks a serem executados: ${BENCHMARKS[*]}"
write_logs $LOG_ARCHIVE "[INFO] Classes a serem executadas: ${BENCH_CLASSES[*]}"
write_logs $LOG_ARCHIVE "[INFO] Porcentagem de ZRAM analisadas: ${ZRAM_PORC[*]}"
write_logs $LOG_ARCHIVE ""

# Desabilitar os modulos para testes
write_logs $LOG_ARCHIVE "[LOG] Desabilitando XXXXXXX"
write_logs $LOG_ARCHIVE "[ERROR] Nao foi possivel desabilitar modulo XXXXX"
write_logs $LOG_ARCHIVE ""

# Marcacao de inicio
write_logs $LOG_ARCHIVE "[LOG] Iniciando testes: $(date +"%Y-%m-%d %H:%M:%S")"

### Execucao dos testes ###
for bm in ${BENCHMARKS[@]}
do
    for cl in ${BENCH_CLASSES[@]}
    do

        # Compilar o algoritmo
        write_logs $LOG_ARCHIVE "[LOG] Compilando benchmark ${bm}/${cl}"
        { make -C $BENCHMARK_DIR $bm CLASS=$cl; } >> $LOG_ARCHIVE 2>&1
        if [ $? -ne 0 ]; then
            write_logs $LOG_ARCHIVE "[ERROR] Não foi possivel compilar"
            write_logs $LOG_ARCHIVE "[LOG] Abortando compilacao..."
            continue
        fi

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
            # enable_zram $zr $LOG_ARCHIVE
            # ZRAM_RET=$?
            # if [ $ZRAM_RET -eq 1 ]; then
            #     # Erro ao habilitar o zram
            #     write_logs $LOG_ARCHIVE "[ERROR] Erro ao fazer troca de ${zr}% de zram"
            #     write_logs $LOG_ARCHIVE "[LOG] Pulando teste..."
            #     continue
            # fi

            sleep 10 # Ter certeza que desabilitou

            # Identificacao do zram
            echo >> $RESULT_ARCHIVE
            echo "[INFO] Iniciado benchmark com ${zr}% (0 gb) de ZRAM" >> $RESULT_ARCHIVE
            echo "[TIME] Benchmark iniciado: $(date +"%Y-%m-%d %H:%M:%S")" >> $RESULT_ARCHIVE
            write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) iniciado: $(date +"%Y-%m-%d %H:%M:%S")"

            # show_zram_stats $RESULT_ARCHIVE

            # Executando benchmark
            EXECUTABLE="$BENCHMARK_DIR/bin/$bm.$cl.x"
            { time "$EXECUTABLE"; } >> $RESULT_ARCHIVE 2>&1

            # Salvar resultados
            # show_zram_stats $RESULT_ARCHIVE
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
write_logs $LOG_ARCHIVE ""
write_logs $LOG_ARCHIVE "[LOG] Finalizando testes: $(date +"%Y-%m-%d %H:%M:%S")"

exit 0