#!/bin/bash

cd /home/test

while :
do
java -jar FileClient.jar bob password server export.txt & \
java -jar FileClient.jar bob password server export.xml & \
java -jar FileClient.jar joe password1 server classified.txt & \
java -jar FileClient.jar candice monday server ducky.txt & \
java -jar FileClient.jar billy thursday server users.txt & \
sleep 3; sudo killall java

done
