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

# I don't know yet if I'll need it
path_test() {
  current_path=$(pwd)  # Get the current directory path

  echo "$current_path" # Debug

  IFS='/'
  read -raarr_path <<<"$current_path" # Split the path by '/'
  IFS=''                              # Set IFS back to whitespace

  for word in "${arr_path[@]}"; do
    echo $word
  done

}

deter_user=$(read_input "$@") # Read the username to be used
sftp_user="'$deter_user'@users.deterlab.net" # Construct the SSH user login command

script_path="" # To be created
config_path="resilient_server"

deter_user_path=":/users/$deter_user/"  # Path to the default folder of the deter user

# scp "$config_path" "$sftp_user$sftp_path"
