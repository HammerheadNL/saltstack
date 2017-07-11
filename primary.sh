#!/bin/bash

# primary.sh
# Initiële set-up Salt Minion

# Ophalen hostname machine en toevoegen aan lokale hostsfile onder localhost definitie
configuredHostname="$(hostname)"
sudo sed -i.bak "/127.0.0.1 localhost/ i\127.0.0.1 $configuredHostname" /etc/hosts

# Opslaan van het IP adres voor later gebruik
ipAddress="$(ip -4 -o address | grep 10.8 | awk '{print $4}' | cut -d/ -f1)"
echo $ipAddress>/home/ubuntu/localip.txt

# Up-to-date brengen van het systeem & installeren curl voor later gebruik bij Docker bootstrap script.
sudo apt update -y && sudo apt upgrade -y
sudo apt install curl -y

# Installeren van Salt Minion pakketten
sudo apt install salt-minion -y

# Clonen van de GIT repository en overzetten minion configuratie
sudo git clone https://github.com/HammerheadNL/saltstack.git
sudo cp -f /home/ubuntu/saltstack/minion/minion /etc/salt

# Het secundaire set-up script uitvoerbaar maken
sudo chmod +x /home/ubuntu/saltstack/secondary.sh

# Starten van de salt-minion daemon
sudo salt-minion -d
