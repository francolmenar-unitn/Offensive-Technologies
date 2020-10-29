############################################ BGP ############################################
###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net "ssh -tt server.BGN.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt attacker.BGN.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt client.BGN.OffTech 'sudo -s'"

ssh -tt otech2ae@users.deterlab.net "ssh -tt asn1.BGN.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt asn2.BGN.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt asn3.BGN.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt asn4.BGN.OffTech 'sudo -s'"


###################### SFTP login and Sending the Scripts ######################
sftp otech2ae@users.deterlab.net

put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Bgp/scripts
