#!/bin/bash

# Função para capturar e exibir estatísticas do ZRAM
function show_zram_stats() {
    echo "Número de swaps realizados:"
    cat /sys/block/zram0/stat

    echo "Dados originais (em bytes):"
    cat /sys/block/zram0/orig_data_size

    echo "Dados comprimidos (em bytes):"
    cat /sys/block/zram0/compr_data_size

    echo "Memória usada total (em bytes):"
    cat /sys/block/zram0/mem_used_total

    # Calcular taxa de compressão
    orig_data=$(cat /sys/block/zram0/orig_data_size)
    compr_data=$(cat /sys/block/zram0/compr_data_size)
    if [ "$compr_data" -eq 0 ]; then
        compression_ratio="N/A (divisão por zero)"
    else
        compression_ratio=$(echo "scale=2; $orig_data / $compr_data" | bc)
    fi
    echo "Taxa de compressão: $compression_ratio"
}

function executa_zram() {
    # Criar diretório para resultados da classe
    class_result_dir="$result_dir/$class"
    mkdir -p "$class_result_dir"

    echo "Executando testes sem o ZRAM..." | tee -a "$class_result_dir/results_without_zram.txt"

    sudo systemctl disable --now zramswap.service

    echo "Analisando memória com o comando free -h..." | tee -a "$class_result_dir/results_without_zram.txt"
    free -h >> "$class_result_dir/results_without_zram.txt"
    echo "" >> "$class_result_dir/results_without_zram.txt"

    sleep 5  # Espera para garantir que zRAM foi desativado

    echo "Realizando teste sem o uso do zram..." | tee -a "$class_result_dir/results_without_zram.txt"
    echo "Saída com o comando /usr/bin/time -v..." | tee -a "$class_result_dir/results_without_zram.txt"
    
    # Executa o benchmark sem ZRAM
    /usr/bin/time -v "$executable" >> "$class_result_dir/results_without_zram.txt"
    echo "" >> "$class_result_dir/results_without_zram.txt"
    echo "Análise da memória depois do teste com o comando free -h..." | tee -a "$class_result_dir/results_without_zram.txt"
    free -h >> "$class_result_dir/results_without_zram.txt"

    echo "Running tests with zRAM..." | tee -a "$class_result_dir/results_with_zram.txt"
    echo "Analisando memória com o comando free -h..." | tee -a "$class_result_dir/results_with_zram.txt"
    free -h >> "$class_result_dir/results_with_zram.txt"
    echo "" >> "$class_result_dir/results_with_zram.txt"

    # Exibir estatísticas antes da execução do programa
    echo "Estatísticas do ZRAM antes da execução:" | tee -a "$class_result_dir/results_with_zram.txt"
    show_zram_stats >> "$class_result_dir/results_with_zram.txt"

    echo "Habilitando o zram..." | tee -a "$class_result_dir/results_with_zram.txt"
    sudo systemctl enable --now zramswap.service

    sleep 5  # Espera para garantir que zRAM foi ativado
    echo "Saída com o comando /usr/bin/time -v" | tee -a "$class_result_dir/results_with_zram.txt"

    # Executa o benchmark com ZRAM
    /usr/bin/time -v "$executable" >> "$class_result_dir/results_with_zram.txt"
    echo "Análise da memória depois do teste com o comando free -h" | tee -a "$class_result_dir/results_with_zram.txt"
    free -h >> "$class_result_dir/results_with_zram.txt"

    echo "Tests completed. Results saved in $class_result_dir/results_without_zram.txt and $class_result_dir/results_with_zram.txt"
}

# Definir os benchmarks que serão executados
benchmarks=("is" "ep" "cg" "mg" "ft" "bt" "sp" "lu")
# Classes a serem testadas
classes=("A" "B" "C" "D")

# Diretório onde o executável dos benchmarks está localizado
benchmark_dir="./bin"
# Diretório para armazenar resultados
result_dir="./resultados"

# Criar diretório de resultados se não existir
mkdir -p "$result_dir"

# Ajuste de permissões
chmod -R 755 .

# Para cada classe
for class in "${classes[@]}"; do
    # Para cada benchmark
    for benchmark in "${benchmarks[@]}"; do
        # Exibe qual benchmark e classe está sendo executado
        echo "Executando $benchmark classe $class..."
        
        # Construa o comando de execução
        executable="$benchmark_dir/$benchmark.$class.x"

        # Verifica se o executável existe
        if [ -f "$executable" ]; then
            # Execute o benchmark e redirecione a saída para o arquivo de resultados
            executa_zram
            
            # Verifique se o benchmark foi executado corretamente
            if [ $? -eq 0 ]; then
                echo "$benchmark classe $class executado com sucesso."
            else
                echo "Erro ao executar $benchmark classe $class."
            fi
        else
            echo "Executável $executable não encontrado. Verifique se foi compilado corretamente."
        fi
    done
done

