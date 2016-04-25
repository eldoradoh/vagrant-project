#!/bin/bash


RED='\033[01;31m'
RED_BACK='\033[01;41m'
YELLOW='\033[01;33m'
YELLOW_BACK='\033[01;43m'
GREEN='\033[01;32m'
GREEN_BACK='\033[01;42m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

clear
echo -e -n "${BOLD}${YELLOW}"
echo "///////////////////////////////////////////////////////"
#echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
tput sgr0
echo -e -n "${YELLOW_BACK}"
echo "\\\/\//elcome"
echo "'\\/\/'"
tput sgr0
echo -e -n "${YELLOW}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
date
echo "-------------------------------------------------------"
#uptime | awk '{print $2",",$3,$4,$8,$9,$10,$11,$12}'
uptime | awk '{print "Uptime"":",$3,$4,$5,$8,$9,$10,$11,$12}'
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
tput sgr0
echo -e -n "${GREEN_BACK}"
echo "<{ USER INFO }>"
tput sgr0
echo -e -n "${GREEN}"
echo "-------------------------------------------------------"
tput sgr0
echo -e -n "${GREEN}Username:\t\t"
tput sgr0
whoami
echo -e -n "${GREEN}Shell:\t\t\t"
tput sgr0
echo $SHELL
echo -e -n "${GREEN}Home directory:\t\t"
tput sgr0
eval echo ~$USER
echo -e -n "${GREEN}Total logged:\t\t"
tput sgr0
last | grep "$(whoami)" | wc -l
echo -e -n "${GREEN}Host IP:\t\t"
tput sgr0
#who -u | grep "$(whoami)" | egrep -Eo "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"
#who -u | grep "$(whoami)" | awk '{print $7}' | tr -d "()"

### FOR PETLJA ZA PRINTANJE AKTIVNIH SESIJA PO KORISNIKU IZ NIZA hostss
#hostss_count=$(who -u | grep "vagrant" | awk '{print $7,$8}' | tr -d "()" | awk 'END{print NR}')
hostss_count=$(who -u | grep "$(whoami)" | egrep -Eo "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" | tr -d "()" | awk 'END{print NR}')
for i in hostss_count
do
#hostss[i]=$(who -u | grep "vagrant" | awk '{print $7,$8}' | tr -d "()")
hostss[i]=$(who -u | grep "$(whoami)" | egrep -Eo "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" | tr -d "()")
echo ${hostss[$i]}
done
######################## END ###############################


echo -e -n "${YELLOW}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
tput sgr0
echo -e -n "${RED_BACK}"
echo "<{ SERVER INFO }>"
tput sgr0
echo -e -n "${RED}"
echo "-------------------------------------------------------"
tput sgr0
echo -e -n "${RED}Release:\t\t"
tput sgr0
lsb_release -r | awk '{print $2}'
echo -e -n "${RED}Codename:\t\t"
tput sgr0
lsb_release -c | awk '{print $2}'
echo -e -n "${RED}Hostname:\t\t"
tput sgr0
hostname
echo -e -n "${RED}Kernel:\t\t\t"
tput sgr0
uname -rm
#echo -e -n "${RED}RAM(MB):\t\t"
#tput sgr0
#free -m | grep 'Mem:' | awk '{print $2}'

RAMtotal=$(cat /proc/meminfo |grep 'MemTotal' |awk -F' ' '{print int((($2/1024)+256)/256)*256}')
RAMfree=$(cat /proc/meminfo |grep 'MemFree' |awk -F' ' '{print int((($2/1024)+256)/256)*256}')
RAMused=$(($RAMtotal-$RAMfree))

echo -e -n "${RED}RAM(MB):\t\t"
tput sgr0
echo "$RAMtotal"

echo -e -n "${RED}Used memory:\t\t"
tput sgr0
echo "$RAMused"
echo -e -n "${RED}Logged users:\t\t"
tput sgr0
who | wc -l
echo -e -n "${RED}Active process:\t\t"
tput sgr0
ps aux | wc | awk '{ print $1 }'
echo -e -n "${RED}Address:\t\t"
tput sgr0

### FOR PETLJA ZA PRINTANJE DOSTUPNIH IP ADRESA IZ NIZA ipaddress
ipaddress_count=$(/sbin/ifconfig -a | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | egrep -v '127.0.0.1|localhost' | awk 'END{print NR}')
for i in ipaddress_count
do
ipaddress[i]=$(/sbin/ifconfig -a | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | egrep -v '127.0.0.1|localhost')
echo ${ipaddress[$i]}
done
######################## END ###############################

### FOR PETLJA ZA PRINTANJE DOSTUPNIH MREŽA IZ NIZA networks
echo -e -n "${RED}Network:\t\t"
tput sgr0
network_count=$(ip route show | grep 'eth*' | grep '/' | awk 'END{print NR}')
for i in network_count
do
networks[i]=$(ip route show | grep 'eth*' | grep '/' | awk '{print $1}')
echo ${networks[$i]}
done
######################## END ###############################

### FOR PETLJA ZA PRINTANJE DOSTUPNIH GATEWAYS IZ NIZA iproutes
echo -e -n "${RED}Gateway:\t\t"
tput sgr0
iproute_count=$(ip route show | grep via | awk 'END{print NR}')
for i in iproute_count
do
iproutes[i]=$(ip route show | grep via | awk '{print $1,"=>",$3}')
echo -e ${iproutes[$i]}
done
######################## END ###############################

#domain=$(dig local.mojatv.ba | grep 'SOA' | awk '{print $1}')
#ns=$(dig local.mojatv.ba | grep 'SOA' | awk '{print $5}')
hostname=$(hostname)
#prv_hostname=$hostname.$domain

#echo -e -n "${RED}Domain(prv):\t\t"
#tput sgr0
#echo "$domain"

#echo -e -n "${RED}NS(prv):\t\t"
#tput sgr0
#echo "$ns"

echo -e -n "${RED}DNS Server Address:\t"
tput sgr0
ns_address=$(dig 127.0.0.1 | grep 'SERVER' | egrep -Eo "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" | sed 1d)
ns_name=$(host $ns_address | awk {'print $5'})
echo $ns_address

#echo -e -n "${RED}DNS Server Name:\t"
#tput sgr0
#echo $ns_name

#echo -e -n "${RED}Qualified hostname:\t"
#tput sgr0
#echo "$prv_hostname"

echo -e "${RED}${UNDERLINE}Disk usage:"
tput sgr0
tput sgr0
df -h | egrep "Filesystem|sda*"

echo -e "${RED}${UNDERLINE}Mounted:"
tput sgr0
mount -l | grep -v "sda*"

echo -e -n "${BOLD}${YELLOW}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#echo '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\'
tput sgr0
echo ""
