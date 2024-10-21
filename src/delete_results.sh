#!/bin/bash

RESULT_DIR="../results"
LOG_DIR="."

echo "Voce quer realmente deltar TODOS os resultados e logs?"
echo "Esta escolha nao tem volta! [y|N]"

read C

if [[ $C = 'y' ]]; then
    echo "Deletando"
    rm $RESULT_DIR/*.txt
    rm $LOG_DIR/BM_ZRAM_*
else
    echo "Abortando..."
fi

exit 0