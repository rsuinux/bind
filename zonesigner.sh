#!/bin/sh 
# ----------------------------
# source: 
#   https://www.digitalocean.com/community/tutorials/how-to-setup-dnssec-on-an-authoritative-bind-dns-server--2
# ----------------------------

PDIR=`pwd` 
# ZONEDIR="/var/cache/bind" 
ZONEDIR="/var/named/"
#location of your zone files 
ZONE=$1 
ZONEFILE=$2 
DNSSERVICE="bind9" 
#On CentOS/Fedora replace this with "named" 
cd $ZONEDIR 
SERIAL=`/usr/sbin/named-checkzone $ZONE $ZONEFILE | egrep -ho '[0-9]{10}'` sed -i 's/'$SERIAL'/'$(($SERIAL+1))'/' 
$ZONEFILE /usr/sbin/dnssec-signzone -A -3 $(head -c 1000 /dev/urandom | sha1sum | cut -b 1-16) -N increment -o $1 -t $2 
rndc -s 127.0.0.1 reload 
cd $PDIR 
