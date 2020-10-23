#!/bin/bash

sleep_num="30s"
timeout_num="120s"

echo "Sleeping for $sleep_num"

# 30 seconds of normal traffic
sleep "$sleep_num"

echo "Starting attack traffic"

# 120 seconds of attack traffic
timeout "$timeout_num" ./scripts/traffic/attack.sh

echo "Attack traffic stop"
