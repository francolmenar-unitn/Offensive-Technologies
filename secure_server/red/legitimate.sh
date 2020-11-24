#!/bin/bash

if [ "$#" -ne 1 ];then
    echo "Usage: ./legitimate.sh <target>";
    exit 0
fi

while :
do
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=legitimate&pass=dummy&drop=register"
    sleep 1
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=legitimate&pass=dummy&amount=1000&drop=deposit"
    sleep 1
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=legitimate&pass=dummy&amount=1000&drop=withdraw"
    sleep 1
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=legitimate&pass=dummy&&drop=balance"
done