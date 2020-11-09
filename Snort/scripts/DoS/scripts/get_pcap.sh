#!/usr/bin/env bash

pcap_path="/Users/fran/Documents/Estudios/Master/2º-Master/Semester1/Offensive/Offensive-Technologies/Snort/scripts/DoS/pcap"
sftp_user="otech2ae@users.deterlab.net"
sftp_path=":/users/otech2ae/DoS/*pcap"

scp "$sftp_user$sftp_path" "$pcap_path"