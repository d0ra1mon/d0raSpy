#!/bin/bash
#You go into your router configuration and forward port 80 to the LAN IP of the computer running the web server.
#Then anyone outside your network (but not you inside the network) can access your site using your WAN IP address
#Open port: https://www.digitalocean.com/community/tutorials/opening-a-port-on-linux
#Reverse shell: https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
#Enable portforwarding: https://askubuntu.com/questions/311142/port-forward-in-terminal-only
#Dns: https://www.howtoforge.com/how-to-setup-local-dns-server-using-dnsmasq-on-ubuntu-20-04/
#		https://askubuntu.com/questions/53523/how-to-redirect-a-url-to-a-custom-ip-address
#		https://stackoverflow.com/questions/41739211/resolve-non-exist-domain-name-to-local-ip-using-dnsmasq
#Sensitive file: https://www.beyondtrust.com/blog/entry/important-linux-files-protect
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
