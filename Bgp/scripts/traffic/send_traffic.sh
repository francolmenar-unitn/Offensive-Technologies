#!/bin/bash

Interface="false"

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


# while sleep 1; do curl --interface $Interface1 -H 'Cache-Control: no-cache' -x 5.6.7.8:80 index.html; done

while sleep 1; do curl --interface "$Interface" -x 5.6.7.8:80 index.html & done
