#!/bin/bash

echo "Este é sua memória"
free -lh

echo "Caso tenha aparecido particições de swap nela, remova com:"
echo "swapoff /dev/swap..."

echo ""
echo "Este é seus algoritmos de ZRAM (disponiveis):"

if [ $(lsb_release -si 2>/dev/null) = "openSUSE" ]; then
    sudo systemctl enable --now zramswap.service
    sudo modprobe zram
    sudo swapon /dev/zram0
else
    sudo modprobe zram
    sudo zramswapon
fi

cat /sys/block/zram0/comp_algorithm