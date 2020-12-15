#!/bin/bash

if [ "$#" -ne 2 ];then
    echo "Usage: ./check_response_time.sh <target> <wait time>";
    exit 0
fi

while : 
do
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null $1
    sleep $2
done