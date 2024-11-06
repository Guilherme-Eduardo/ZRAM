#!/bin/bash

# VERSAO 1.3
# SCRIPT DE BENCHMARK NASA - ZRAM
#
# @tuildes

### Arquivos de funcoes ###
source ./functions.sh
source ./env.sh

### Verificar pacotes ###
check_packages

### Verifica se esta em modo SUDO ###
if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, rode o BENCHMARK como ROOT"
    exit 1
fi

### LOG DE INICIO DO BENCHMARK ###
touch $LOG_ARCHIVE # Arquivo de LOG desta execucao
echo "[FILE] Arquivo de LOG de execucao criado: ${LOG_ARCHIVE}"

# Calculo de tempo de execucao
total_combinations=$((${#BENCHMARKS[@]} * ${#BENCH_CLASSES[@]} * ${#ZRAM_PORC[@]}))
total_time=$((total_combinations * 403)) # Combinacoes * tempo medio em segundos

write_logs_title $LOG_ARCHIVE "Informacoes de execucao"
write_logs $LOG_ARCHIVE "[INFO] Tempo estimado: $(date -u -d @$total_time +"%Hh %Mm %Ss")"
write_logs $LOG_ARCHIVE "[INFO] Benchmarks a serem executados: ${BENCHMARKS[*]}"
write_logs $LOG_ARCHIVE "[INFO] Classes a serem executadas: ${BENCH_CLASSES[*]}"
write_logs $LOG_ARCHIVE "[INFO] Porcentagem de ZRAM analisadas: ${ZRAM_PORC[*]}"
write_logs $LOG_ARCHIVE ""

touch $CSV_RESULT # Arquivo de LOG desta execucao
echo "[FILE] Arquivo CSV de resultado criado: ${CSV_RESULT}"
csv_writer_title $CSV_RESULT

mkdir "${DIR_BENCH_RESULT}"
echo "[FILE] Criado diretorio de trabalho: ${DIR_BENCH_RESULT}/"

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
write_logs $LOG_ARCHIVE "[LOG] Desabilitando DVFS (CPU frequency scaling) usando cpufrequtils"
write_logs $LOG_ARCHIVE "[LOG] Desabilitando Turbo boost (echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo)"
write_logs $LOG_ARCHIVE ""

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
        RESULT_ARCHIVE="${DIR_BENCH_RESULT}/${bm}-${cl}.log"
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

            for i in $( eval echo {1..$NUM_OF_REPETITIONS} )
            do
                
                # Identificacao do zram
                START_BM_DATE="$(date +"%d/%m/%Y %H:%M:%S")"
                echo "[INFO] Teste $i" >> $RESULT_ARCHIVE
                echo "[INFO] Iniciado benchmark com ${zr}% (0 gb) de ZRAM" >> $RESULT_ARCHIVE
                echo "[TIME] Benchmark iniciado: $START_BM_DATE" >> $RESULT_ARCHIVE
                write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) iniciado: $START_BM_DATE"
                write_logs $LOG_ARCHIVE "[LOG] Teste $i iniciado: $START_BM_DATE"

                if [ $NO_ZRAM_DEBUGGER -eq 0 ]; then
                    show_zram_stats $RESULT_ARCHIVE
                fi

                # Executando benchmark
                EXECUTABLE="$BENCHMARK_DIR/bin/$bm.$cl.x"
                OUTPUT_TIME=$(/usr/bin/time -f "Tempo real: %E\nSegundos de CPU: %S\nMedia de Memoria total (KB): %K\nMajor page fault: %F\nMinor page faults: %R\nSwaps totais: %W\nTrocas de contexto: %c\nEsperas com troca de contexto voluntarias: %w\nUso da CPU para este JOB: %P\n" $EXECUTABLE 2>&1)
                echo "$OUTPUT_TIME" >> $RESULT_ARCHIVE
                if [ $? -nt 0 ]; then
                    write_logs $LOG_ARCHIVE "[ERROR] Erro na execucao do benchmark"
                fi

                real_time=$(echo "$OUTPUT_TIME" | grep "Tempo real" | awk '{print $3}')
                cpu_seconds=$(echo "$OUTPUT_TIME" | grep "Segundos de CPU" | awk '{print $4}')
                avg_memory=$(echo "$OUTPUT_TIME" | grep "Media de Memoria total (KB)" | awk '{print $6}')
                major_faults=$(echo "$OUTPUT_TIME" | grep "Major page fault:" | awk '{print $4}')
                minor_faults=$(echo "$OUTPUT_TIME" | grep "Minor page faults:" | awk '{print $4}')
                SWAPS=$(echo "$OUTPUT_TIME" | grep "Swaps totais:" | awk '{print $3}')
                context_switches=$(echo "$OUTPUT_TIME" | grep "Trocas de contexto:" | awk '{print $4}')
                voluntary_context_switches=$(echo "$OUTPUT_TIME" | grep "Esperas com troca de contexto voluntarias:" | awk '{print $7}')
                cpu_usage=$(echo "$OUTPUT_TIME" | grep "Uso da CPU para este JOB:" | awk '{print $7}')

                # Salvar resultados
                if [ $NO_ZRAM_DEBUGGER -eq 0 ]; then
                    show_zram_stats $RESULT_ARCHIVE
                fi

                END_BM_DATE="$(date +"%d/%m/%Y %H:%M:%S")"
                write_logs $LOG_ARCHIVE "[LOG] Benchmark ${bm}/${cl} (${zr}% ZRAM) finalizado: $END_BM_DATE"
                echo "[TIME] Benchmark finalizado: $END_BM_DATE" >> $RESULT_ARCHIVE
                write_logs $LOG_ARCHIVE "[INFO] Escrevendo resultados no csv..."
                csv_writer $CSV_RESULT $i "$START_BM_DATE" "$END_BM_DATE" "$real_time" "$bm" "$cl" "$zr" 0 "$cpu_seconds" $avg_memory $major_faults $minor_faults $SWAPS $context_switches $voluntary_context_switches $cpu_usage
            done
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