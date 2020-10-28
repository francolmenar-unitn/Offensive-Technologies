#!/bin/bash

sleep_num="30s"
timeout_num="120s"
high_rate="100"

############## Reading inputs ##############
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
  -r) # High rate
    high_rate="${2}"
    shift
    shift
    ;;
  *) # unknown option
    shift
    shift
    ;;
  esac
done

echo "Sleeping for $sleep_num"

# 30 seconds of normal traffic
sleep "$sleep_num"

echo "Starting attack traffic"

# 120 seconds of attack traffic
timeout "$timeout_num" ./scripts/traffic/attack.sh -r "$high_rate"

echo "Attack traffic stop"
