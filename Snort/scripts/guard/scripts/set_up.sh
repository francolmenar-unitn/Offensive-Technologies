#!/usr/bin/env bash

config_path="/Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts/guard/rules/snort.config"
sftp_user="otech2ae@users.deterlab.net"
sftp_path=":/users/otech2ae/."

ssh -tt otech2ae@users.deterlab.net "ssh -tt client1.snort-2bk.OffTech 'mkdir alerts;exit'; exit"
scp "$config_path" "$sftp_user$sftp_path"