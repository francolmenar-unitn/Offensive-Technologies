#!/bin/bash

ETH_SERVER=$(ip route get 10.1.5.3 | grep 10.1.5.3 | awk '{print $5}')
ETH_ROUTER=$(ip route get 10.1.1.3 | grep 10.1.1.3 | awk '{print $5}')
ETH_DLAB=$(ip a | grep 192.168 | tail -c 5)

## SET DEFAULT POLICY TO ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

## FLUSH ALL EXISTING RULES
sudo iptables -F

## ALLOW LOOPBACK TRAFFIC
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

## ALLOW SSH CONNECTIONS 
sudo iptables -A INPUT -i $ETH_DLAB -j ACCEPT
sudo iptables -A OUTPUT -o $ETH_DLAB -j ACCEPT

## TCP CONNECTIONS
### ALL NEW CONNECTIONS JUMP TO THE RATE-LIMIT CHAIN
### EXISTING CONNECTIONS ARE ALLOWED TO PASS
sudo iptables -A FORWARD -i $ETH_ROUTER -s 10.1.2.2,10.1.3.2,10.1.4.2 -d 10.1.5.2 -o $ETH_SERVER -p tcp --dport 80 -m conntrack --ctstate NEW -j RATE-LIMIT
sudo iptables -A FORWARD -i $ETH_ROUTER -o $ETH_SERVER -p tcp --dport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $ETH_SERVER -o $ETH_ROUTER -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

## ICMP CONNECTIONS
### ALL ICMP ECHO REQUESTS ARE LIMITED AND SENT TO THE RATE-LIMIT CHAIN
### ECHO REPLIES ARE ALLOWED TO PASS
sudo iptables -A INPUT -i $ETH_ROUTER -p icmp -m hashlimit --hashlimit-name icmp --hashlimit-mode srcip --hashlimit 100/second --hashlimit-burst 5 -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
sudo iptables -A FORWARD -i $ETH_ROUTER -o $ETH_SERVER -p icmp -m hashlimit --hashlimit-name icmp --hashlimit-mode srcip --hashlimit 3/second --hashlimit-burst 5 -j ACCEPT
sudo iptables -A FORWARD -i $ETH_SERVER -o $ETH_ROUTER -p icmp --icmp-type echo-reply -j ACCEPT

## RATE LIMIT CHAIN
### IF A SINGLE IP SENDS CAN SEND ONLY 10 P/S
### IF IT EXCEEDS THIS LIMIT THEN THE CONNECTIONS ARE LOGGED AND DROPPED
sudo iptables -A RATE-LIMIT --match hashlimit --hashlimit-mode srcip --hashlimit-upto 10/sec --hashlimit-burst 20 --hashlimit-name conn_rate_limit -j ACCEPT
sudo iptables -A RATE-LIMIT  -m limit --limit 5/min -j LOG --log-prefix "DROPPED IP-Tables connections: "
sudo iptables -A RATE-LIMIT -j DROP

## SET DEFAULT POLICY TO DROP
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP
