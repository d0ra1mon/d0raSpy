#!/bin/bash
#Dns: https://www.howtoforge.com/how-to-setup-local-dns-server-using-dnsmasq-on-ubuntu-20-04/
#		https://askubuntu.com/questions/53523/how-to-redirect-a-url-to-a-custom-ip-address
#		https://stackoverflow.com/questions/41739211/resolve-non-exist-domain-name-to-local-ip-using-dnsmasq
		#Add certificate to fake page
#!/bin/bash

# Impostazione del nome del dominio e dell'indirizzo IP
DOMAIN="example.com"
IP="192.168.1.100"

# Verifica se il file di configurazione di dnsmasq esiste
if [ ! -f /etc/dnsmasq.conf ]; then
    echo "Il file di configurazione di dnsmasq non esiste"
    exit 1
fi

# Verifica se l'indirizzo IP è valido
if ! [[ "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "L'indirizzo IP non è valido"
    exit 1
fi

# Aggiunta delle righe di configurazione a dnsmasq.conf
echo "address=/$DOMAIN/$IP" >> /etc/dnsmasq.conf

# Riavvio del servizio dnsmasq
systemctl restart dnsmasq

echo "Reindirizzamento completato con successo"
exit 0


