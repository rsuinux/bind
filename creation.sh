#!/bin/sh

if [ ! -f /etc/bind9/sign ]
then
	ZONE="exemple.org"
	fichier_zone="/var/named/exemple.org"
	echo "RNGDEVICE=/dev/urandom" >> /etc/default/rng-tools
	
	cd /etc/bind9
	dnssec-keygen -r /dev/urandom -a NSEC3RSASHA1 -b 2048 -n ZONE $ZONE
	
	dnssec-keygen -r /dev/urandom -f KSK -a NSEC3RSASHA1 -b 4096 -n ZONE $ZONE
	
	mv K* ./clefs
	cd ./clefs
	
	echo "; signature dnssec " >> $fichier_zone
	
	for key in $(ls Kexemple.org*.key)
	do
	       	echo "\$INCLUDE $key" >> $fichier_zone
	done 
	
	dnssec-signzone -A -3 $(head -c 1000 /dev/urandom | sha1sum | cut -b 1-16) -N INCREMENT -o $ZONE -t $fichier_zone
	
	# /usr/sbin/named -g -c /etc/bind/named.conf -u bind
	touch /etc/bind9/sign

	echo "0 0 */3 * * /usr/sbin/zonesigner.sh $ZONE $fichier_zone" > /tmp/cron.txt
        crontab /tmp/cron.txt	
fi
# service bind9 start
named -u bind -g -c /etc/bind/named.conf
