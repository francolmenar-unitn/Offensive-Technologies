#!/bin/bash
sudo apt-get update --fix-missing
sudo apt-get install icedtea-netx-common icedtea-netx traceroute -y
sudo rm /home/test -r
sudo mkdir /home/test
sudo cp * /home/test -r
sleep 5
bash /home/test/server.sh </dev/null &>/dev/null &
