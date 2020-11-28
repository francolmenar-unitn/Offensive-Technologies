#!/bin/bash

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

reference_path="blue"              # It is the folder from which all the content is going to be copied
project_path=$(calc_path "$reference_path") # Create the path on which the commands are going to be run
project="server.CCTF2-G2.OffTech"

aux_path="$project_path/aux"  # Create the path to the aux folder
setup_path="$project_path/setup"  # Create the path to the server folder

echo "-------------- Running send_files.sh --------------"
"$aux_path/send_files.sh" -u "$deter_user"

echo "-------------- Adding executable options to server_setup.sh --------------"
ssh -tt "$ssh_user" "ssh -tt $project 'sudo chmod +x /users/$deter_user/blue/setup/server_setup.sh; exit;' exit;"

echo "-------------- Running server_setup.sh --------------"
ssh -tt "$ssh_user" "ssh -tt $project '/users/$deter_user/blue/setup/server_setup.sh; exit;' exit;"

echo "-------------- Running server_qos_setup.sh --------------"
"$setup_path/server_qos_setup.sh" -u "$deter_user"
