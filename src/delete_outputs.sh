#!/bin/bash

source ./env.sh

echo "Voce quer realmente deltar TODOS os resultados e logs?"
echo "Esta escolha nao tem volta! [y|N]"

read C

echo "Memoria: $memoria_calculada"

if [[ $C = 'y' ]]; then
    echo "Deletando"
    rm -f $RESULT_SOURCE/*.csv
    rm -f $RESULT_SOURCE/*_EXECUTION_bm*
    rm -rf $RESULT_SOURCE/*_*_benchmarks

    echo "Limpando compilacao"
    make -C $BENCHMARK_DIR clean 
    rm -f $BENCHMARK_DIR/bin/*.x
else
    echo "Abortando..."
fi

exit 0