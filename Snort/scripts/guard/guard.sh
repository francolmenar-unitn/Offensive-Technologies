#!/usr/bin/env bash

# /usr/local/snort-2.9.2.2/etc
# /usr/local/snort-2.9.2.2/etc/snort.conf
# /usr/local/snort-2.9.2.2/etc

mkdir /usr/local/snort-2.9.2.2/rules
touch /usr/local/snort-2.9.2.2/local.rules

mkdir alerts

sudo snort --daq nfq -Q -c snort.config -l alerts