#!/bin/bash

# Palette Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Controllo parametri
if [ $# -lt 3 ]; then
    echo -e "${YELLOW}Uso: $0 <IP> <PUERTO_INICIAL> <PUERTO_FINAL> [TIMEOUT]${NC}"
    echo -e " Ej: ${GREEN}$0 192.168.168.2 20 1000${NC} (timeout por defecto: 1s)"
    exit 1
fi

# Variabili
ip=$1
port_start=$2
port_end=$3
timeout_val=${4:-1}

echo -e "${BLUE}[*] Escaneando puertos abiertos en $ip desde $port_start a $port_end...${NC}"

for port in $(seq $port_start $port_end); do
    (
        timeout $timeout_val bash -c "echo >/dev/tcp/$ip/$port" 2>/dev/null
        if [ $? -eq 0 ]; then
            service=$(timeout $timeout_val nc -vnz $ip $port 2>&1 | grep -oP "(?<=\))\s+\K.*")
            echo -e "${GREEN}[+] Puerto $port abierto${NC} - Servicio: ${service:-Desconocido}"
        fi
    ) &
done

wait

