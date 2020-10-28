#!/bin/bash

echo ""
echo "This should be executed from the CLIENT"

while true
do
  echo ""
  echo "What command do you want to run?"
  echo ""
  echo ""

  echo "[1] traceroute -n 10.1.1.2"
  echo "[2] ftp 10.1.1.2"

  read -r query_id

  case $query_id in
    1)
      traceroute -n 10.1.1.2
      ;;

    2)
      ftp 10.1.1.2
      ;;
    *)
      echo "Please introduce a instruction number."
      ;;
  esac
  echo ""
done