# IP Address to be used
IP1=172.16.16.2
# The node to be connected to
Connection1="NWrouter"
# Netmask to be used
NETMASK=255.255.255.248

# Ask to the user to introduce the correct interface - according to map.txt
echo "What interface do you want to connect to ${Connection1}?"
read Interface1


# Apply the IP Addresses to the given interface
ifconfig "${Interface1}" "${IP1}" netmask "${NETMASK}"
echo "${Interface1} connected to ${Connection1} using ${IP1}"

