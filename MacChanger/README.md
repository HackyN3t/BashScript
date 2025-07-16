# MacAutoChang.sh

Script Bash per la gestione automatica e manuale del MAC address su sistemi Linux, basato su `macchanger`.

---

## Descrizione

Questo script offre un menu interattivo per:

- Visualizzare le interfacce di rete disponibili
- Cambiare il MAC address con valori casuali o specifici
- Automatizzare il cambio MAC periodico con intervalli configurabili
- Fermare il cambio automatico in esecuzione

È pensato per attività di testing, privacy e pentesting.

---

## Requisiti

- Linux (distribuzioni basate su Debian raccomandate)
- `macchanger` installato (lo script può installarlo automaticamente)
- Permessi sudo per modifiche MAC

---

## Uso

1. Rendi eseguibile lo script:

```bash
chmod +x MacAutoChang.sh
