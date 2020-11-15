#!/bin/bash

echo "Usage: ./apache_benchmark_tool.sh <threads [default 400]> <requests [default 50000]> <target>"

THREADS=0
REQUESTS=0
TARGET=""

if [ "$#" -ne 3 ];then
    THREADS=400
    REQUESTS=50000
    TARGET="http://10.1.5.2/"
else
    THREADS=$1
    REQUESTS=$2
    TARGET=$3
fi



if ! which ab &> /dev/null
then
    echo "Apache2 benchmark tools not installed. Installing now..."
    sudo apt install apache2-utils
fi

ab -c $THREADS -n $REQUESTS -r $TARGET