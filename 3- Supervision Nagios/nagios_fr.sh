# Se mettre en root voir créer un mot de passe root pour les nouvelles installations
su
apt update && apt install -y sudo
sudo apt update && sudo apt install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev openssl libssl-dev iptables-persistent libmcrypt-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext

# Téléchargement de la source de Nagios Core
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
tar xzf nagioscore.tar.gz
cd nagioscore-nagios-4.4.14/

# Compilation et installation de Nagios Core
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install-groups-users
usermod -a -G nagios www-data
make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
a2enmod rewrite
a2enmod cgi

# Configuration du pare-feu
iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

# Création d'un compte utilisateur pour l'interface web de Nagios
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Redémarrage des services
systemctl restart apache2.service
systemctl start nagios.service

# Téléchargement et installation des plugins Nagios
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz
tar zxf nagios-plugins.tar.gz
cd nagios-plugins-release-2.4.6/
./tools/setup
./configure
make
make install

# Commandes pour gérer le service Nagios
systemctl start nagios.service
systemctl stop nagios.service
systemctl restart nagios.service
systemctl status nagios.service
