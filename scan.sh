#!/bin/bash
wget -q --spider http://google.com
current_date=$(date "+%d-%m-%Y")
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
echo "Lo script è collocato nella directory: $SCRIPT_DIR"
if [ $? -eq 0 ]; then
	echo "Internet ok"
	# Installing dependencies
	echo "Install dependencies"
	opkg update
	opkg install nmap
	echo "Dependencies ok"
	sleep 1
	# Crea un file di testo sulla scheda SD per memorizzare i risultati
	echo "Start scanning..."
	nmap_output_file="nmap_scan_$current_date.txt"
	touch $nmap_output_file
	# Assegna l'indirizzo IP ottenuto dall'ethernet alla variabile "ip_address"
	ip_address=$(ip addr show wlan0 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f 1)	
	nmap -sS -O -sV $ip_address/24 >> $nmap_output_file
	echo "Scanning complete"

	public_ip=$(curl -s https://ifconfig.me/ip)
	echo "Public ip: $public_ip"

	#send report via telegram
	token=""
	# chat id
	chat_id=""
	# Definisci il percorso completo del file da inviare
	filepath1=$nmap_output_file
	curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="$public_ip"
	# Invia il file alla chat utilizzando il bot di Telegram
	curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
	rm "$filepath1"
	#rm -r "$SCRIPT_DIR"
else
  	echo "Internet not ok"
fi