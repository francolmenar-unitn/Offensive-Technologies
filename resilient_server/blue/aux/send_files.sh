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

# Get the desired path to run the commands
calc_path() {
  current_path=$(pwd) # Get the current directory path

  IFS='/'
  read -raarr_path <<<"$current_path" # Split the path by '/'
  IFS=''                              # Set IFS back to whitespace

  str_pos=0 # Index which will store the position of the last element of the path

  for ((i = 0; i < "${#arr_path[@]}"; i++)); do
    if [ "${arr_path[i]}" == "$1" ]; then
      str_pos=$i
    fi
  done

  return_path=""

  for ((i = 1; i <= str_pos; i++)); do # Position 0 is empty that's why it starts at 1
    return_path="$return_path/${arr_path[i]}"
  done

  echo "$return_path"
}

deter_user=$(read_input "$@")               # Read the username to be used
ssh_user="$deter_user@users.deterlab.net"   # Construct the SSH user login command
deter_user_path=":/users/$deter_user/"      # Path to the default folder of the deter user

reference_path="resilient_server"           # It is the folder from which all the content is going to be copied
project_path=$(calc_path "$reference_path") # Create the path on which the commands are going to be run

project_path="$project_path/blue" # In case only blue wants to be sent

scp -r "$project_path" "$ssh_user$deter_user_path"
