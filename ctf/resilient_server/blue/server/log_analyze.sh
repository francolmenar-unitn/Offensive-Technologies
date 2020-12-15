#!/usr/bin/env bash

###### Setup Variables ############
LOG_FOLDER=/var/log/apache2
ACCESS_LOG=$LOG_FOLDER/access.log
ERROR_LOG=$LOG_FOLDER/error.log
OTHER_HOST_LOG=$LOG_FOLDER/other_vhosts_access.log

count_rows=0     # Initialize the counters
count_rows_err=0
count_rows_vhost=0

while sleep 1; do
  ############################ HTTP Requests ############################
  count_aux=$(awk 'BEGIN{count=0} {count++;} END {print count}' $ACCESS_LOG) # Total amount of current rows - Http Log

  new_rows_count=$(expr $count_aux - $count_rows) # Calculate the number of new rows
  count_rows=$count_aux                           # Assign the actual number of rows to the count

  # Obtain the content of the new requests  TODO Change the hardcoded IP
  rows_val=$(awk '{if (!($1=="10.1.5.3")) print "\t src: "$1 "\t\t content: "$6,$7,$8;}' $ACCESS_LOG | tail -"$new_rows_count")

  ############################ Error Logs ############################
  count_aux_err=$(awk 'BEGIN{count=0} {count++;} END {print count}' $ERROR_LOG) # Total amount of current rows - Error Log

  new_rows_count_err=$(expr $count_aux_err - $count_rows_err) # Calculate the number of new rows
  count_rows_err=$count_aux_err

  # Obtain the content of the error logs
  rows_val_err=$(awk '{print $0;}' $ERROR_LOG | tail -"$new_rows_count_err")

  ############################ Other Vhosts Access ############################
  count_aux_vhost=$(awk 'BEGIN{count=0} {count++;} END {print count}' $OTHER_HOST_LOG) # Total amount of current rows - Vhosts Log

  new_rows_count_vhost=$(expr $count_aux_vhost - $count_rows_vhost) # Calculate the number of new rows
  count_rows_vhost=$count_aux_vhost

  # Obtain the content of the error logs
  rows_val_vhost=$(awk '{print $0;}' $OTHER_HOST_LOG | tail -"$new_rows_count_vhost")

  ############################ Printing ############################
  # Check to know that there is something else to be printed
  if [ "$new_rows_count" -ne "0" ] || [ "$new_rows_count_err" -ne "0" ] || [ "$new_rows_count_vhost" -ne "0" ]; then

    date | awk '{print $4}'

    if [ "$new_rows_count" -ne "0" ]; then  # HTTP request logs
      echo -e "\t\t$new_rows_count New requests"
      echo -e "\t\t\t$rows_val"
    fi

    if [ "$new_rows_count_err" -ne "0" ]; then  # Error logs
      echo ""
      echo -e "\t\t$new_rows_count_err New errors"
      echo -e "\t$rows_val_err"
    fi

    if [ "$new_rows_count_vhost" -ne "0" ]; then  # Vhost logs
      echo ""
      echo -e "\t\t$new_rows_count_vhost New Other Vhosts Access"
      echo -e "\t$rows_val_vhost"
    fi
  echo "----------------------------------------------------------------------------------------------------------------------------"

  fi
done
