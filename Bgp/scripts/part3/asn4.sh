#!/usr/bin/env bash

telnet localhost bgpd

enable   #type "test" when prompted for password
config terminal
router bgp 65004
no network 10.1.0.0/16
network 10.1.1.0/24
end
exit

###### Once it is exit

sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -d 10.1.1.2 -m ttl --ttl-gt 1 -j NETMAP --to 10.6.1.2
sudo iptables -t nat -A POSTROUTING -s 10.6.1.2 -j NETMAP --to 10.1.1.2