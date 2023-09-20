


# Se mettre en root voir créer un mot de passe root pour les nouvelles installations
su
apt install && apt update -y

#Prerequisites
    #Perform these steps to install the pre-requisite packages.

"""===== version debian 9.x / 10.x / 11.x ====="""

apt-get update
apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev
apt-get install openssl libssl-dev
 
    #Téléchargement de la source
su
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
tar xzf nagioscore.tar.gz
 

    #Compilation
cd /tmp/nagioscore-nagios-4.4.14/
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
 

    #Création de l'user et du groupe
# www-data user va être ajouté dans le groupe nagios .

make install-groups-users
usermod -a -G nagios www-data
 

    #Installation des binaires
make install
 


    #cette ligne de commande installe les services et le daemon et les configures pour une éxecution au démarrage.
Install Service / Daemon
make install-daemoninit
 
    #This installs and configures the external command file.
    #Install Command Mode
make install-commandmode
 

    #Install Configuration Files
    #This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.

make install-config
 

    #Install Apache Config Files
    #This installs the Apache web server configuration files and configures the Apache settings.

make install-webconf
a2enmod rewrite
a2enmod cgi
 

    # Configure Firewall
    # You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.

iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
apt-get install -y iptables-persistent
Answer yes to saving existing rules

 

    # Create nagiosadmin User Account
    # You'll need to create an Apache user account to be able to log into Nagios.

    # The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin


    # ===== 8.x / 9.x / 10.x /11.x =====

    # Need to restart it because it is already running.

systemctl restart apache2.service  
Start Service / Daemon

 
    # This command starts Nagios Core.
# ===== 8.x / 9.x / 10.x / 11.x  =====

systemctl start nagios.service

# Installing The Nagios Plugins
    # Prerequisites
    # Make sure that you have the following packages installed.

apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

    # Downloading The Source
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz
tar zxf nagios-plugins.tar.gz
 

    #Compile + Install
cd /tmp/nagios-plugins-release-2.4.6/
./tools/setup
./configure
make
make install

    # Service / Daemon Commands
    # Different Linux distributions have different methods of starting / stopping / restarting / status Nagios.


systemctl start nagios.service
systemctl stop nagios.service
systemctl restart nagios.service
systemctl status nagios.service

