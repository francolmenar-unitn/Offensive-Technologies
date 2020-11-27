#!/usr/bin/env bash

LOG_FOLDER=/var/log/apache2
ACCESS_LOG=$LOG_FOLDER/access.log
ERROR_LOG=$LOG_FOLDER/error.log
OTHER_HOST_LOG=$LOG_FOLDER/other_vhosts_access.log

# Treat the input argument of the bash script
read_input() {
  username='otech2ae' # Default username

  ############## Reading inputs ##############
  while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -u) # Get the Username from the input
      username="${2}"
      shift
      shift
      ;;
    *) # unknown option
      shift
      shift
      ;;
    esac
  done

  echo "$username" # Return the username
}

deter_user=$(read_input "$@")             # Read the username to be used
ssh_user="$deter_user@users.deterlab.net" # Construct the SSH user login command
deter_user_path="/users/$deter_user"      # Path to the default folder of the deter user

project="client1.CCTF-G2.OffTech"

# $ERROR_LOG $OTHER_HOST_LOG

echo $ACCESS_LOG

ssh -tt "$ssh_user" "ssh -tt $project 'sudo -s; rm $ACCESS_LOG;' exit;"
