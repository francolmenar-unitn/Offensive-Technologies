#!/usr/bin/env bash

config_path="/Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts/DoS/scripts"
rules_path="/Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts/DoS/rules"

sftp_user="otech2ae@users.deterlab.net"
sftp_path=":/users/otech2ae/."

scp -r "$config_path" "$sftp_user$sftp_path"
scp -r "$rules_path" "$sftp_user$sftp_path"
