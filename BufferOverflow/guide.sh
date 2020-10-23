###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net 'ssh -tt server.bufferOf.OffTech 'sudo -s''

###################### Send the Scripts ######################
sftp otech2ae@users.deterlab.net
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/2.BufferOverflow/scripts
put /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/2.BufferOverflow/webserver.c

put /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/2.BufferOverflow/fhttpd/webserver.c

###################### Get the webserver code ######################
sftp otech2ae@users.deterlab.net
get webserver.c /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/2.BufferOverflow/original/


