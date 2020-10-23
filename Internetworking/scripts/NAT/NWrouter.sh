# Configuring NWrouter as a NAT - Change ethX to the corresponding interface
iptables -t nat -A POSTROUTING -o ethX -s 172.16.16.0/29 -j SNAT --to 2.4.6.10