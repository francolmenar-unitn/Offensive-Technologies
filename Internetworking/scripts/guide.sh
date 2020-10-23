###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net 'ssh -tt NWworkstation1.internetworking-f2.OffTech 'sudo su''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt NWrouter.internetworking-f2.OffTech 'sudo su''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt ISrouter.internetworking-f2.OffTech 'sudo su''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt SWrouter.internetworking-f2.OffTech 'sudo su''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt SWworkstation1.internetworking-f2.OffTech 'sudo su''
ssh -tt otech2ae@users.deterlab.net


###################### Obtain the Wiring Map ######################
set -m # To be run if a problem is encountered while running showcabling
/share/shared/Internetworking/showcabling internetworking-f2 offtech > map.txt


###################### Run scripts/ifconfig ######################
####### These commands are to check the correctness of the scripts/ifconfig
ping 2.4.6.10  # ISrouter
ping 3.5.7.17

ping 172.16.16.2  # NWrouter

ping 10.0.0.2  # SWrouter


###################### Run scripts/route ######################
####### These commands are to check the correctness of the scripts/route
ping 10.0.0.2  # NWworkstation1

ping 172.16.16.2  # SWworkstation1


###################### Run scripts/route_block ######################
####### These commands are to check the correctness of the scripts/route_block
ping 10.0.0.2  # NWworkstation1

ping 172.16.16.2  # SWworkstation1

tcpdump -nnti ethX icmp  # NWrouter & SWrouter


###################### Run scripts/NAT ######################
####### These commands are to check the correctness of the scripts/NAT
ping 3.5.7.18  # NWworkstation1

tcpdump -nnti ethX  # ISrouter


###################### Run scripts/port_fw ######################
####### These commands are to check the correctness of the scripts/port_fw
lynx 3.5.7.18  # NWworkstation1

tcpdump -nnti ethX   # SWrouter's external interface