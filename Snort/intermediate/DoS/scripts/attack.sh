#!/bin/bash
high_rate=100000 # 100k

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

flooder --dst 100.1.10.10 --highrate "$high_rate" --proto 6 --dportmin 80 --dportmax 80 --src 100.1.5.10 --srcmask 255.255.255.0
