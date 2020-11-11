#!/usr/bin/env bash

###################### Capture with NO rules ######################
echo -e "\t\t\tThe capture with NO rules is going to be performed."

while true
do
  echo -e "\t\tIntroduce yes when the server and snort are ready to start the capture"

  read -r query_id

  case $query_id in
    'yes')
      echo "Starting the capture"
      ssh -tt otech2ae@users.deterlab.net "ssh -tt server.snort-2bk.OffTech 'sudo timeout 60s tcpdump -s 0 -w guard_no_rule.pcap; exit'; exit"
      echo "Capture finished"
      break;
      ;;
    *)
      echo -e "\t\t\tPlease introduce a yes when you are ready."
      ;;
  esac
done


###################### Capture with rules ######################
echo ""
echo -e "\t\t\tThe capture with rules is going to be performed."

while true
do
  echo -e "\t\tIntroduce yes when the server and snort are ready to start the capture"

  read -r query_id

  case $query_id in
    'yes')
      echo "Starting the capture"
      ssh -tt otech2ae@users.deterlab.net "ssh -tt server.snort-2bk.OffTech 'sudo timeout 60s tcpdump -s 0 -w guard_rule.pcap; exit'; exit"
      echo "Capture finished"
      exit 0
      ;;
    *)
      echo -e "\t\t\tPlease introduce a yes when you are ready."
      ;;
  esac
done