#!/bin/bash

sudo apt install python3-setuptools
cd $(find ~ -type d -name "scapy" | head -n 1)
sudo python3 setup.py install