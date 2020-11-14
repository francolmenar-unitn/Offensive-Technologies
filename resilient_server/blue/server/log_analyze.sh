#!/usr/bin/env bash

###### Setup Variables ############
LOG_FOLDER=/var/log/apache2
ACCESS_LOG=$LOG_FOLDER/access.log
ERROR_LOG=$LOG_FOLDER/error.log

count_rows=0  # Initialize the counter
count_rows_err=0  # Initialize the counter

while sleep 1;do
  ############################ HTTP Requests ############################
  count_aux=$(awk '{count++;} END {print count}' $ACCESS_LOG) # Total amount of current rows - Http Log

  new_rows_count=$(expr $count_aux - $count_rows)  # Calculate the number of new rows
  count_rows=$count_aux # Assign the actual number of rows to the count

  # Print the content of the new requests
  rows_val=$(awk '{print "\t src: "$1 "\t\t content: "$6,$7,$8;}' $ACCESS_LOG | tail -"$new_rows_count" )

  ############################ Error Logs ############################
  count_aux_err=$(awk '{count++;} END {print count}' $ERROR_LOG) # Total amount of current rows - Error Log

  new_rows_count_err=$(expr $count_aux_err - $count_rows_err)  # Calculate the number of new rows
  count_rows_err=$count_aux_err # Assign the actual number of rows to the count

  # Print the content of the new requests
  rows_val_err=$(awk '{print $0;}' $ERROR_LOG | tail -"$new_rows_count_err" )

  ############################ Printing ############################
  date | awk '{print $4}'
  echo -e "\t\t$new_rows_count new requests"
  echo -e "\t\t\t$rows_val"

  echo ""
  echo -e "\t\t$new_rows_count_err new errors"
  echo -e "\t$rows_val_err"
  echo "----------------------------------------------------------------------------------------------------------------------------"
done
