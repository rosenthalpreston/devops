#!/bin/bash

# Mise à jour des paquets
sudo apt-get update

# Installation des prérequis pour Nagios Core
sudo apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.4 libgd-dev openssl libssl-dev

# Installation des prérequis pour les plugins Nagios
sudo apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

# Téléchargement de la source de Nagios Core
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
tar xzf nagioscore.tar.gz

# Compilation et installation de Nagios Core
cd /tmp/nagioscore-nagios-4.4.14/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled

# Vérification des demandes éventuelles du Network Manager
sudo make all
sudo make install-groups-users
sudo usermod -a -G nagios www-data
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi

# Vérification des demandes éventuelles du Network Manager
sudo ufw allow Apache
sudo ufw reload
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Démarrage du serveur web Apache
sudo systemctl restart apache2.service

# Démarrage du service / daemon Nagios Core
sudo systemctl start nagios.service

# Téléchargement de la source des plugins Nagios
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz
tar zxf nagios-plugins.tar.gz

# Compilation et installation des plugins Nagios
cd /tmp/nagios-plugins-release-2.4.6/
./tools/setup
./configure
make
sudo make install

# Prérequis installation NRPE
# Assurez-vous d'avoir les packages suivants installés.

apt-get update
apt-get install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget

# Téléchargement de la source
cd /tmp
wget --no-check-certificate -O nrpe.tar.gz https://github.com/NagiosEnterprises/nrpe/archive/nrpe-4.1.0.tar.gz
tar xzf nrpe.tar.gz

# Compilation
# Notez que si vous souhaitez transmettre des arguments via NRPE, vous devez le spécifier dans l'option de configuration comme indiqué ci-dessous. Si vous préférez, vous pouvez omettre le drapeau --enable-command-args. En supprimant ce drapeau, il sera nécessaire de définir explicitement tous les arguments dans le fichier nrpe.cfg de chaque serveur surveillé.

cd /tmp/nrpe-nrpe-4.1.0/
./configure --enable-command-args
make all
