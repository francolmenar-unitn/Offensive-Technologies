#!/bin/bash
#make script executable with chmod u+x analyze-traffic.sh
#to run the script use the command ./analyze-traffic.sh

#ssh into router
ssh router.snort-2bk.OffTech.isi.deterlab.net

#determine network interfaces
ifconfig

#capture data going to the server
echo "Provide interface: "
read interface
sudo tcpdump -i interface -s 0 -w /tmp/dump.pcap

#copy pcap file to local
#pscp.exe -P 22 username@users.isi.deterlab.net:/tmp/dump.pcap .