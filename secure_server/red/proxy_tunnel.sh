#!/bin/bash

if [ "$#" -ne 3 ];then
    echo "Usage: ./proxy.sh <user> <port> <client>";
    exit 0
fi

ssh -J $1@users.deterlab.net -D 127.0.0.1:$2 $1@$3.OffTech.isi.deterlab.net -N -f

chromium --proxy-server=socks://localhost:$2