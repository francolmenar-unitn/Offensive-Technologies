#!/bin/bash
timeout_num="110s"
high_rate="100000" # 100k

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

echo "Starting attack traffic for '$timeout_num' with a high rate of '$high_rate'"

# 100 seconds of attack traffic
timeout "$timeout_num" ./attack.sh -r "$high_rate"

echo "Attack traffic finished"
