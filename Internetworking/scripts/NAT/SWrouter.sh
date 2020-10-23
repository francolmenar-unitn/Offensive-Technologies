# Configuring SWrouter as a NAT - Change ethY to the corresponding interface
iptables -t nat -A POSTROUTING -o ethY -s 10.0.0.0/29 -j SNAT --to 3.5.7.18