#!/bin/bash
#Dns: https://www.howtoforge.com/how-to-setup-local-dns-server-using-dnsmasq-on-ubuntu-20-04/
#		https://askubuntu.com/questions/53523/how-to-redirect-a-url-to-a-custom-ip-address
#		https://stackoverflow.com/questions/41739211/resolve-non-exist-domain-name-to-local-ip-using-dnsmasq
		#Add certificate to fake page

#get current hour
while true
	do
	h=$(date +"%H:%M")
	#set schedule 
	port=4000
	start="14:04"

	if [ "$h" == $start ]; then
		echo "Enabling portforwarding on port $port..."
		#iptables -A INPUT -p tcp --dport $port -j ACCEPT
		echo "Start listening..."
		#nc -l -p $port
		while [ "$h" != "14:00" ];
		do
			h=$(date +"%H:%M")
			echo "Listening..."
		done
	else
		h=$(date +"%H:%M")
		echo "Do nothing"
	fi
done
