############################################ TCP SYN Flood ############################################
###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net 'ssh -tt server.TCP.OffTech 'sudo -s''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt attacker.TCP.OffTech 'sudo -s''
ssh -tt otech2ae@users.deterlab.net 'ssh -tt client.TCP.OffTech 'sudo -s''

############## Install Apache - on the SERVER ##############
cd /share/education/TCPSYNFlood_USC_ISI/ && ./install-server

############## Install the floader - on the ATTACKER ##############
cd /share/education/TCPSYNFlood_USC_ISI/ && ./install-flooder

############## Check if the SYN cookies are enabled - on the SERVER ##############
sudo sysctl net.ipv4.tcp_syncookies

############## Set the cookies - on the SERVER ##############
sudo sysctl -w net.ipv4.tcp_syncookies=0 &&  sysctl -w net.ipv4.tcp_max_syn_backlog=10000

############## Capture the packets - on the CLIENT ##############

###################### SFTP login and Sending the Scripts ######################
sftp otech2ae@users.deterlab.net

put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/4.TCP_SYN_Flood/scripts

get output.pcap /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/4.TCP_SYN_Flood/pcap