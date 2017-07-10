#!/bin/bash

# primary.sh
# Initiële set-up Salt Minion

# Ophalen hostname machine en toevoegen aan lokale hostsfile onder localhost definitie
configuredHostname="$(hostname)"
sudo sed -i.bak '/127.0.0.1 localhost/ i\127.0.0.1 $configuredHostname' /etc/hosts

# Opslaan van het IP adres voor later gebruik
ipAddress="$(ip -4 -o address | grep 10.8 | awk '{print $4}' | cut -d/ -f1)"
echo $ipAddress>/home/ubuntu/localip.txt

# Up-to-date brengen van het systeem
sudo apt update && upgrade -y

