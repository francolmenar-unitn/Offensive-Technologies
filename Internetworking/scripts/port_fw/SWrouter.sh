# Set port forwarding on SWrouter to access the web browsers at NWrouter
# Change ethZ to the corresponding interface
iptables -t nat -A PREROUTING -i ethZ -d 3.5.7.18/32 -p tcp --dport 80 -j DNAT --to 10.0.0.2