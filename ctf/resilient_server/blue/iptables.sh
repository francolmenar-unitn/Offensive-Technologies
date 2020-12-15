#################################################################
# Before executing save the previous configuration 				#
# in order to restore it (in case of emergency), 				#
# through: /sbin/iptables-save > iptables-works					#
# apply this with: /sbin/iptables-restore < iptables.dump		#
#################################################################

#Set a default DROP policy
#*filter

#!/bin/bash

sudo iptables -F

sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Accept any related or established connections
#sudo iptables -I INPUT 1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#sudo iptables -I OUTPUT 1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow all traffic on the loopback interface
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Drop invalid packets
#sudo iptables -A PREROUTING -m conntrack --ctstate INVALID -j DROP

# Drop TCP packets that are new and are not SYN
#sudo iptables -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

# Block packets with bogus TCP flags
#sudo iptables -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
#sudo iptables -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# Allow outbound DHCP request
#sudo iptables -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# Allow inbound SSH - without we cannot connect to the host
sudo iptables -A INPUT -p tcp -m tcp -s 10.1.0.0/16 --dport 22 -m conntrack --ctstate NEW -j DROP
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW, ESTABLISHED -j ACC
# Outbound DNS lookups
sudo iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

# Outbound PING requests - we can block them as they should make requests
# -A OUTPUT -p icmp -j ACCEPT

# Outbound Network Time Protocol (NTP) requests
sudo iptables -A OUTPUT -p udp --dport 123 --sport 123 -j ACCEPT

# Outbound HTTP only on port 80
sudo iptables -A OUTPUT -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT

# Restrict the number of connections (to 20) per single IP address
sudo iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 32 -j REJECT 
--reject-with tcp-reset

# Limit NEW TCP connections per seconds
sudo iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT

# Drop excessive RST packets to avoid smurf attacks
sudo iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Restrict input - only the client1 with tcp can pass
sudo iptables -A FORWARD -s 10.1.2.2 -j ACCEPT
sudo iptables -A FORWARD -s 10.1.3.2 -j ACCEPT
sudo iptables -A FORWARD -s 10.1.4.2 -j ACCEPT

#Should we consider ipv6? We can drop everything on there
#ipt6 -P INPUT DROP ipt6 -P FORWARD DROP ipt6 -P OUTPUT ACCEPT

# I am not blocking portScan

# Should we block bogus TCP flags?

#COMMIT

