############################################ Snort ############################################
###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net "ssh -tt snort.snort-2bk.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt client1.snort-2bk.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt client2.snort-2bk.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt outsider.snort-2bk.OffTech 'sudo -s'"
ssh -tt otech2ae@users.deterlab.net "ssh -tt server.snort-2bk.OffTech 'sudo -s'"


###################### SFTP login and Sending the Scripts ######################
sftp otech2ae@users.deterlab.net

put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts

get /users/otech2ae/snort.conf /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts/guard/