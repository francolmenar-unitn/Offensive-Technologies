############################################ Path ############################################
###################### SSH Login Commands ######################
ssh -tt otech2ae@users.deterlab.net 'ssh -tt server.pathEx.OffTech 'sudo -s''

###################### SFTP login and Sending the Scripts ######################
sftp otech2ae@users.deterlab.net
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/path/scripts

###################### Send the original Path code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/path/original_path
###################### Send the fixed Path code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/path/fixed_path
###################### Send the Patch code ######################
put -r /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/path/patch_path

###################### Get the Patch code ######################
get -r patch_path /Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Exercises/3.Path_Sql/path/patch_path
