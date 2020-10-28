#!/bin/bash
high_rate=100

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

flooder --dst 5.6.7.8 --highrate "$high_rate" --proto 6 --dportmin 80 --dportmax 80 --src 1.1.2.4  --srcmask 255.255.255.0
