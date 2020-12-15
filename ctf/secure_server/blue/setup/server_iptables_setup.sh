#!/bin/bash

gateway_interface=$(ip a | grep 10.1.5.2 | tail -c 5)
deterlab_interface=$(ip a | grep 192.168 | tail -c 5)


sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT

## FLUSH ALL EXISTING RULES
sudo iptables -F

## ALLOW LOOPBACK TRAFFIC
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

## ALLOW SSH CONNECTIONS 
sudo iptables -A INPUT -i $deterlab_interface -j ACCEPT
sudo iptables -A OUTPUT -o $deterlab_interface -j ACCEPT

## ALLOW ALL TRAFFIC FROM ROUTER
sudo iptables -A INPUT -s 10.1.1.2 -j ACCEPT
sudo iptables -A OUTPUT -s 10.1.1.2 -j ACCEPT

## BLOCK FRAGMENTED PACKETS
sudo iptables -t mangle -A PREROUTING -f -j DROP

## USE HASHLIMIT MODULE TO PUT LIMITS ON THE AMOUNT OF TRAFFIC PER SOURCE IP THAT CAN REACH THE SERVER
sudo iptables --new-chain RATE-LIMIT

## TCP CONNECTIONS
### ALL NEW CONNECTIONS JUMP TO THE RATE-LIMIT CHAIN
### EXISTING CONNECTIONS ARE ALLOWED TO PASS
sudo iptables -A INPUT -i $gateway_interface -p tcp --dport 80 -m conntrack --ctstate NEW -j RATE-LIMIT
sudo iptables -A INPUT -i $gateway_interface -p tcp --dport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

## ICMP REQUESTS
### ALL NEW CONNECTIONS JUMP TO THE RATE-LIMIT CHAIN
### REPLIES ARE ALLOWED TO PASS
sudo iptables -A INPUT -i $gateway_interface -p icmp -m hashlimit --hashlimit-name icmp --hashlimit-mode srcip --hashlimit 100/second --hashlimit-burst 5 -j RATE-LIMIT
sudo iptables -A OUTPUT -o $gateway_interface -p icmp --icmp-type echo-reply -j ACCEPT

## RATE LIMIT CHAIN
### IF A SINGLE IP SENDS CAN SEND ONLY 10 P/S
### IF IT EXCEEDS THIS LIMIT THEN THE CONNECTIONS ARE LOGGED AND DROPPED
sudo iptables -A RATE-LIMIT -m hashlimit --hashlimit-mode srcip --hashlimit-upto 10/sec --hashlimit-burst 20 --hashlimit-name conn_rate_limit -j ACCEPT
sudo iptables -A RATE-LIMIT -m limit --limit 5/min -j LOG --log-prefix "DROPPED IP-Tables connections: "
sudo iptables -A RATE-LIMIT -j DROP
 
## SET DEFAULT POLICY TO DROP
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP
