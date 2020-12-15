#!/usr/bin/env bash

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

ssh -tt "$ssh_user" "ssh -tt $project 'rm -r $deter_user_path/blue; rm -r $deter_user_path/resilient_server;exit;' exit;"
