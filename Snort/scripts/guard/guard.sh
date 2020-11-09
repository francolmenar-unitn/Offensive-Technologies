#!/usr/bin/env bash

mkdir alerts

sudo snort --daq nfq -Q -c snort.config -l alerts