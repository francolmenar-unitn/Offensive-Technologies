#!/bin/bash
cd /home/test/

while :
do
java -jar FileServer.jar & sleep 4; killall java
done
