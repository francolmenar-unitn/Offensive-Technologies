############################################ SQLi ############################################
###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net 'ssh -tt server.SQLi.OffTech 'sudo -s''

###################### Send the Scripts ######################
sftp otech2ae@users.deterlab.net
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/scripts

###################### Send the original Path code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/original_sqli
###################### Send the fixed Path code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/fixed_sqli
###################### Send the Patch code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/patch_sqli

###################### Get the Patch code ######################
get -r patch_sqli/ /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/


###################### Get the Original code ######################
get -r cgi-bin /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/sqli/original_sqli/


ssh -L 8118:bpc215:80 otech2ae@users.deterlab.net
