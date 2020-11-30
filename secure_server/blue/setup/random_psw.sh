#!/bin/bash
choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; } 
#Choose takes one argument, a string, and randomly selects a character from that string
pass="$({
    choose '!@#^&'
    choose '0123456789'
    choose 'abcdefghijklmnopqrstuvwxyz'
    choose 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    # In this way we have for sure one symbol, number, uppercase
    for i in $(seq 1 $((4+RANDOM % 10)))
    do
        choose '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    done
    # Then a random number of char
} | sort -R | awk '{printf "%s",$1}')"
# sort -R, random sort and then awk
echo $pass
echo $pass >> passwords
