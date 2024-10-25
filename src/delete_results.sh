#!/bin/bash

source ./bm_env.sh

LOG_DIR="."

echo "Voce quer realmente deltar TODOS os resultados e logs?"
echo "Esta escolha nao tem volta! [y|N]"

read C

if [[ $C = 'y' ]]; then
    echo "Deletando"
    rm -f $RESULT_SOURCE/*.log
    rm -f $LOG_DIR/BM_ZRAM_*

    echo "Limpando compilacao"
    make -C $BENCHMARK_DIR clean 
else
    echo "Abortando..."
fi

exit 0