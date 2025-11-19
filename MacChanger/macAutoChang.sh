#!/bin/bash

pidfile="/tmp/macchanger.pid"

change_loop() {
    while true; do
        sudo ip link set "$iface" down
        sudo macchanger -r "$iface"
        sudo ip link set "$iface" up
        echo "MAC cambiada. Esperando $minutes minuto(s)..."
        sleep "${minutes}m"
    done
}

clear
echo "====== SCRIPT CAMBIO MAC ======"

if ! command -v macchanger &>/dev/null; then
    echo "Instalando macchanger..."
    sudo apt update && sudo apt install -y macchanger
fi

while true; do
    echo ""
    echo "====== MENU MAC CHANGER ======"
    echo "1) Mostrar interfaces de red"
    echo "2) Ver MAC actual de una interfaz"
    echo "3) Cambiar MAC a una aleatoria"
    echo "4) Cambiar MAC a una con mismo fabricante"
    echo "5) Restaurar MAC original (permanente)"
    echo "6) Cambiar MAC automáticamente cada X minutos"
    echo "7) Detener cambio MAC automático"
    echo "8) Salir"
    echo "=============================="
    read -rp "Selecciona una opción: " opt

    case $opt in
        1)
            echo "Interfaces disponibles:"
            ip link show | grep -E '^[0-9]+:' | awk -F: '{print $2}' | sed 's/^ //'
            ;;
        2)
            read -rp "Interfaz (ej: eth0): " iface
            macchanger -s "$iface"
            ;;
        3)
            read -rp "Interfaz (ej: eth0): " iface
            sudo ip link set "$iface" down
            sudo macchanger -r "$iface"
            sudo ip link set "$iface" up
            ;;
        4)
            read -rp "Interfaz (ej: eth0): " iface
            sudo ip link set "$iface" down
            sudo macchanger -a "$iface"
            sudo ip link set "$iface" up
            ;;
        5)
            read -rp "Interfaz (ej: eth0): " iface
            sudo ip link set "$iface" down
            sudo macchanger -p "$iface"
            sudo ip link set "$iface" up
            ;;
        6)
            read -rp "Interfaz (ej: eth0): " iface
            read -rp "Cada cuántos minutos cambiar la MAC?: " minutes
            change_loop &
            changer_pid=$!
            echo "$changer_pid" > "$pidfile"
            echo "Cambio MAC automático iniciado en segundo plano con PID $changer_pid"
            echo "Puedes seguir usando el menú..."
            ;;
        7)
            if [ -f "$pidfile" ]; then
                changer_pid=$(cat "$pidfile")
                if ps -p "$changer_pid" > /dev/null; then
                    kill "$changer_pid"
                    echo "Proceso automático detenido (PID $changer_pid)."
                else
                    echo "El proceso no está activo. Eliminando archivo PID."
                fi
                rm -f "$pidfile"
            else
                echo "No hay ningún proceso de cambio MAC automático en ejecución."
            fi
            ;;
        8)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
done
