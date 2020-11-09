#!/usr/bin/env bash

folder="DoS"

###################### Capture with NO attack ######################
echo -e "\t\t\tThe capture for ROUTER with NO rate and NO attack is going to be performed."

while true
do
  echo -e "\t\tIntroduce yes when the server and snort are ready to start the capture"

  read -r query_id

  case $query_id in
    'yes')
      echo "Starting the capture"
      ssh -tt otech2ae@users.deterlab.net "ssh -tt router.snort-2bk.OffTech 'mkdir $folder; sudo timeout 60s tcpdump -s 0 -w $folder/router_no_attack_no_rate.pcap; exit'; exit"
      echo "Capture finished"
      break;
      ;;
    *)
      echo -e "\t\t\tPlease introduce a yes when you are ready."
      ;;
  esac
done


###################### Capture with attack ######################
echo ""
echo -e "\t\t\tThe capture for ROUTER with NO rate and attack is going to be performed."

while true
do
  echo -e "\t\tIntroduce yes when the server and snort are ready to start the capture"

  read -r query_id

  case $query_id in
    'yes')
      echo "Starting the capture"
      ssh -tt otech2ae@users.deterlab.net "ssh -tt router.snort-2bk.OffTech 'sudo timeout 60s tcpdump -s 0 -w $folder/router_attack_no_rate.pcap; exit'; exit"
      echo "Capture finished"
      exit 0
      ;;
    *)
      echo -e "\t\t\tPlease introduce a yes when you are ready."
      ;;
  esac
done