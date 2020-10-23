# IP Addresses to be used
IP1=2.4.6.9
IP2=3.5.7.17
# The nodes to be connected to
Connection1="NWrouter"
Connection2="SWrouter"
# Netmask to be used
NETMASK=255.255.255.248

# Ask to the user to introduce the correct interface - according to map.txt
echo "What interface do you want to connect to ${Connection1}?"
read Interface1

echo "What interface do you want to connect to ${Connection2}?"
read Interface2


# Apply the IP Addresses to the given interfaces
ifconfig "${Interface1}" "${IP1}" netmask "${NETMASK}"
echo "${Interface1} connected to ${Connection1} using ${IP1}"

ifconfig "${Interface2}" "${IP2}" netmask "${NETMASK}"
echo "${Interface2} connected to ${Connection2} using ${IP2}"

