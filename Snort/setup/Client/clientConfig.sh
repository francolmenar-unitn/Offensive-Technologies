#!/bin/bash
sudo apt-get update --fix-missing
sudo apt-get install icedtea-netx-common icedtea-netx traceroute -y
sudo rm /home/test -r
sudo mkdir /home/test
sudo cp * /home/test -r
sudo chmod 777 /home/test
sleep 10
bash /home/test/runClient.sh </dev/null &>/dev/null &
