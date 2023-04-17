#!/bin/bash
#You go into your router configuration and forward port 80 to the LAN IP of the computer running the web server.
#Then anyone outside your network (but not you inside the network) can access your site using your WAN IP address
#Open port: https://www.digitalocean.com/community/tutorials/opening-a-port-on-linux
#Reverse shell: https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
#Enavle portforwarding: https://askubuntu.com/questions/311142/port-forward-in-terminal-only
h=$(date +"%H:%M")
var2=$13:50
while true
do
	if [ "$h" == "13:52" ]; then
		echo "E' ora"
	else
		h=$(date +"%H:%M")
		echo "Non ancora"
		echo $h
	fi
done
