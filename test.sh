#!/bin/bash

# Imposta la rete da scansionare
NETWORK="192.168.1.0/24"

# Scansiona la rete per trovare gli indirizzi IP attivi
ACTIVE_IPS=$(nmap -sP $NETWORK | awk '/is up/ {print $2}')

# Cicla su tutti gli indirizzi IP attivi
for ip in $ACTIVE_IPS; do
    # Verifica se l'indirizzo IP appartiene ad un dispositivo Windows
    NAME=$(nbtscan -s : $ip | awk '/[[:alnum:]]+/ {print $1}')
    if [[ $NAME != "" ]]; then
        # Invia una notifica se viene trovato un dispositivo Windows
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Dispositivo Windows trovato: %0A$NAME %0AIp: $ip"		
    fi
    
    # Verifica se l'indirizzo IP appartiene ad una Smart TV
    RESPONSE=$(upnpc -s | grep -E "(Device Type:.*SmartTV|MODEL_NAME)")
    if [[ $RESPONSE != "" ]]; then
        # Estrae il modello e la marca della Smart TV
        MODEL=$(echo "$RESPONSE" | awk -F: '/MODEL_NAME/ {print $2}')
        BRAND=$(echo "$RESPONSE" | awk -F: '/SmartTV/ {print $2}')
        
        # Invia una notifica se viene trovata una Smart TV
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Smart TV trovata: Marca: $BRAND%0AModello: $MODEL%0AIndirizzo IP: $ip"		
    fi
done
