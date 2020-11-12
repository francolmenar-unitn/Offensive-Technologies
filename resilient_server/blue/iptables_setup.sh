#!/bin/bash

## FLUSH ALL EXISTING RULES
sudo iptables --flush

## SET DEFAULT POLICY TO DROP
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

## ALLOW LOOPBACK TRAFFIC
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

## USE HASHLIMIT MODULE TO PUT LIMITS ON THE AMOUNT OF TRAFFIC PER SOURCE IP THAT CAN REACH THE SERVER
sudo iptables --new-chain RATE-LIMIT

## TCP CONNECTIONS
### ALL NEW CONNECTIONS JUMP TO THE RATE-LIMIT TABLE
sudo iptables -A INPUT -m conntrack --ctstate NEW -j RATE-LIMIT

### IF A SINGLE IP SENDS CAN SEND ONLY 10 P/S
### IF IT EXCEEDS THIS LIMIT THEN THE CONNECTIONS ARE LOGGED AND DROPPED
sudo iptables -A RATE-LIMIT --match hashlimit --hashlimit-mode srcip --hashlimit-upto 10/sec --hashlimit-burst 20 --hashlimit-name conn_rate_limit -j ACCEPT
sudo iptables --append RATE-LIMIT --jump LOG --log-prefix "DROPPED IP-Tables connections: "
sudo iptables -A RATE-LIMIT -j DROP

## UDP CONNECTIONS
sudo iptables -A INPUT -p udp --dport 80 -j DROP

## ICMP CONNECTIONS
iptables -A INPUT -p icmp -m hashlimit --hashlimit-name icmp --hashlimit-mode srcip --hashlimit 3/second --hashlimit-burst 5 -j ACCEPT

## ALLOW SSH CONNECTIONS FROM IP ADDRESS
sudo iptables -A INPUT -s <ip> -p tcp --dport 22 -m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -d <ip> -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

## ALLOW HTTP CONNECTIONS FROM IP ADDRESS
sudo iptables -A INPUT -s <ip> -p tcp --dport 80 -m conntract --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -d <ip> -p tcp --sport 80 -m connstract --ctstate ESTABLISHED -j ACCEPT




