#!/bin/bash

# primary.sh
# Secundaire set-up Salt Minion

# Alvast klaarzetten van het IP adres van de minion voor later gebruik
ipAddress="$(ip -4 -o address | grep 10.8 | awk '{print $4}' | cut -d/ -f1)"

# Updaten van de repositories en het minion systeem
sudo apt update -y && sudo apt upgrade -y

# Installeren van Nagios NRPE
sudo apt install nagios-nrpe-server -y

# Installeren van Docker middels installatiescript van Docker zelf.
sudo curl -fsSL https://get.docker.com/ | sh
sudo service docker restart

# Het aanmaken van een plaats voor de Wordpress container
mkdir ~/wordpress && cd ~/wordpress

# Downloaden van Maria Image en pre-configuratie van MariaDB
sudo docker run -e MYSQL_ROOT_PASSWORD=WordpressDB -e MYSQL_DATABASE=wordpressdb --name mariadb -v "$PWD/database":/var/lib/mysql -d mariadb:latest

# Starten van het Maria database systeem.
sudo docker start mariadb

# Downloaden Wordpress Image bij Docker
sudo docker pull wordpress

# Aanmaken content delivery map voor de Docker Wordpress installatie & installeren Wordpress en koppeling naar MariaDB.
sudo mkdir -p /var/www/html
cd /var/www/html
sudo docker run -e WORDPRESS_DB_PASSWORD=WordpressDB --name wordpress --link mariadb:mysql -p $ipAddress:80:80 -v "$PWD":/var/www/html -d wordpress


