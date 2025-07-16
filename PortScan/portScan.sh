#!/bin/bash

# Funzione per gestire l'interruzione con Ctrl+C
function ctrl_c() {
    echo -e "\n\n[!] Saliendo... \n"
    tput cnorm          # Ripristina il cursore visibile
    exit 1
}

# Imposta il trap per catturare il segnale SIGINT (Ctrl+C)
trap ctrl_c SIGINT

# Definisce un array con tutte le porte da 1 a 65535
declare -a ports=( $(seq 1 65535) )

# Funzione che verifica se una porta è aperta sul target specificato
function checkPort() {
    # Prova ad aprire un file descriptor TCP su IP ($1) e porta ($2)
    (exec 3<>/dev/tcp/$1/$2) 2>/dev/null

    # Se il comando precedente ha successo (porta aperta)
    if [ $? -eq 0 ]; then
        echo "[+] Host $1 - Port $2 (OPEN)"
    fi

    # Chiude il file descriptor 3 aperto in precedenza
    exec 3<&-
    exec 3>&-
}

# Verifica che sia stato passato un indirizzo IP come argomento
if [ -z "$1" ]; then
    echo -e "\n [!] Uso: $0 <ip-address>\n"
    exit 1
fi

# Nasconde il cursore nel terminale per una visualizzazione più pulita
tput civis

# Cicla tutte le porte e avvia la scansione in background per ogni porta
for port in "${ports[@]}"; do
    checkPort "$1" "$port" &
done

# Attende il completamento di tutti i processi in background
wait

# Ripristina il cursore visibile al termine della scansione
tput cnorm

