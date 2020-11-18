#!/bin/bash

if [ "$#" -ne 2 ];then
    echo "Usage: ./check_response_time.sh <target> <wait time>";
    exit 0
fi

while : 
do 
    number=$((1 + $RANDOM % 10))
    url="${1}/${number}.html"
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null $url
    sleep $2
done