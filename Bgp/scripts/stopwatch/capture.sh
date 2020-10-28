#!/bin/bash

file_name="output.pcap"
Interface="false"
timeout_num="185s"

############## Reading inputs ##############
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
  -i) # Interface
    Interface="${2}"
    shift
    shift
    ;;
  -w) # File to write the output
  file_name="${2}"
  shift
  shift
  ;;
  *) # unknown option
    shift
    shift
    ;;
  esac
done

# Ask to the user to introduce the correct interface if it was not introduced as an input
if [ $Interface = "false" ]; then
  echo "What interface do you want to use?"
  read Interface
fi

cd /tmp/

sudo timeout "$timeout_num" tcpdump -s 0 -nn -i "$Interface" -w "$file_name" port 80

