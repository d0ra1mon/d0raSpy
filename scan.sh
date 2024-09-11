#!/bin/ash
#echo $SHELL to see what shell it's use

#This script check the space available and use two different method to scan network:
#	- use ip neigh to scan all network devices without find vulnerabilities, then send a report via telegram
#	- use nmap to scan all network devices and find vulnerabilities, then send a report via telegram
wget -q --spider http://google.com
current_date=$(date "+%d-%m-%Y")
if [ $? -eq 0 ]; then
	# Telegram bot info
	token=""
	chat_id=""
	wifi_interface="br-lan" # to be change in base of wireless interface of router

	echo "Internet ok"

	echo "Check space available..."
    # Get memory in KiB
    mem=$(df -k | awk '$NF=="/overlay"{print $4}')
    # Remove characters
    mem_kb=$(echo $mem | awk '{print int($1)}')
    # Convert KiB to MB 
    mem_mb=$(expr $mem_kb / 1024)

    # Check if the value is less than 5
    if [ "$mem_mb" -lt 5 ]; then
        echo "Available memory less than 5MB"
        echo "    - Nmap will not be installed"
        opkg update
        opkg install openssh-sftp-server #51.21 KiB KiB
        opkg install libmbedtls #217.33 KiB
        opkg install curl #57.56 KiB
        opkg install ip-tiny #119.81 KiB
        opkg install tcpdump #281.03 KiB  
        echo "Dependencies ok"

        # Get public ip
        public_ip=$(curl -s https://ifconfig.me/ip)

        echo "Create Report..."
        # Create file report
        report="report_$public_ip.txt"
        touch $report
        # Get and Save system info
        uname -a >> $report 
        # Get and Save public ip
        echo "Public Ip:" $public_ip >> $report 
        echo >> $report
        # Get and Save interface info
        ifconfig >> $report 
        # Get and Save devices connected
        ip neigh | awk '{ if ($5 ~ /^[0-9a-f]{2}(:[0-9a-f]{2}){5}$/) { print "Ip: "$1 "\n Interface: "$3 "\n Mac: "$5 "\n Route: "$6 "\n" } }' >> $report
        echo "Task complete"

        echo "Send Report..."
        #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Report: $public_ip"
        #curl -F chat_id="$chat_id" -F document=@"$report" "https://api.telegram.org/bot$token/sendDocument"

        # Delete the directory
   		#rm -rf ./*
        exit 1
    fi 
	
	# Installing dependencies
	echo "Install dependencies"
	opkg update
	opkg install nmap-full
	opkg install curl
	echo "Dependencies ok"

	# Get public ip	
	public_ip=$(curl -s https://ifconfig.me/ip)

	# Create a file to save results
    echo "Create Report..."
    # Create file report
    report="report_$public_ip.txt"
    touch $report
    # Get and Save system info
    uname -a >> $report 
    # Get and Save public ip
    echo "Public Ip:" $public_ip >> $report 
    echo >> $report
    # Get and Save interface info
    ifconfig >> $report 

	echo "Start scanning..."
	ip_address=$(ip addr show $wifi_interface | grep 'inet ' | awk '{print $2}' | cut -d '/' -f 1)	
	#Start scanning
	nmap -sS -O -sV -f $ip_address/24 >> $report
	#nmap -sS -O -f $ip_address/24 >> $report
	echo "Scanning complete"

    echo "Send Report..."
    #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Report: $public_ip"
    #curl -F chat_id="$chat_id" -F document=@"$report" "https://api.telegram.org/bot$token/sendDocument"

    # Delete the directory
    #rm -rf ./*
    exit 1
else
  	echo "Internet not ok"
fi
