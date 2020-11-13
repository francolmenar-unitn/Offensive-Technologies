#!/usr/bin/env bash

# By https://edmondscommerce.github.io/bash/apache-log-file-analysis-script.html

###### SETUP ############
LOG_FOLDER=/var/log/apache2
ACCESS_LOG=$LOG_FOLDER/access.log

count_rows=0
while sleep 1;do
  count_aux=$(awk '{count++} END {print count}' $ACCESS_LOG) # Total amount of current rows

  new_rows_count=$(expr $count_aux - $count_rows)  # Calculate the number of new rows
  count_rows=$count_aux # Assign the actual number of rows to the count

  echo "$count_rows amount of total rows"
  echo "$new_rows_count new rows"
  echo "----------------------------------"
done
