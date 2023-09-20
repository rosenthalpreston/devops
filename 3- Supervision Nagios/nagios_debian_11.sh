


# Se mettre en root voir créer un mot de passe root pour les nouvelles installations
su

#Prerequisites
    #Perform these steps to install the pre-requisite packages.

"""===== 9.x / 10.x / 11.x ====="""

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
This creates the nagios user and group. The www-data user is also added to the nagios group.

make install-groups-users
usermod -a -G nagios www-data
 

Install Binaries
This step installs the binary files, CGIs, and HTML files.

make install
 

Install Service / Daemon
This installs the service or daemon files and also configures them to start on boot.

make install-daemoninit
 

Information on starting and stopping services will be explained further on.

 

Install Command Mode
This installs and configures the external command file.

make install-commandmode
 

Install Configuration Files
This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.

make install-config
 

Install Apache Config Files
This installs the Apache web server configuration files and configures the Apache settings.

make install-webconf
a2enmod rewrite
a2enmod cgi
 

Configure Firewall
You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.

iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
apt-get install -y iptables-persistent
Answer yes to saving existing rules

 

Create nagiosadmin User Account
You'll need to create an Apache user account to be able to log into Nagios.

The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
