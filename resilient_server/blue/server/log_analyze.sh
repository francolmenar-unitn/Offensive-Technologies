#!/usr/bin/env bash

# By https://edmondscommerce.github.io/bash/apache-log-file-analysis-script.html

###### SETUP ############
LOG_FOLDER=/var/log/apache2
ACCESS_LOG=$LOG_FOLDER/access.log

while sleep 1;do
  count_rows=$(awk '{count++} END {print "count"}' $ACCESS_LOG)

  echo "The count of rows is $count_rows"
done
