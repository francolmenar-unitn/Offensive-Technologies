#!/bin/bash

if [ "$#" -ne 2 ];then
    echo "Usage: ./spoofer.sh <spoofed> <original>";
    exit 0
fi

spoofed=$1
original=$2

sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -d $spoofed -j DNAT --to-destination $original
sudo iptables -t nat -A POSTROUTING -j SNAT --to-source $spoofed