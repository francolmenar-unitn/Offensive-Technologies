#!/bin/bash

Interface="false"
timeout_num="180s"

############## Reading inputs ##############
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
  -i) # Interface
    Interface="${2}"
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

echo "Starting normal traffic"

# Send normal traffic for 180 seconds
timeout "$timeout_num" ./scripts/traffic/send_traffic.sh -i "$Interface"

echo "Normal traffic stop"
